package notification;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxMath;

class NotificationCenter extends FlxState
{
    private var notifications:Array<NotificationData>;
    private var filteredNotifications:Array<NotificationData>;
    private var notificationItems:FlxGroup;
    private var detailPanel:NotificationDetailPanel;
    
    private var background:FlxSprite;
    private var headerBackground:FlxSprite;
    private var titleText:FlxText;
    private var backButton:FlxSprite;
    private var clearAllButton:FlxSprite;
    private var markAllReadButton:FlxSprite;
    private var themeToggleButton:FlxSprite;
    
    // Filter buttons
    private var filterContainer:FlxGroup;
    private var allFilterButton:FilterButton;
    private var infoFilterButton:FilterButton;
    private var successFilterButton:FilterButton;
    private var warningFilterButton:FilterButton;
    private var errorFilterButton:FilterButton;
    private var unreadFilterButton:FilterButton;
    
    // Scroll properties
    private var scrollY:Float = 0;
    private var maxScrollY:Float = 0;
    private var scrollSpeed:Float = 50;
    private var notificationScrollContainer:FlxGroup;
    private var scrollBar:FlxSprite;
    private var scrollThumb:FlxSprite;
    private var isDraggingScroll:Bool = false;
    private var scrollBounds:Float = 0;
    
    // Filter state
    private var currentFilter:NotificationFilter = NotificationFilter.ALL;
    
    private var isDetailPanelOpen:Bool = false;
    private var selectedNotification:NotificationData;
    
    // Theme properties
    private var isDarkTheme:Bool = false;
    private var themeColors:{
        background:FlxColor,
        surface:FlxColor,
        text:FlxColor,
        textSecondary:FlxColor,
        border:FlxColor
    };
    
    public function new(notifications:Array<NotificationData>)
    {
        super();
        this.notifications = notifications != null ? notifications : [];
        this.filteredNotifications = this.notifications.copy();
        
        updateThemeColors();
    }
    
    private function updateThemeColors():Void
    {
        if (isDarkTheme)
        {
            themeColors = {
                background: FlxColor.fromRGB(18, 18, 18),
                surface: FlxColor.fromRGB(32, 32, 32),
                text: FlxColor.fromRGB(240, 240, 240),
                textSecondary: FlxColor.fromRGB(160, 160, 160),
                border: FlxColor.fromRGB(64, 64, 64)
            };
        }
        else
        {
            themeColors = {
                background: FlxColor.fromRGB(245, 245, 250),
                surface: FlxColor.WHITE,
                text: FlxColor.BLACK,
                textSecondary: FlxColor.fromRGB(120, 120, 120),
                border: FlxColor.fromRGB(220, 220, 220)
            };
        }
    }
    
    override public function create():Void
    {
        super.create();
        
        createBackground();
        createHeader();
        createFilterButtons();
        createScrollContainer();
        createScrollBar();
        createNotificationList();
        createDetailPanel();
        
        startEntranceAnimation();
    }
    
    private function createBackground():Void
    {
        background = new FlxSprite();
        background.makeGraphic(FlxG.width, FlxG.height, themeColors.background);
        background.alpha = 0;
        add(background);
    }
    
    private function createHeader():Void
    {
        headerBackground = new FlxSprite(0, 0);
        headerBackground.makeGraphic(FlxG.width, 100, themeColors.surface);
        headerBackground.alpha = 0.95;
        headerBackground.y = -100;
        add(headerBackground);
        
        titleText = new FlxText(60, 30, FlxG.width - 120, "Notification Center");
        titleText.setFormat(null, 28, themeColors.text, LEFT);
        titleText.bold = true;
        titleText.alpha = 0;
        add(titleText);
        
        var subtitleText = new FlxText(60, 65, FlxG.width - 120, notifications.length + " notifications");
        subtitleText.setFormat(null, 16, themeColors.textSecondary, LEFT);
        subtitleText.alpha = 0;
        add(subtitleText);
        
        createHeaderButtons();
    }
    
    private function createHeaderButtons():Void
    {
        backButton = new FlxSprite(20, 35);
        backButton.makeGraphic(30, 30, themeColors.textSecondary);
        backButton.alpha = 0;
        add(backButton);
        createBackArrow();
        
        themeToggleButton = new FlxSprite(FlxG.width - 250, 35);
        themeToggleButton.makeGraphic(30, 30, themeColors.textSecondary);
        themeToggleButton.alpha = 0;
        add(themeToggleButton);
        createThemeIcon();
        
        clearAllButton = new FlxSprite(FlxG.width - 180, 35);
        clearAllButton.makeGraphic(80, 30, FlxColor.fromRGB(239, 68, 68));
        clearAllButton.alpha = 0;
        add(clearAllButton);
        
        var clearText = new FlxText(FlxG.width - 175, 42, 70, "Clear All");
        clearText.setFormat(null, 12, FlxColor.WHITE, CENTER);
        clearText.alpha = 0;
        add(clearText);
        
        markAllReadButton = new FlxSprite(FlxG.width - 90, 35);
        markAllReadButton.makeGraphic(70, 30, FlxColor.fromRGB(34, 197, 94));
        markAllReadButton.alpha = 0;
        add(markAllReadButton);
        
        var markText = new FlxText(FlxG.width - 85, 42, 60, "Mark Read");
        markText.setFormat(null, 12, FlxColor.WHITE, CENTER);
        markText.alpha = 0;
        add(markText);
    }
    
    private function createThemeIcon():Void
    {
        var iconColor = themeColors.text;
        
        if (isDarkTheme)
        {
            for (i in 0...8)
            {
                var angle = i * Math.PI / 4;
                var x1 = 15 + Math.cos(angle) * 8;
                var y1 = 15 + Math.sin(angle) * 8;
                var x2 = 15 + Math.cos(angle) * 12;
                var y2 = 15 + Math.sin(angle) * 12;
                
                for (j in 0...3)
                {
                    var px = Std.int(x1 + (x2 - x1) * j / 2);
                    var py = Std.int(y1 + (y2 - y1) * j / 2);
                    if (px >= 0 && px < 30 && py >= 0 && py < 30)
                    {
                        themeToggleButton.pixels.setPixel32(px, py, iconColor);
                    }
                }
            }
            
            for (i in 0...30)
            {
                for (j in 0...30)
                {
                    var distance = Math.sqrt((i - 15) * (i - 15) + (j - 15) * (j - 15));
                    if (distance <= 5)
                    {
                        themeToggleButton.pixels.setPixel32(i, j, iconColor);
                    }
                }
            }
        }
        else
        {
            for (i in 0...30)
            {
                for (j in 0...30)
                {
                    var distance1 = Math.sqrt((i - 12) * (i - 12) + (j - 15) * (j - 15));
                    var distance2 = Math.sqrt((i - 18) * (i - 18) + (j - 10) * (j - 10));
                    
                    if (distance1 <= 8 && distance2 > 6)
                    {
                        themeToggleButton.pixels.setPixel32(i, j, iconColor);
                    }
                }
            }
        }
        
        themeToggleButton.dirty = true;
    }
    
    private function createBackArrow():Void
    {
        var arrowColor = themeColors.text;
        for (i in 0...10)
        {
            backButton.pixels.setPixel32(5 + i, 15, arrowColor);
            if (i < 5)
            {
                backButton.pixels.setPixel32(5 + i, 10 + i, arrowColor);
                backButton.pixels.setPixel32(5 + i, 20 - i, arrowColor);
            }
        }
        backButton.dirty = true;
    }
    
    private function createFilterButtons():Void
    {
        filterContainer = new FlxGroup();
        add(filterContainer);
        
        var filterY = 120;
        var buttonWidth = 100;
        var buttonSpacing = 110;
        var startX = (FlxG.width - (6 * buttonSpacing - 10)) / 2;
        
        allFilterButton = new FilterButton(startX, filterY, buttonWidth, "All", NotificationFilter.ALL, true, isDarkTheme);
        infoFilterButton = new FilterButton(startX + buttonSpacing, filterY, buttonWidth, "Info", NotificationFilter.INFO, false, isDarkTheme);
        successFilterButton = new FilterButton(startX + buttonSpacing * 2, filterY, buttonWidth, "Success", NotificationFilter.SUCCESS, false, isDarkTheme);
        warningFilterButton = new FilterButton(startX + buttonSpacing * 3, filterY, buttonWidth, "Warning", NotificationFilter.WARNING, false, isDarkTheme);
        errorFilterButton = new FilterButton(startX + buttonSpacing * 4, filterY, buttonWidth, "Error", NotificationFilter.ERROR, false, isDarkTheme);
        unreadFilterButton = new FilterButton(startX + buttonSpacing * 5, filterY, buttonWidth, "Unread", NotificationFilter.UNREAD, false, isDarkTheme);
        
        var filterButtons = [allFilterButton, infoFilterButton, successFilterButton, warningFilterButton, errorFilterButton, unreadFilterButton];
        
        for (i in 0...filterButtons.length)
        {
            var button = filterButtons[i];
            button.onClicked = onFilterClicked;
            button.setInitialAlpha(0);
            button.setInitialY(button.getY() - 30);
            filterContainer.add(button);
            
            FlxTween.tween(button, {}, 0.4, {
                ease: FlxEase.backOut,
                startDelay: 0.5 + i * 0.1,
                onUpdate: function(tween:FlxTween) {
                    button.setAlpha(tween.percent);
                    button.setY(button.getY() + 30 * tween.percent);
                }
            });
        }
    }
    
    private function createScrollContainer():Void
    {
        notificationScrollContainer = new FlxGroup();
        add(notificationScrollContainer);
    }
    
    private function createScrollBar():Void
    {
        scrollBar = new FlxSprite(FlxG.width - 20, 180);
        scrollBar.makeGraphic(8, FlxG.height - 200, themeColors.border);
        scrollBar.alpha = 0.3;
        add(scrollBar);
        
        scrollThumb = new FlxSprite(FlxG.width - 19, 180);
        scrollThumb.makeGraphic(6, 50, themeColors.textSecondary);
        scrollThumb.alpha = 0.6;
        add(scrollThumb);
    }
    
    private function createNotificationList():Void
    {
        notificationItems = new FlxGroup();
        notificationScrollContainer.add(notificationItems);
        
        updateNotificationList();
    }
    
    private function updateNotificationList():Void
    {
        if (notificationItems != null)
        {
            notificationItems.clear();
        }
        
        var yOffset:Float = 180;
        var itemHeight:Float = 120;
        var itemSpacing:Float = 15;
        
        if (filteredNotifications == null)
        {
            filteredNotifications = [];
        }
        
        for (i in 0...filteredNotifications.length)
        {
            try {
                var notification = filteredNotifications[i];
                if (notification != null)
                {
                    var listItem = new NotificationListItem(50, yOffset, FlxG.width - 120, notification, isDarkTheme);
                    listItem.onClicked = onNotificationItemClicked;
                    listItem.setInitialAlpha(0);
                    listItem.setInitialX(listItem.getX() - 50);
                    
                    if (notificationItems != null)
                    {
                        notificationItems.add(listItem);
                    }
                    
                    FlxTween.tween(listItem, {}, 0.5, {
                        ease: FlxEase.quartOut,
                        startDelay: i * 0.05,
                        onUpdate: function(tween:FlxTween) {
                            listItem.setAlpha(tween.percent);
                            listItem.setX(listItem.getX() + 50 * tween.percent);
                        }
                    });
                    
                    yOffset += itemHeight + itemSpacing;
                }
            } catch (e:Dynamic) {
                trace("Error creating notification item: " + e);
                continue;
            }
        }
        
        maxScrollY = Math.max(0, yOffset - FlxG.height + 50);
        scrollBounds = Math.max(0, maxScrollY);
        scrollY = Math.min(scrollY, scrollBounds);
        
        updateScrollThumb();
    }
    
    private function updateScrollThumb():Void
    {
        if (maxScrollY <= 0)
        {
            if (scrollThumb != null) scrollThumb.alpha = 0;
            return;
        }
        
        if (scrollThumb != null)
        {
            scrollThumb.alpha = 0.6;
            var scrollRatio = scrollBounds > 0 ? FlxMath.bound(scrollY / scrollBounds, 0, 1) : 0;
            var thumbY = 180 + scrollRatio * (FlxG.height - 280);
            scrollThumb.y = FlxMath.bound(thumbY, 180, FlxG.height - 100);
        }
    }
    
    private function createDetailPanel():Void
    {
        detailPanel = new NotificationDetailPanel(isDarkTheme);
        detailPanel.onClosed = onDetailPanelClosed;
        detailPanel.setX(FlxG.width);
        add(detailPanel);
    }
    
    private function startEntranceAnimation():Void
    {
        FlxTween.tween(background, {alpha: 1}, 0.5, {ease: FlxEase.quartOut});
        
        FlxTween.tween(headerBackground, {y: 0}, 0.6, {
            ease: FlxEase.backOut,
            startDelay: 0.2
        });
        
        FlxTween.tween(titleText, {alpha: 1}, 0.4, {startDelay: 0.4});
        
        var headerButtons = [backButton, themeToggleButton, clearAllButton, markAllReadButton];
        for (i in 0...headerButtons.length)
        {
            var button = headerButtons[i];
            if (button != null)
            {
                FlxTween.tween(button, {alpha: 1}, 0.3, {startDelay: 0.6 + i * 0.1});
            }
        }
    }
    
    private function toggleTheme():Void
    {
        isDarkTheme = !isDarkTheme;
        updateThemeColors();
        
        if (background != null) background.color = themeColors.background;
        if (headerBackground != null) headerBackground.color = themeColors.surface;
        if (titleText != null) titleText.color = themeColors.text;
        if (scrollBar != null) scrollBar.color = themeColors.border;
        if (scrollThumb != null) scrollThumb.color = themeColors.textSecondary;
        
        createThemeIcon();
        
        var filterButtons = [allFilterButton, infoFilterButton, successFilterButton, warningFilterButton, errorFilterButton, unreadFilterButton];
        for (button in filterButtons)
        {
            if (button != null)
            {
                button.updateTheme(isDarkTheme);
            }
        }
        
        updateNotificationList();
        
        if (detailPanel != null)
        {
            detailPanel.updateTheme(isDarkTheme);
        }
    }
    
    private function onFilterClicked(filter:NotificationFilter):Void
    {
        if (currentFilter == filter) return;
        
        currentFilter = filter;
        
        var filterButtons = [allFilterButton, infoFilterButton, successFilterButton, warningFilterButton, errorFilterButton, unreadFilterButton];
        for (button in filterButtons)
        {
            if (button != null)
            {
                button.setActive(button.filter == filter);
            }
        }
        
        applyFilter();
        updateNotificationList();
        
        scrollY = 0;
        updateScrollPosition();
    }
    
    private function applyFilter():Void
    {
        if (notifications == null)
        {
            filteredNotifications = [];
            return;
        }
        
        filteredNotifications = [];
        
        for (notification in notifications)
        {
            if (notification == null) continue;
            
            var shouldInclude = switch(currentFilter)
            {
                case NotificationFilter.ALL: true;
                case NotificationFilter.INFO: notification.type == NotificationType.INFO;
                case NotificationFilter.SUCCESS: notification.type == NotificationType.SUCCESS;
                case NotificationFilter.WARNING: notification.type == NotificationType.WARNING;
                case NotificationFilter.ERROR: notification.type == NotificationType.ERROR;
                case NotificationFilter.UNREAD: !notification.isRead;
            }
            
            if (shouldInclude)
            {
                filteredNotifications.push(notification);
            }
        }
    }
    
    private function onNotificationItemClicked(notification:NotificationData):Void
    {
        selectedNotification = notification;
        notification.isRead = true;
        
        detailPanel.setNotification(notification);
        
        FlxTween.tween(detailPanel, {}, 0.5, {
            ease: FlxEase.quartOut,
            onUpdate: function(tween:FlxTween) {
                detailPanel.setX(FlxG.width - (FlxG.width * 0.7 * tween.percent));
            }
        });
        
        isDetailPanelOpen = true;
    }
    
    private function onDetailPanelClosed():Void
    {
        FlxTween.tween(detailPanel, {}, 0.4, {
            ease: FlxEase.quartIn,
            onUpdate: function(tween:FlxTween) {
                detailPanel.setX(FlxG.width * 0.3 + (FlxG.width * 0.7 * tween.percent));
            }
        });
        
        isDetailPanelOpen = false;
        updateNotificationList();
    }
    
    private function updateScrollPosition():Void
    {
        if (notificationItems == null || notificationItems.members == null) return;
        
        try {
            for (i in 0...notificationItems.members.length)
            {
                var item = notificationItems.members[i];
                if (item != null && Std.is(item, NotificationListItem))
                {
                    var listItem = cast(item, NotificationListItem);
                    if (listItem != null)
                    {
                        listItem.setY(listItem.baseY - scrollY);
                    }
                }
            }
            
            updateScrollThumb();
        } catch (e:Dynamic) {
            trace("Error updating scroll position: " + e);
        }
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        handleScrolling();
        handleInput();
    }
    
    private function handleScrolling():Void
    {
        if (FlxG.mouse.wheel != 0 && !isDetailPanelOpen && scrollBounds > 0)
        {
            var newScrollY = scrollY - FlxG.mouse.wheel * scrollSpeed;
            scrollY = FlxMath.bound(newScrollY, 0, scrollBounds);
            updateScrollPosition();
        }
        
        if (scrollThumb != null && FlxG.mouse.justPressed && scrollThumb.overlapsPoint(FlxG.mouse.getPosition()))
        {
            isDraggingScroll = true;
        }
        
        if (isDraggingScroll)
        {
            if (FlxG.mouse.pressed && scrollBounds > 0)
            {
                var mouseY = FlxG.mouse.y;
                var scrollRatio = (mouseY - 180) / (FlxG.height - 280);
                scrollRatio = FlxMath.bound(scrollRatio, 0, 1);
                scrollY = scrollRatio * scrollBounds;
                updateScrollPosition();
            }
            else
            {
                isDraggingScroll = false;
            }
        }
    }
    
    private function handleInput():Void
    {
        if (FlxG.mouse.justPressed)
        {
            if (backButton != null && backButton.overlapsPoint(FlxG.mouse.getPosition()))
            {
                FlxG.switchState(new PlayState());
            }
            
            if (themeToggleButton != null && themeToggleButton.overlapsPoint(FlxG.mouse.getPosition()))
            {
                toggleTheme();
            }
            
            if (clearAllButton != null && clearAllButton.overlapsPoint(FlxG.mouse.getPosition()))
            {
                clearAllNotifications();
            }
            
            if (markAllReadButton != null && markAllReadButton.overlapsPoint(FlxG.mouse.getPosition()))
            {
                markAllAsRead();
            }
        }
        
        if (FlxG.keys.justPressed.ESCAPE)
        {
            if (isDetailPanelOpen)
            {
                onDetailPanelClosed();
            }
            else
            {
                FlxG.switchState(new PlayState());
            }
        }
        
        if (FlxG.keys.justPressed.T)
        {
            toggleTheme();
        }
    }
    
    private function clearAllNotifications():Void
    {
        if (notificationItems == null || notificationItems.members == null) return;
        
        for (i in 0...notificationItems.members.length)
        {
            var item = notificationItems.members[i];
            if (item != null && Std.is(item, NotificationListItem))
            {
                var listItem = cast(item, NotificationListItem);
                FlxTween.tween(listItem, {}, 0.3, {
                    ease: FlxEase.quartIn,
                    startDelay: i * 0.05,
                    onUpdate: function(tween:FlxTween) {
                        listItem.setAlpha(1 - tween.percent);
                        listItem.setX(listItem.getX() + 100 * tween.percent);
                    }
                });
            }
        }
        
        FlxTween.tween({}, {}, 0.5, {
            onComplete: function(_) {
                notifications = [];
                filteredNotifications = [];
                updateNotificationList();
            }
        });
    }
    
    private function markAllAsRead():Void
    {
        if (notifications != null)
        {
            for (notification in notifications)
            {
                if (notification != null)
                {
                    notification.isRead = true;
                }
            }
        }
        updateNotificationList();
    }
}

enum NotificationFilter
{
    ALL;
    INFO;
    SUCCESS;
    WARNING;
    ERROR;
    UNREAD;
}

class FilterButton extends FlxGroup
{
    public var filter:NotificationFilter;
    public var onClicked:NotificationFilter->Void;
    
    private var background:FlxSprite;
    private var text:FlxText;
    private var isActive:Bool = false;
    private var isDarkTheme:Bool = false;
    private var baseY:Float = 0;
    
    public function new(x:Float, y:Float, width:Float, label:String, filter:NotificationFilter, active:Bool = false, darkTheme:Bool = false)
    {
        super();
        
        this.filter = filter;
        this.isActive = active;
        this.isDarkTheme = darkTheme;
        this.baseY = y;
        
        var bgColor = active ? getFilterColor() : (darkTheme ? FlxColor.fromRGB(64, 64, 64) : FlxColor.fromRGB(240, 240, 240));
        var textColor = active ? FlxColor.WHITE : (darkTheme ? FlxColor.fromRGB(200, 200, 200) : FlxColor.fromRGB(100, 100, 100));
        
        background = new FlxSprite(x, y);
        background.makeGraphic(Std.int(width), 40, bgColor);
        add(background);
        
        text = new FlxText(x, y + 12, width, label);
        text.setFormat(null, 14, textColor, CENTER);
        text.bold = active;
        add(text);
        
        createRoundedCorners();
    }
    
    public function setInitialAlpha(alpha:Float):Void
    {
        background.alpha = alpha;
        text.alpha = alpha;
    }
    
    public function setAlpha(alpha:Float):Void
    {
        background.alpha = alpha;
        text.alpha = alpha;
    }
    
    public function setInitialY(y:Float):Void
    {
        background.y = y;
        text.y = y + 12;
    }
    
    public function setY(y:Float):Void
    {
        background.y = y;
        text.y = y + 12;
    }
    
    public function getY():Float
    {
        return background.y;
    }
    
    public function updateTheme(darkTheme:Bool):Void
    {
        isDarkTheme = darkTheme;
        
        var bgColor = isActive ? getFilterColor() : (darkTheme ? FlxColor.fromRGB(64, 64, 64) : FlxColor.fromRGB(240, 240, 240));
        var textColor = isActive ? FlxColor.WHITE : (darkTheme ? FlxColor.fromRGB(200, 200, 200) : FlxColor.fromRGB(100, 100, 100));
        
        background.color = bgColor;
        text.color = textColor;
        
        createRoundedCorners();
    }
    
    private function createRoundedCorners():Void
    {
        var cornerRadius = 8;
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
    
    private function getFilterColor():FlxColor
    {
        return switch(filter)
        {
            case NotificationFilter.ALL: FlxColor.fromRGB(100, 100, 100);
            case NotificationFilter.INFO: FlxColor.fromRGB(59, 130, 246);
            case NotificationFilter.SUCCESS: FlxColor.fromRGB(34, 197, 94);
            case NotificationFilter.WARNING: FlxColor.fromRGB(251, 146, 60);
            case NotificationFilter.ERROR: FlxColor.fromRGB(239, 68, 68);
            case NotificationFilter.UNREAD: FlxColor.fromRGB(147, 51, 234);
        }
    }
    
    public function setActive(active:Bool):Void
    {
        if (isActive == active) return;
        
        isActive = active;
        
        var targetColor = active ? getFilterColor() : (isDarkTheme ? FlxColor.fromRGB(64, 64, 64) : FlxColor.fromRGB(240, 240, 240));
        var targetTextColor = active ? FlxColor.WHITE : (isDarkTheme ? FlxColor.fromRGB(200, 200, 200) : FlxColor.fromRGB(100, 100, 100));
        
        FlxTween.color(background, 0.3, background.color, targetColor, {ease: FlxEase.quartOut});
        FlxTween.color(text, 0.3, text.color, targetTextColor, {ease: FlxEase.quartOut});
        
        text.bold = active;
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        if (FlxG.mouse.justPressed && background != null && background.overlapsPoint(FlxG.mouse.getPosition()))
        {
            if (onClicked != null) onClicked(filter);
        }
        
        if (background != null && background.overlapsPoint(FlxG.mouse.getPosition()) && !isActive)
        {
            background.alpha = 0.8;
        }
        else if (background != null && !isActive)
        {
            background.alpha = 1.0;
        }
    }
}