package notification;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.FlxBasic;

class Notification extends FlxGroup
{
    public var id:String;
    public var title:String;
    public var message:String;
    public var timestamp:Float;
    public var isRead:Bool = false;
    public var type:NotificationType;
    public var duration:Float = 8.0;
    
    private var background:FlxSprite;
    private var shadowSprite:FlxSprite;
    private var titleText:FlxText;
    private var messageText:FlxText;
    private var timeText:FlxText;
    private var clickHintText:FlxText;
    private var iconSprite:FlxSprite;
    private var closeButton:FlxSprite;
    private var progressBar:FlxSprite;
    private var progressBackground:FlxSprite;
    private var glowEffect:FlxSprite;
    private var borderSprite:FlxSprite;
    
    public var width:Float = 400;
    public var height:Float = 120;
    public var onClicked:Notification->Void;
    public var onClosed:Notification->Void;
    
    // Position properties
    private var _x:Float = 0;
    private var _y:Float = 0;
    private var baseScale:Float = 1.0;
    private var targetScale:Float = 1.0;
    private var currentScale:Float = 1.0;
    private var pulseTimer:Float = 0;
    private var autoCloseTimer:Float = 8.0;
    private var isClosing:Bool = false;
    private var progressTween:FlxTween;
    private var glowTween:FlxTween;
    private var hoverTween:FlxTween;
    
    // For tracking scale during slideOut animation
    private var scaleTracker:{scale:Float};
    
    public var posX(get, set):Float;
    public var posY(get, set):Float;
    
    public function new(id:String, title:String, message:String, type:NotificationType = null, camera:FlxCamera = null)
    {
        super();
        
        this.id = id;
        this.title = title;
        this.message = message;
        this.type = type != null ? type : NotificationType.INFO;
        this.timestamp = haxe.Timer.stamp() * 1000;
        
        // Initialize scale tracker
        scaleTracker = {scale: 1.0};
        
        createShadow();
        createGlowEffect();
        createBackground();
        createBorder();
        createProgressBackground();
        createProgressBar();
        createIcon();
        createTexts();
        createCloseButton();
        
        // Start off-screen
        posX = FlxG.width + width;
        posY = -height - 20;

        //Camera
        if (camera == null) {
        this.cameras = FlxG.cameras.list;
        } else {
        this.cameras = [camera];
        }
        
        // Start entrance animation
        startEntranceAnimation();
    }
    
    private function createShadow():Void
    {
        /*shadowSprite = new FlxSprite();
        shadowSprite.makeGraphic(Std.int(width + 20), Std.int(height + 20), FlxColor.fromRGB(82, 81, 81));
        shadowSprite.alpha = 0.5;
        add(shadowSprite);*/
        
        // Create soft shadow effect
        createSoftShadow();
    }
    
    private function createSoftShadow():Void
    {
        // Multiple shadow layers for soft effect
        for (i in 0...5)
        {
            var shadowLayer = new FlxSprite();
            var offset = i * 2;
            var alpha = 0.05 - (i * 0.01);
            shadowLayer.makeGraphic(Std.int(width + offset), Std.int(height + offset), FlxColor.fromRGB(82, 81, 81));
            shadowLayer.alpha = alpha;
            add(shadowLayer);
        }
    }
    
    private function createGlowEffect():Void
    {
        glowEffect = new FlxSprite();
        glowEffect.makeGraphic(Std.int(width + 30), Std.int(height + 30), getTypeColor());
        glowEffect.alpha = 0.0;
        glowEffect.blend = ADD;
        add(glowEffect);
    }
    
    private function createBackground():Void
    {
        background = new FlxSprite();
        background.makeGraphic(Std.int(width), Std.int(height), FlxColor.fromRGB(82, 81, 81));
        background.alpha = 0.98;
        add(background);
        
        // Create highly rounded corners
        createRoundedBackground();
    }
    
    private function createBorder():Void
    {
        borderSprite = new FlxSprite();
        borderSprite.makeGraphic(Std.int(width + 4), Std.int(height + 4), getTypeColor());
        borderSprite.alpha = 0.3;
        add(borderSprite);
    }
    
    private function createRoundedBackground():Void
    {
        var cornerRadius = 25;
        
        // Create a more sophisticated rounded rectangle
        background.pixels.fillRect(background.pixels.rect, FlxColor.fromRGB(82, 81, 81));
        
        // Fill the main rectangle areas
        //background.pixels.fillRect(new openfl.geom.Rectangle(cornerRadius, 0, width - 2 * cornerRadius, height), FlxColor.fromRGB(82, 81, 81));
        //background.pixels.fillRect(new openfl.geom.Rectangle(0, cornerRadius, width, height - 2 * cornerRadius), FlxColor.fromRGB(82, 81, 81));
        
        // Draw rounded corners with anti-aliasing effect
        for (i in 0...cornerRadius)
        {
            for (j in 0...cornerRadius)
            {
                var distance = Math.sqrt((i - cornerRadius) * (i - cornerRadius) + (j - cornerRadius) * (j - cornerRadius));
                if (distance <= cornerRadius)
                {
                    var alpha = 1.0 - Math.max(0, distance - cornerRadius + 1);
                    var color = FlxColor.BLACK;
                    color.alpha = Std.int(alpha * 255);
                    
                    // Top-left
                    background.pixels.setPixel32(cornerRadius + i, cornerRadius + j, color);
                    // Top-right
                    background.pixels.setPixel32(Std.int(width + cornerRadius - i), cornerRadius + j, color);
                    // Bottom-left
                    background.pixels.setPixel32(cornerRadius + i, Std.int(height + cornerRadius - j), color);
                    // Bottom-right
                    background.pixels.setPixel32(Std.int(width + cornerRadius - i), Std.int(height + cornerRadius - j), color);
                }
            }
        }
        background.dirty = true;
    }
    
    private function createProgressBackground():Void
    {
        progressBackground = new FlxSprite(0, height - 6);
        progressBackground.makeGraphic(Std.int(width), 6, FlxColor.fromRGB(240, 240, 240));
        progressBackground.alpha = 0.8;
        add(progressBackground);
    }
    
    private function createProgressBar():Void
    {
        progressBar = new FlxSprite(0, height - 6);
        progressBar.makeGraphic(Std.int(width), 6, getTypeColor());
        progressBar.scale.x = 1.0;
        progressBar.alpha = 0.9;
        add(progressBar);
    }
    
    private function createIcon():Void
    {
        iconSprite = new FlxSprite(25, 25);
        
        var iconColor = getTypeColor();
        iconSprite.makeGraphic(32, 32, iconColor);
        
        createIconDetails(iconSprite, type);
        
        iconSprite.scale.set(0, 0);
        iconSprite.angle = -180;
        add(iconSprite);
        
        FlxTween.tween(iconSprite.scale, {x: 1, y: 1}, 0.6, {
            ease: FlxEase.elasticOut,
            startDelay: 0.2
        });
        
        FlxTween.tween(iconSprite, {angle: 0}, 0.8, {
            ease: FlxEase.backOut,
            startDelay: 0.2
        });
    }
    
    private function createIconDetails(sprite:FlxSprite, type:NotificationType):Void
    {
        sprite.pixels.fillRect(sprite.pixels.rect, FlxColor.TRANSPARENT);
        
        var centerX = 16;
        var centerY = 16;
        var radius = 12;
        
        for (i in 0...32)
        {
            for (j in 0...32)
            {
                var distance = Math.sqrt((i - centerX) * (i - centerX) + (j - centerY) * (j - centerY));
                if (distance <= radius)
                {
                    sprite.pixels.setPixel32(i, j, getTypeColor());
                }
            }
        }
        
        var symbolColor = FlxColor.BLACK;
        switch(type)
        {
            case NotificationType.INFO:
                for (i in 14...18)
                {
                    for (j in 8...24)
                    {
                        if ((j >= 8 && j <= 10) || (j >= 12 && j <= 22))
                        {
                            sprite.pixels.setPixel32(i, j, symbolColor);
                        }
                    }
                }
                
            case NotificationType.SUCCESS:
                var checkPoints = [
                    {x: 10, y: 16}, {x: 11, y: 17}, {x: 12, y: 18},
                    {x: 13, y: 17}, {x: 14, y: 16}, {x: 15, y: 15},
                    {x: 16, y: 14}, {x: 17, y: 13}, {x: 18, y: 12},
                    {x: 19, y: 11}, {x: 20, y: 10}, {x: 21, y: 9}
                ];
                for (point in checkPoints)
                {
                    sprite.pixels.setPixel32(point.x, point.y, symbolColor);
                    sprite.pixels.setPixel32(point.x + 1, point.y, symbolColor);
                    sprite.pixels.setPixel32(point.x, point.y + 1, symbolColor);
                }
                
            case NotificationType.WARNING:
                for (i in 14...18)
                {
                    for (j in 8...20)
                    {
                        sprite.pixels.setPixel32(i, j, symbolColor);
                    }
                    for (j in 22...24)
                    {
                        sprite.pixels.setPixel32(i, j, symbolColor);
                    }
                }
                
            case NotificationType.ERROR:
                for (i in 0...8)
                {
                    sprite.pixels.setPixel32(10 + i, 10 + i, symbolColor);
                    sprite.pixels.setPixel32(11 + i, 10 + i, symbolColor);
                    sprite.pixels.setPixel32(10 + i, 21 - i, symbolColor);
                    sprite.pixels.setPixel32(11 + i, 21 - i, symbolColor);
                }
        }
        
        sprite.dirty = true;
    }
    
    private function createTexts():Void
    {
        titleText = new FlxText(70, 25, width - 110, title);
        titleText.setFormat(null, 13, FlxColor.WHITE, LEFT);
        titleText.bold = true;
        titleText.alpha = 0;
        titleText.y -= 10;
        add(titleText);
        
        messageText = new FlxText(70, 50, width - 110, message);
        messageText.setFormat(null, 10, FlxColor.fromRGB(187, 187, 187), LEFT);
        messageText.wordWrap = true;
        messageText.alpha = 0;
        messageText.y -= 10;
        add(messageText);
        
        timeText = new FlxText(70, height - 35, width - 110, "Just now");
        timeText.setFormat(null, 11, FlxColor.fromRGB(156, 156, 156), LEFT);
        timeText.alpha = 0;
        timeText.y += 10;
        add(timeText);
        
        clickHintText = new FlxText(70, height - 20, width - 110, "Click to view details");
        clickHintText.setFormat(null, 10, getTypeColor(), LEFT);
        clickHintText.alpha = 0;
        clickHintText.y += 10;
        add(clickHintText);
        
        FlxTween.tween(titleText, {alpha: 1}, 0.4, {
            ease: FlxEase.quartOut,
            startDelay: 0.3
        });
        
        FlxTween.tween(messageText, {alpha: 1, y: messageText.y + 10}, 0.4, {
            ease: FlxEase.quartOut,
            startDelay: 0.4
        });
        
        FlxTween.tween(timeText, {alpha: 1, y: timeText.y + 10}, 0.4, {
            ease: FlxEase.quartOut,
            startDelay: 0.5
        });
        
        FlxTween.tween(clickHintText, {alpha: 0.7, y: clickHintText.y + 10}, 0.4, {
            ease: FlxEase.quartOut,
            startDelay: 0.6
        });
        
        FlxTween.tween(clickHintText, {alpha: 0.3}, 2.0, {
            type: FlxTweenType.PINGPONG,
            ease: FlxEase.sineInOut,
            startDelay: 1.5
        });
    }
    
    private function createCloseButton():Void
    {
        closeButton = new FlxSprite(width - 45, 20);
        closeButton.makeGraphic(30, 30, FlxColor.fromRGB(71, 71, 71));
        closeButton.alpha = 0.7;
        closeButton.scale.set(0, 0);
        closeButton.angle = 180;
        add(closeButton);
        
        createCloseButtonSymbol();
        
        FlxTween.tween(closeButton.scale, {x: 1, y: 1}, 0.5, {
            ease: FlxEase.elasticOut,
            startDelay: 0.8
        });
        
        FlxTween.tween(closeButton, {angle: 0}, 0.6, {
            ease: FlxEase.backOut,
            startDelay: 0.8
        });
    }
    
    private function createCloseButtonSymbol():Void
    {
        var symbolColor = FlxColor.fromRGB(100, 100, 100);
        for (i in 0...12)
        {
            closeButton.pixels.setPixel32(9 + i, 9 + i, symbolColor);
            closeButton.pixels.setPixel32(10 + i, 9 + i, symbolColor);
            closeButton.pixels.setPixel32(9 + i, 20 - i, symbolColor);
            closeButton.pixels.setPixel32(10 + i, 20 - i, symbolColor);
        }
        closeButton.dirty = true;
    }
    
    private function getTypeColor():FlxColor
    {
        return switch(type)
        {
            case NotificationType.INFO: FlxColor.fromRGB(54, 104, 199);
            case NotificationType.SUCCESS: FlxColor.fromRGB(52, 183, 46);
            case NotificationType.WARNING: FlxColor.fromRGB(225, 232, 60);
            case NotificationType.ERROR: FlxColor.fromRGB(219, 38, 38);
        }
    }
    
    private function startEntranceAnimation():Void
    {
        FlxTween.tween(this, {posX: FlxG.width - width - 20}, 0.8, {
            ease: FlxEase.backOut
        });
        
        FlxTween.tween(this, {posY: 20}, 0.6, {
            ease: FlxEase.bounceOut,
            startDelay: 0.2
        });
        
        glowTween = FlxTween.tween(glowEffect, {alpha: 0.4}, 0.3, {
            onComplete: function(_) {
                FlxTween.tween(glowEffect, {alpha: 0.1}, 0.5, {
                    onComplete: function(_) {
                        FlxTween.tween(glowEffect, {alpha: 0.3}, 0.3, {
                            onComplete: function(_) {
                                FlxTween.tween(glowEffect, {alpha: 0}, 0.8);
                            }
                        });
                    }
                });
            }
        });
        
        progressTween = FlxTween.tween(progressBar.scale, {x: 0}, autoCloseTimer, {
            ease: FlxEase.linear,
            startDelay: 1.0,
            onComplete: function(_) {
                if (!isClosing) slideOut();
            }
        });
        
        FlxTween.tween(borderSprite, {alpha: 0.6}, 1.0, {
            type: FlxTweenType.PINGPONG,
            ease: FlxEase.sineInOut,
            startDelay: 1.0
        });
    }
    
    public function slideOut():Void
    {
        if (isClosing) return;
        isClosing = true;
        
        if (progressTween != null) progressTween.cancel();
        if (glowTween != null) glowTween.cancel();
        if (hoverTween != null) hoverTween.cancel();
        
        // Reset scale tracker
        scaleTracker.scale = currentScale;
        
        // Stage 1: Scale down slightly using the scale tracker
        FlxTween.tween(scaleTracker, {scale: 0.95}, 0.2, {
            ease: FlxEase.quartIn,
            onUpdate: function(tween:FlxTween) {
                currentScale = scaleTracker.scale;
                applyScaleToMembers(currentScale);
            },
            onComplete: function(_) {
                // Stage 2: Slide out to the right
                FlxTween.tween(this, {posX: FlxG.width + 100}, 0.4, {
                    ease: FlxEase.backIn
                });
                
                // Stage 3: Fade out
                var alphaTracker = {alpha: 1.0};
                FlxTween.tween(alphaTracker, {alpha: 0}, 0.4, {
                    onUpdate: function(tween:FlxTween) {
                        var currentAlpha = alphaTracker.alpha;
                        for (i in 0...members.length)
                        {
                            var member = members[i];
                            if (member != null && Std.is(member, FlxSprite))
                            {
                                var sprite = cast(member, FlxSprite);
                                sprite.alpha = sprite.alpha * currentAlpha;
                            }
                        }
                    },
                    onComplete: function(_) {
                        if (onClosed != null) onClosed(this);
                    }
                });
            }
        });
    }
    
    override public function update(elapsed:Float):Void
    {
        if (isClosing) return;
        
        super.update(elapsed);
        
        pulseTimer += elapsed;
        
        updatePositions();
        
        var mouseOver = background != null && background.overlapsPoint(FlxG.mouse.getPosition());
        targetScale = mouseOver ? 1.03 : 1.0;
        
        var springForce = (targetScale - currentScale) * 10;
        var damping = 0.8;
        currentScale += springForce * elapsed * damping;
        currentScale = FlxMath.bound(currentScale, 0.97, 1.05);
        
        applyScaleToMembers(currentScale);
        
        if (mouseOver && glowEffect.alpha < 0.2)
        {
            if (hoverTween != null) hoverTween.cancel();
            hoverTween = FlxTween.tween(glowEffect, {alpha: 0.2}, 0.3, {ease: FlxEase.quartOut});
        }
        else if (!mouseOver && glowEffect.alpha > 0)
        {
            if (hoverTween != null) hoverTween.cancel();
            hoverTween = FlxTween.tween(glowEffect, {alpha: 0}, 0.5, {ease: FlxEase.quartOut});
        }
        
        if (FlxG.mouse.justPressed && mouseOver)
        {
            if (closeButton != null && closeButton.overlapsPoint(FlxG.mouse.getPosition()))
            {
                FlxTween.tween(closeButton.scale, {x: 0.7, y: 0.7}, 0.1, {
                    ease: FlxEase.quartIn,
                    onComplete: function(_) {
                        FlxTween.tween(closeButton, {angle: 90}, 0.2, {ease: FlxEase.quartIn});
                        FlxTween.tween(closeButton.scale, {x: 1.2, y: 1.2}, 0.1, {
                            ease: FlxEase.quartOut,
                            onComplete: function(_) {
                                slideOut();
                            }
                        });
                    }
                });
            }
            else
            {
                FlxTween.tween(background, {alpha: 0.7}, 0.1, {
                    onComplete: function(_) {
                        FlxTween.tween(background, {alpha: 0.98}, 0.2);
                        FlxTween.tween(glowEffect, {alpha: 0.5}, 0.1, {
                            onComplete: function(_) {
                                FlxTween.tween(glowEffect, {alpha: 0.1}, 0.3);
                            }
                        });
                        if (onClicked != null) onClicked(this);
                    }
                });
            }
        }
        
        if (closeButton != null && closeButton.overlapsPoint(FlxG.mouse.getPosition()))
        {
            closeButton.alpha = 1.0;
            closeButton.color = FlxColor.fromRGB(255, 120, 120);
            if (closeButton.scale.x < 1.1)
            {
                FlxTween.tween(closeButton.scale, {x: 1.1, y: 1.1}, 0.2, {ease: FlxEase.quartOut});
            }
        }
        else if (closeButton != null)
        {
            closeButton.alpha = 0.7;
            closeButton.color = FlxColor.fromRGB(220, 220, 220);
            if (closeButton.scale.x > 1.0)
            {
                FlxTween.tween(closeButton.scale, {x: 1.0, y: 1.0}, 0.2, {ease: FlxEase.quartOut});
            }
        }
    }
    
    private function applyScaleToMembers(scale:Float):Void
    {
        for (i in 0...members.length)
        {
            var member = members[i];
            if (member != null && Std.is(member, FlxSprite))
            {
                var sprite = cast(member, FlxSprite);
                sprite.scale.x = scale;
                sprite.scale.y = scale;
            }
        }
    }
    
    private function updatePositions():Void
    {
        for (i in 0...members.length)
        {
            var member = members[i];
            if (member != null && Std.is(member, FlxSprite))
            {
                var sprite = cast(member, FlxSprite);
                sprite.x = _x + (sprite.x - _x);
                sprite.y = _y + (sprite.y - _y);
            }
        }
    }
    
    public function markAsRead():Void
    {
        isRead = true;
        if (background != null) background.alpha = 0.85;
        if (titleText != null) titleText.alpha = 0.7;
        if (messageText != null) messageText.alpha = 0.7;
        if (borderSprite != null) borderSprite.alpha = 0.1;
    }
    
    private function get_posX():Float
    {
        return _x;
    }
    
    private function set_posX(value:Float):Float
    {
        var diff = value - _x;
        _x = value;
        for (i in 0...members.length)
        {
            var member = members[i];
            if (member != null && Std.is(member, FlxSprite))
            {
                var sprite = cast(member, FlxSprite);
                sprite.x += diff;
            }
        }
        return _x;
    }
    
    private function get_posY():Float
    {
        return _y;
    }
    
    private function set_posY(value:Float):Float
    {
        var diff = value - _y;
        _y = value;
        for (i in 0...members.length)
        {
            var member = members[i];
            if (member != null && Std.is(member, FlxSprite))
            {
                var sprite = cast(member, FlxSprite);
                sprite.y += diff;
            }
        }
        return _y;
    }
    
    override public function destroy():Void
    {
        if (progressTween != null)
        {
            progressTween.cancel();
            progressTween = null;
        }
        if (glowTween != null)
        {
            glowTween.cancel();
            glowTween = null;
        }
        if (hoverTween != null)
        {
            hoverTween.cancel();
            hoverTween = null;
        }
        
        onClicked = null;
        onClosed = null;
        
        super.destroy();
    }
}