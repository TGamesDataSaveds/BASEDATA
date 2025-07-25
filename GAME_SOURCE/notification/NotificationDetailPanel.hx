package notification;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class NotificationDetailPanel extends FlxGroup
{
    public var onClosed:Void->Void;
    
    private var background:FlxSprite;
    private var headerBackground:FlxSprite;
    private var closeButton:FlxSprite;
    private var iconSprite:FlxSprite;
    private var titleText:FlxText;
    private var messageText:FlxText;
    private var detailedMessageText:FlxText;
    private var timestampText:FlxText;
    private var typeLabel:FlxText;
    private var panelScrollContainer:FlxGroup;
    
    private var notification:NotificationData;
    private var panelWidth:Float;
    private var panelHeight:Float;
    private var isDarkTheme:Bool = false;
    private var baseX:Float = 0;
    
    public function new(darkTheme:Bool = false)
    {
        super();
        
        this.isDarkTheme = darkTheme;
        panelWidth = FlxG.width * 0.7;
        panelHeight = FlxG.height;
        
        createBackground();
        createHeader();
        createCloseButton();
        createScrollContainer();
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
            else if (member != null && Std.is(member, FlxGroup))
            {
                var group = cast(member);
                updateGroupX(group, diff);
            }
        }
        baseX = x;
    }
    
    private function updateGroupX(group:FlxGroup, diff:Float):Void
    {
        if (group.members == null) return;
        
        for (member in group.members)
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
            else if (member != null && Std.is(member, FlxGroup))
            {
                var subGroup = cast(member);
                updateGroupX(subGroup, diff);
            }
        }
    }
    
    public function updateTheme(darkTheme:Bool):Void
    {
        isDarkTheme = darkTheme;
        
        if (background != null)
        {
            background.color = isDarkTheme ? FlxColor.fromRGB(32, 32, 32) : FlxColor.WHITE;
        }
        
        if (headerBackground != null)
        {
            headerBackground.color = isDarkTheme ? FlxColor.fromRGB(48, 48, 48) : FlxColor.fromRGB(248, 250, 252);
        }
        
        if (notification != null)
        {
            setNotification(notification);
        }
    }
    
    private function getThemeColors():{background:FlxColor, surface:FlxColor, text:FlxColor, textSecondary:FlxColor, border:FlxColor}
    {
        if (isDarkTheme)
        {
            return {
                background: FlxColor.fromRGB(32, 32, 32),
                surface: FlxColor.fromRGB(48, 48, 48),
                text: FlxColor.fromRGB(240, 240, 240),
                textSecondary: FlxColor.fromRGB(160, 160, 160),
                border: FlxColor.fromRGB(64, 64, 64)
            };
        }
        else
        {
            return {
                background: FlxColor.WHITE,
                surface: FlxColor.fromRGB(248, 250, 252),
                text: FlxColor.BLACK,
                textSecondary: FlxColor.fromRGB(120, 120, 120),
                border: FlxColor.fromRGB(220, 220, 220)
            };
        }
    }
    
    private function createBackground():Void
    {
        var colors = getThemeColors();
        
        background = new FlxSprite(0, 0);
        background.makeGraphic(Std.int(panelWidth), Std.int(panelHeight), colors.background);
        background.alpha = 0.98;
        add(background);
        
        var shadow = new FlxSprite(-20, 0);
        shadow.makeGraphic(20, Std.int(panelHeight), FlxColor.BLACK);
        shadow.alpha = 0.3;
        add(shadow);
        
        for (i in 0...20)
        {
            var shadowStrip = new FlxSprite(-20 + i, 0);
            shadowStrip.makeGraphic(1, Std.int(panelHeight), FlxColor.BLACK);
            shadowStrip.alpha = 0.3 * (20 - i) / 20;
            add(shadowStrip);
        }
    }
    
    private function createHeader():Void
    {
        var colors = getThemeColors();
        
        headerBackground = new FlxSprite(0, 0);
        headerBackground.makeGraphic(Std.int(panelWidth), 80, colors.surface);
        add(headerBackground);
        
        var headerTitle = new FlxText(30, 25, panelWidth - 80, "Notification Details");
        headerTitle.setFormat(null, 24, colors.text, LEFT);
        headerTitle.bold = true;
        add(headerTitle);
        
        var headerBorder = new FlxSprite(0, 79);
        headerBorder.makeGraphic(Std.int(panelWidth), 1, colors.border);
        add(headerBorder);
    }
    
    private function createCloseButton():Void
    {
        var colors = getThemeColors();
        
        closeButton = new FlxSprite(panelWidth - 60, 20);
        closeButton.makeGraphic(40, 40, isDarkTheme ? FlxColor.fromRGB(64, 64, 64) : FlxColor.fromRGB(240, 240, 240));
        add(closeButton);
        
        var symbolColor = colors.text;
        for (i in 0...16)
        {
            closeButton.pixels.setPixel32(12 + i, 12 + i, symbolColor);
            closeButton.pixels.setPixel32(13 + i, 12 + i, symbolColor);
            closeButton.pixels.setPixel32(12 + i, 27 - i, symbolColor);
            closeButton.pixels.setPixel32(13 + i, 27 - i, symbolColor);
        }
        closeButton.dirty = true;
        
        createRoundedButton();
    }
    
    private function createRoundedButton():Void
    {
        var cornerRadius = 8;
        var pixels = closeButton.pixels;
        
        for (i in 0...cornerRadius)
        {
            for (j in 0...cornerRadius)
            {
                var distance = Math.sqrt((i - cornerRadius/2) * (i - cornerRadius/2) + (j - cornerRadius/2) * (j - cornerRadius/2));
                if (distance > cornerRadius/2)
                {
                    pixels.setPixel32(i, j, FlxColor.TRANSPARENT);
                    pixels.setPixel32(Std.int(closeButton.width - 1 - i), j, FlxColor.TRANSPARENT);
                    pixels.setPixel32(i, Std.int(closeButton.height - 1 - j), FlxColor.TRANSPARENT);
                    pixels.setPixel32(Std.int(closeButton.width - 1 - i), Std.int(closeButton.height - 1 - j), FlxColor.TRANSPARENT);
                }
            }
        }
        closeButton.dirty = true;
    }
    
    private function createScrollContainer():Void
    {
        panelScrollContainer = new FlxGroup();
        add(panelScrollContainer);
    }
    
    public function setNotification(notification:NotificationData):Void
    {
        this.notification = notification;
        
        if (panelScrollContainer != null)
        {
            panelScrollContainer.clear();
        }
        
        createContent();
    }
    
    private function createContent():Void
    {
        var colors = getThemeColors();
        var yOffset:Float = 120;
        var contentPadding:Float = 30;
        var contentWidth = panelWidth - (contentPadding * 2);
        
        iconSprite = new FlxSprite(contentPadding, yOffset);
        iconSprite.makeGraphic(60, 60, getTypeColor());
        panelScrollContainer.add(iconSprite);
        createDetailedIcon();
        
        typeLabel = new FlxText(contentPadding + 80, yOffset, contentWidth - 80, getTypeString());
        typeLabel.setFormat(null, 14, getTypeColor(), LEFT);
        typeLabel.bold = true;
        panelScrollContainer.add(typeLabel);
        
        timestampText = new FlxText(contentPadding + 80, yOffset + 25, contentWidth - 80, formatDetailedTimestamp());
        timestampText.setFormat(null, 12, colors.textSecondary, LEFT);
        panelScrollContainer.add(timestampText);
        
        yOffset += 100;
        
        titleText = new FlxText(contentPadding, yOffset, contentWidth, notification.title);
        titleText.setFormat(null, 28, colors.text, LEFT);
        titleText.bold = true;
        titleText.wordWrap = true;
        panelScrollContainer.add(titleText);
        
        yOffset += titleText.height + 30;
        
        messageText = new FlxText(contentPadding, yOffset, contentWidth, notification.message);
        messageText.setFormat(null, 16, colors.textSecondary, LEFT);
        messageText.wordWrap = true;
        panelScrollContainer.add(messageText);
        
        yOffset += messageText.height + 40;
        
        if (notification.detailedMessage != null && notification.detailedMessage.length > 0)
        {
            var detailHeader = new FlxText(contentPadding, yOffset, contentWidth, "Details");
            detailHeader.setFormat(null, 20, colors.text, LEFT);
            detailHeader.bold = true;
            panelScrollContainer.add(detailHeader);
            
            yOffset += 40;
            
            detailedMessageText = new FlxText(contentPadding, yOffset, contentWidth, notification.detailedMessage);
            detailedMessageText.setFormat(null, 14, colors.textSecondary, LEFT);
            detailedMessageText.wordWrap = true;
            panelScrollContainer.add(detailedMessageText);
            
            yOffset += detailedMessageText.height + 30;
        }
        
        createActionButtons(yOffset, contentPadding, contentWidth);
        
        animateContentIn();
    }
    
    private function createDetailedIcon():Void
    {
        var pixels = iconSprite.pixels;
        pixels.fillRect(pixels.rect, FlxColor.TRANSPARENT);
        
        var centerX = 30;
        var centerY = 30;
        var radius = 28;
        
        for (i in 0...60)
        {
            for (j in 0...60)
            {
                var distance = Math.sqrt((i - centerX) * (i - centerX) + (j - centerY) * (j - centerY));
                if (distance <= radius)
                {
                    var alpha = 1.0 - (distance / radius) * 0.3;
                    var color = getTypeColor();
                    color.alpha = Std.int(alpha * 255);
                    pixels.setPixel32(i, j, color);
                }
            }
        }
        
        var symbolColor = FlxColor.WHITE;
        switch(notification.type)
        {
            case NotificationType.INFO:
                for (i in 26...34)
                {
                    for (j in 15...45)
                    {
                        if ((j >= 15 && j <= 20) || (j >= 25 && j <= 42))
                        {
                            pixels.setPixel32(i, j, symbolColor);
                        }
                    }
                }
                
            case NotificationType.SUCCESS:
                var checkPoints = [];
                for (i in 0...8)
                {
                    checkPoints.push({x: 18 + i, y: 30 + i});
                    checkPoints.push({x: 19 + i, y: 30 + i});
                    checkPoints.push({x: 18 + i, y: 31 + i});
                }
                for (i in 0...12)
                {
                    checkPoints.push({x: 26 + i, y: 38 - i});
                    checkPoints.push({x: 27 + i, y: 38 - i});
                    checkPoints.push({x: 26 + i, y: 39 - i});
                }
                
                for (point in checkPoints)
                {
                    if (point.x >= 0 && point.x < 60 && point.y >= 0 && point.y < 60)
                    {
                        pixels.setPixel32(point.x, point.y, symbolColor);
                    }
                }
                
            case NotificationType.WARNING:
                for (i in 26...34)
                {
                    for (j in 15...38)
                    {
                        pixels.setPixel32(i, j, symbolColor);
                    }
                    for (j in 42...47)
                    {
                        pixels.setPixel32(i, j, symbolColor);
                    }
                }
                
            case NotificationType.ERROR:
                for (i in 0...20)
                {
                    pixels.setPixel32(20 + i, 20 + i, symbolColor);
                    pixels.setPixel32(21 + i, 20 + i, symbolColor);
                    pixels.setPixel32(22 + i, 20 + i, symbolColor);
                    pixels.setPixel32(20 + i, 39 - i, symbolColor);
                    pixels.setPixel32(21 + i, 39 - i, symbolColor);
                    pixels.setPixel32(22 + i, 39 - i, symbolColor);
                }
        }
        
        iconSprite.dirty = true;
    }
    
    private function createActionButtons(yOffset:Float, padding:Float, width:Float):Void
    {
        var buttonY = yOffset + 20;
        var buttonWidth = 120;
        var buttonHeight = 40;
        var buttonSpacing = 20;
        
        if (!notification.isRead)
        {
            var markReadButton = new FlxSprite(padding, buttonY);
            markReadButton.makeGraphic(buttonWidth, buttonHeight, FlxColor.fromRGB(34, 197, 94));
            panelScrollContainer.add(markReadButton);
            
            var markReadText = new FlxText(padding, buttonY + 12, buttonWidth, "Mark as Read");
            markReadText.setFormat(null, 12, FlxColor.WHITE, CENTER);
            panelScrollContainer.add(markReadText);
            
            createRoundedActionButton(markReadButton);
        }
        
        var dismissButton = new FlxSprite(padding + buttonWidth + buttonSpacing, buttonY);
        dismissButton.makeGraphic(buttonWidth, buttonHeight, FlxColor.fromRGB(239, 68, 68));
        panelScrollContainer.add(dismissButton);
        
        var dismissText = new FlxText(padding + buttonWidth + buttonSpacing, buttonY + 12, buttonWidth, "Dismiss");
        dismissText.setFormat(null, 12, FlxColor.WHITE, CENTER);
        panelScrollContainer.add(dismissText);
        
        createRoundedActionButton(dismissButton);
    }
    
    private function createRoundedActionButton(button:FlxSprite):Void
    {
        var cornerRadius = 6;
        var pixels = button.pixels;
        
        for (i in 0...cornerRadius)
        {
            for (j in 0...cornerRadius)
            {
                var distance = Math.sqrt((i - cornerRadius/2) * (i - cornerRadius/2) + (j - cornerRadius/2) * (j - cornerRadius/2));
                if (distance > cornerRadius/2)
                {
                    pixels.setPixel32(i, j, FlxColor.TRANSPARENT);
                    pixels.setPixel32(Std.int(button.width - 1 - i), j, FlxColor.TRANSPARENT);
                    pixels.setPixel32(i, Std.int(button.height - 1 - j), FlxColor.TRANSPARENT);
                    pixels.setPixel32(Std.int(button.width - 1 - i), Std.int(button.height - 1 - j), FlxColor.TRANSPARENT);
                }
            }
        }
        button.dirty = true;
    }
    
    private function animateContentIn():Void
    {
        var delay = 0.0;
        if (panelScrollContainer != null && panelScrollContainer.members != null)
        {
            for (i in 0...panelScrollContainer.members.length)
            {
                var member = panelScrollContainer.members[i];
                if (member != null)
                {
                    if (Std.is(member, FlxSprite))
                    {
                        var sprite = cast(member, FlxSprite);
                        sprite.alpha = 0;
                        sprite.x += 50;
                        
                        FlxTween.tween(sprite, {alpha: 1, x: sprite.x - 50}, 0.4, {
                            ease: FlxEase.quartOut,
                            startDelay: delay
                        });
                    }
                    else if (Std.is(member, FlxText))
                    {
                        var text = cast(member, FlxText);
                        text.alpha = 0;
                        text.x += 50;
                        
                        FlxTween.tween(text, {alpha: 1, x: text.x - 50}, 0.4, {
                            ease: FlxEase.quartOut,
                            startDelay: delay
                        });
                    }
                    
                    delay += 0.05;
                }
            }
        }
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
    
    private function getTypeString():String
    {
        return switch(notification.type)
        {
            case NotificationType.INFO: "INFORMATION";
            case NotificationType.SUCCESS: "SUCCESS";
            case NotificationType.WARNING: "WARNING";
            case NotificationType.ERROR: "ERROR";
        }
    }
    
    private function formatDetailedTimestamp():String
    {
        var date = Date.fromTime(notification.timestamp);
        var now = Date.now();
        
        var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                     "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
        
        var timeString = date.getHours() + ":" + 
                        (date.getMinutes() < 10 ? "0" : "") + date.getMinutes();
        
        if (date.getDate() == now.getDate() && 
            date.getMonth() == now.getMonth() && 
            date.getFullYear() == now.getFullYear())
        {
            return "Today at " + timeString;
        }
        else
        {
            return months[date.getMonth()] + " " + date.getDate() + ", " + 
                   date.getFullYear() + " at " + timeString;
        }
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        if (closeButton != null && closeButton.overlapsPoint(FlxG.mouse.getPosition()))
        {
            closeButton.color = isDarkTheme ? FlxColor.fromRGB(255, 100, 100) : FlxColor.fromRGB(255, 200, 200);
            closeButton.alpha = 1.0;
        }
        else if (closeButton != null)
        {
            closeButton.color = isDarkTheme ? FlxColor.fromRGB(64, 64, 64) : FlxColor.fromRGB(240, 240, 240);
            closeButton.alpha = 0.8;
        }
        
        if (FlxG.mouse.justPressed && closeButton != null && closeButton.overlapsPoint(FlxG.mouse.getPosition()))
        {
            if (onClosed != null) onClosed();
        }
    }
}