package notification;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class NotificationListItem extends FlxGroup
{
    public var notification:NotificationData;
    public var onClicked:NotificationData->Void;
    public var baseY:Float;
    
    private var background:FlxSprite;
    private var iconSprite:FlxSprite;
    private var titleText:FlxText;
    private var messageText:FlxText;
    private var timeText:FlxText;
    private var unreadIndicator:FlxSprite;
    private var hoverOverlay:FlxSprite;
    
    private var itemWidth:Float;
    private var itemHeight:Float = 100;
    private var isDarkTheme:Bool = false;
    private var baseX:Float = 0;
    private var currentScale:Float = 1.0;
    
    public function new(x:Float, y:Float, width:Float, notification:NotificationData, darkTheme:Bool = false)
    {
        super();
        
        this.notification = notification;
        this.itemWidth = width;
        this.baseY = y;
        this.baseX = x;
        this.isDarkTheme = darkTheme;
        
        createBackground(x, y);
        createIcon(x, y);
        createTexts(x, y);
        createUnreadIndicator(x, y);
        createHoverOverlay(x, y);
    }
    
    public function setInitialAlpha(alpha:Float):Void
    {
        for (member in members)
        {
            if (member != null && Std.is(member, FlxSprite))
            {
                var sprite = cast(member, FlxSprite);
                sprite.alpha = alpha;
            }
            else if (member != null && Std.is(member, FlxText))
            {
                var text = cast(member, FlxText);
                text.alpha = alpha;
            }
        }
    }
    
    public function setAlpha(alpha:Float):Void
    {
        for (member in members)
        {
            if (member != null && Std.is(member, FlxSprite))
            {
                var sprite = cast(member, FlxSprite);
                sprite.alpha = alpha;
            }
            else if (member != null && Std.is(member, FlxText))
            {
                var text = cast(member, FlxText);
                text.alpha = alpha;
            }
        }
    }
    
    public function setInitialX(x:Float):Void
    {
        var diff = x - baseX;
        for (member in members)
        {
            if (member != null && Std.is(member, FlxSprite))
            {
                var sprite = cast(member, FlxSprite);
                sprite.x += diff;
            }
            else if (member != null && Std.is(member, FlxText))
            {
                var text = cast(member, FlxText);
                text.x += diff;
            }
        }
        baseX = x;
    }
    
    public function setX(x:Float):Void
    {
        var diff = x - baseX;
        for (member in members)
        {
            if (member != null && Std.is(member, FlxSprite))
            {
                var sprite = cast(member, FlxSprite);
                sprite.x += diff;
            }
            else if (member != null && Std.is(member, FlxText))
            {
                var text = cast(member, FlxText);
                text.x += diff;
            }
        }
        baseX = x;
    }
    
    public function getX():Float
    {
        return baseX;
    }
    
    public function setY(y:Float):Void
    {
        var diff = y - baseY;
        for (member in members)
        {
            if (member != null && Std.is(member, FlxSprite))
            {
                var sprite = cast(member, FlxSprite);
                sprite.y += diff;
            }
            else if (member != null && Std.is(member, FlxText))
            {
                var text = cast(member, FlxText);
                text.y += diff;
            }
        }
        baseY = y;
    }
    
    public function getY():Float
    {
        return baseY;
    }
    
    public function setScale(scale:Float):Void
    {
        currentScale = scale;
        for (member in members)
        {
            if (member != null && Std.is(member, FlxSprite))
            {
                var sprite = cast(member, FlxSprite);
                sprite.scale.x = scale;
                sprite.scale.y = scale;
            }
        }
    }
    
    private function getThemeColors():{background:FlxColor, text:FlxColor, textSecondary:FlxColor}
    {
        if (isDarkTheme)
        {
            return {
                background: FlxColor.fromRGB(48, 48, 48),
                text: FlxColor.fromRGB(240, 240, 240),
                textSecondary: FlxColor.fromRGB(160, 160, 160)
            };
        }
        else
        {
            return {
                background: FlxColor.WHITE,
                text: FlxColor.BLACK,
                textSecondary: FlxColor.fromRGB(100, 100, 100)
            };
        }
    }
    
    private function createBackground(x:Float, y:Float):Void
    {
        var colors = getThemeColors();
        
        background = new FlxSprite(x, y);
        background.makeGraphic(Std.int(itemWidth), Std.int(itemHeight), colors.background);
        background.alpha = notification.isRead ? 0.7 : 0.95;
        add(background);
        
        createRoundedBackground();
        
        var border = new FlxSprite(x - 2, y - 2);
        border.makeGraphic(Std.int(itemWidth + 4), Std.int(itemHeight + 4), getTypeColor());
        border.alpha = notification.isRead ? 0.1 : 0.3;
        add(border);
        
        var shadow = new FlxSprite(x + 3, y + 3);
        var shadowColor = isDarkTheme ? FlxColor.fromRGB(0, 0, 0) : FlxColor.BLACK;
        shadow.makeGraphic(Std.int(itemWidth), Std.int(itemHeight), shadowColor);
        shadow.alpha = isDarkTheme ? 0.3 : 0.1;
        add(shadow);
    }
    
    private function createRoundedBackground():Void
    {
        var cornerRadius = 15;
        var pixels = background.pixels;
        
        for (i in 0...cornerRadius)
        {
            for (j in 0...cornerRadius)
            {
                var distance = Math.sqrt((i - cornerRadius/2) * (i - cornerRadius/2) + (j - cornerRadius/2) * (j - cornerRadius/2));
                if (distance > cornerRadius/2)
                {
                    pixels.setPixel32(i, j, FlxColor.TRANSPARENT);
                    pixels.setPixel32(Std.int(background.width - 1 - i), j, FlxColor.TRANSPARENT);
                    pixels.setPixel32(i, Std.int(background.height - 1 - j), FlxColor.TRANSPARENT);
                    pixels.setPixel32(Std.int(background.width - 1 - i), Std.int(background.height - 1 - j), FlxColor.TRANSPARENT);
                }
            }
        }
        background.dirty = true;
    }
    
    private function createIcon(x:Float, y:Float):Void
    {
        iconSprite = new FlxSprite(x + 20, y + 20);
        iconSprite.makeGraphic(40, 40, getTypeColor());
        add(iconSprite);
        
        createTypeIcon();
    }
    
    private function createTypeIcon():Void
    {
        var pixels = iconSprite.pixels;
        pixels.fillRect(pixels.rect, FlxColor.TRANSPARENT);
        
        var centerX = 20;
        var centerY = 20;
        var radius = 18;
        
        for (i in 0...40)
        {
            for (j in 0...40)
            {
                var distance = Math.sqrt((i - centerX) * (i - centerX) + (j - centerY) * (j - centerY));
                if (distance <= radius)
                {
                    pixels.setPixel32(i, j, getTypeColor());
                }
            }
        }
        
        var symbolColor = FlxColor.WHITE;
        switch(notification.type)
        {
            case NotificationType.INFO:
                for (i in 18...22)
                {
                    for (j in 10...30)
                    {
                        if ((j >= 10 && j <= 12) || (j >= 15 && j <= 28))
                        {
                            pixels.setPixel32(i, j, symbolColor);
                        }
                    }
                }
                
            case NotificationType.SUCCESS:
                var checkPoints = [
                    {x: 12, y: 20}, {x: 13, y: 21}, {x: 14, y: 22},
                    {x: 15, y: 21}, {x: 16, y: 20}, {x: 17, y: 19},
                    {x: 18, y: 18}, {x: 19, y: 17}, {x: 20, y: 16},
                    {x: 21, y: 15}, {x: 22, y: 14}, {x: 23, y: 13},
                    {x: 24, y: 12}, {x: 25, y: 11}, {x: 26, y: 10}
                ];
                for (point in checkPoints)
                {
                    pixels.setPixel32(point.x, point.y, symbolColor);
                    pixels.setPixel32(point.x + 1, point.y, symbolColor);
                    pixels.setPixel32(point.x, point.y + 1, symbolColor);
                }
                
            case NotificationType.WARNING:
                for (i in 18...22)
                {
                    for (j in 10...25)
                    {
                        pixels.setPixel32(i, j, symbolColor);
                    }
                    for (j in 27...30)
                    {
                        pixels.setPixel32(i, j, symbolColor);
                    }
                }
                
            case NotificationType.ERROR:
                for (i in 0...12)
                {
                    pixels.setPixel32(12 + i, 12 + i, symbolColor);
                    pixels.setPixel32(13 + i, 12 + i, symbolColor);
                    pixels.setPixel32(12 + i, 27 - i, symbolColor);
                    pixels.setPixel32(13 + i, 27 - i, symbolColor);
                }
        }
        
        iconSprite.dirty = true;
    }
    
    private function createTexts(x:Float, y:Float):Void
    {
        var colors = getThemeColors();
        
        titleText = new FlxText(x + 80, y + 15, itemWidth - 120, notification.title);
        titleText.setFormat(null, 16, colors.text, LEFT);
        titleText.bold = !notification.isRead;
        titleText.alpha = notification.isRead ? 0.7 : 1.0;
        add(titleText);
        
        messageText = new FlxText(x + 80, y + 35, itemWidth - 120, notification.message);
        messageText.setFormat(null, 12, colors.textSecondary, LEFT);
        messageText.wordWrap = true;
        messageText.alpha = notification.isRead ? 0.6 : 0.9;
        add(messageText);
        
        var timeString = formatTimestamp(notification.timestamp);
        timeText = new FlxText(x + 80, y + itemHeight - 25, itemWidth - 120, timeString);
        timeText.setFormat(null, 10, colors.textSecondary, LEFT);
        timeText.alpha = notification.isRead ? 0.5 : 0.8;
        add(timeText);
    }
    
    private function createUnreadIndicator(x:Float, y:Float):Void
    {
        if (!notification.isRead)
        {
            unreadIndicator = new FlxSprite(x + itemWidth - 25, y + 15);
            unreadIndicator.makeGraphic(12, 12, getTypeColor());
            add(unreadIndicator);
            
            var pixels = unreadIndicator.pixels;
            pixels.fillRect(pixels.rect, FlxColor.TRANSPARENT);
            
            var centerX = 6;
            var centerY = 6;
            var radius = 5;
            
            for (i in 0...12)
            {
                for (j in 0...12)
                {
                    var distance = Math.sqrt((i - centerX) * (i - centerX) + (j - centerY) * (j - centerY));
                    if (distance <= radius)
                    {
                        pixels.setPixel32(i, j, getTypeColor());
                    }
                }
            }
            unreadIndicator.dirty = true;
            
            FlxTween.tween(unreadIndicator, {alpha: 0.5}, 1.0, {
                type: FlxTweenType.PINGPONG,
                ease: FlxEase.sineInOut
            });
        }
    }
    
    private function createHoverOverlay(x:Float, y:Float):Void
    {
        hoverOverlay = new FlxSprite(x, y);
        hoverOverlay.makeGraphic(Std.int(itemWidth), Std.int(itemHeight), getTypeColor());
        hoverOverlay.alpha = 0;
        add(hoverOverlay);
    }
    
    private function getTypeColor():FlxColor
    {
        return switch(notification.type)
        {
            case NotificationType.INFO: FlxColor.fromRGB(59, 130, 246);
            case NotificationType.SUCCESS: FlxColor.fromRGB(34, 197, 94);
            case NotificationType.WARNING: FlxColor.fromRGB(251, 146, 60);
            case NotificationType.ERROR: FlxColor.fromRGB(239, 68, 68);
        }
    }
    
    private function formatTimestamp(timestamp:Float):String
    {
        var now = haxe.Timer.stamp() * 1000;
        var diff = now - timestamp;
        var seconds = Math.floor(diff / 1000);
        var minutes = Math.floor(seconds / 60);
        var hours = Math.floor(minutes / 60);
        var days = Math.floor(hours / 24);
        
        if (days > 0)
            return days + " day" + (days > 1 ? "s" : "") + " ago";
        else if (hours > 0)
            return hours + " hour" + (hours > 1 ? "s" : "") + " ago";
        else if (minutes > 0)
            return minutes + " minute" + (minutes > 1 ? "s" : "") + " ago";
        else
            return "Just now";
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        var mouseOver = background != null && background.overlapsPoint(FlxG.mouse.getPosition());
        
        if (mouseOver)
        {
            if (hoverOverlay != null && hoverOverlay.alpha < 0.1)
            {
                FlxTween.tween(hoverOverlay, {alpha: 0.1}, 0.2, {ease: FlxEase.quartOut});
            }
            
            if (currentScale < 1.02)
            {
                FlxTween.tween(this, {}, 0.3, {
                    ease: FlxEase.quartOut,
                    onUpdate: function(tween:FlxTween) {
                        setScale(1.0 + 0.02 * tween.percent);
                    }
                });
            }
        }
        else
        {
            if (hoverOverlay != null && hoverOverlay.alpha > 0)
            {
                FlxTween.tween(hoverOverlay, {alpha: 0}, 0.3, {ease: FlxEase.quartOut});
            }
            
            if (currentScale > 1.0)
            {
                FlxTween.tween(this, {}, 0.3, {
                    ease: FlxEase.quartOut,
                    onUpdate: function(tween:FlxTween) {
                        setScale(1.02 - 0.02 * tween.percent);
                    }
                });
            }
        }
        
        if (FlxG.mouse.justPressed && mouseOver)
        {
            FlxTween.tween(this, {}, 0.1, {
                onUpdate: function(tween:FlxTween) {
                    setScale(1.02 - 0.04 * tween.percent);
                },
                onComplete: function(_) {
                    FlxTween.tween(this, {}, 0.2, {
                        ease: FlxEase.backOut,
                        onUpdate: function(tween:FlxTween) {
                            setScale(0.98 + 0.04 * tween.percent);
                        },
                        onComplete: function(_) {
                            if (onClicked != null) onClicked(notification);
                        }
                    });
                }
            });
            
            if (hoverOverlay != null)
            {
                FlxTween.tween(hoverOverlay, {alpha: 0.3}, 0.1, {
                    onComplete: function(_) {
                        FlxTween.tween(hoverOverlay, {alpha: 0.1}, 0.4);
                    }
                });
            }
        }
    }
}