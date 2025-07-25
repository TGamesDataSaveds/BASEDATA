package states.inicio;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.ui.FlxButton;
import flixel.group.FlxGroup;
//import flixel.group.FlxTypedGroup;

class DocumentationState extends FlxState
{
    private var sidebar:FlxSprite;
    private var mainContent:FlxSprite;
    private var contentText:FlxText;
    private var menuItems:FlxTypedGroup<FlxButton>;
    private var currentPage:Int = 0;
    private var titles:Array<String>;
    private var contents:Array<String>;
    
    private var isFullscreen:Bool = false;
    private var originalMainContentX:Float = 210;
    private var originalMainContentWidth:Float = 0;
    
    private var scrollPosition:Float = 0;
    private var maxScroll:Float = 0;
    private var scrollBar:FlxSprite;
    private var scrollThumb:FlxSprite;
    private var isDragging:Bool = false;
    
    private var headerBg:FlxSprite;
    private var topicLabel:FlxText;
    private var settingsButton:FlxButton;
    private var accessibilityMenu:FlxSprite;
    private var fontSizeOptions:Array<FlxText>;
    private var currentFontSize:Int = 14;
    
    override public function create():Void 
    {
        super.create();
        
        // Background
        var bg = new FlxSprite();
        bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(18, 18, 18));
        add(bg);
        
        // Sidebar
        sidebar = new FlxSprite(-200, 10);
        sidebar.makeGraphic(190, FlxG.height - 20, FlxColor.fromRGB(28, 28, 28), true);
        add(sidebar);
        
        FlxTween.tween(sidebar, {x: 10}, 0.5, {ease: FlxEase.quartOut});
        
        // Header
        headerBg = new FlxSprite(210, 10);
        headerBg.makeGraphic(FlxG.width - 230, 50, FlxColor.fromRGB(40, 40, 40), true);
        add(headerBg);
        
        // Main content
        mainContent = new FlxSprite(FlxG.width, 70);
        originalMainContentWidth = FlxG.width - 230;
        mainContent.makeGraphic(Std.int(originalMainContentWidth), FlxG.height - 80, FlxColor.fromRGB(35, 35, 35), true);
        add(mainContent);
        
        FlxTween.tween(mainContent, {x: 210}, 0.5, {ease: FlxEase.quartOut});
        
        // Initialize content
        titles = ["Getting Started", "Basic Concepts", "Advanced Topics", "API Reference"];
        contents = [
            "Welcome to the documentation.\nThis is a comprehensive guide.",
            "Learn about the basic concepts here.",
            "Explore advanced topics and features.",
            "API reference and documentation."
        ];
        
        // Menu items
        menuItems = new FlxTypedGroup<FlxButton>();
        for (i in 0...titles.length)
        {
            var menuItem = new FlxButton(20, 70 + (i * 50), titles[i], function() {
                currentPage = i;
                updateSelection();
                animatePageChange();
            });
            menuItem.label.setFormat(null, 14, FlxColor.WHITE, "center");
            menuItems.add(menuItem);
        }
        add(menuItems);
        
        // Content text
        contentText = new FlxText(230, 80, FlxG.width - 280, contents[0], currentFontSize);
        contentText.color = FlxColor.WHITE;
        add(contentText);
        
        // Topic label
        topicLabel = new FlxText(230, 20, FlxG.width - 350, titles[0], 24);
        topicLabel.color = FlxColor.WHITE;
        add(topicLabel);
        
        // Settings button
        settingsButton = new FlxButton(FlxG.width - 110, 20, "Settings", toggleAccessibilityMenu);
        add(settingsButton);
        
        // Scroll components
        scrollBar = new FlxSprite(FlxG.width - 30, 70);
        scrollBar.makeGraphic(8, FlxG.height - 80, FlxColor.fromRGB(50, 50, 50), true);
        add(scrollBar);
        
        scrollThumb = new FlxSprite(FlxG.width - 30, 70);
        scrollThumb.makeGraphic(8, 40, FlxColor.fromRGB(100, 100, 100), true);
        add(scrollThumb);
        
        updateSelection();
    }
    
    private function toggleAccessibilityMenu():Void
    {
        // Simple toggle for now
        trace("Settings clicked");
    }
    
    private function animatePageChange():Void
    {
        FlxTween.tween(contentText, {alpha: 0}, 0.2, {
            onComplete: function(_) {
                contentText.text = contents[currentPage];
                FlxTween.tween(contentText, {alpha: 1}, 0.2);
            }
        });
        
        FlxTween.tween(topicLabel, {alpha: 0}, 0.2, {
            onComplete: function(_) {
                topicLabel.text = titles[currentPage];
                FlxTween.tween(topicLabel, {alpha: 1}, 0.2);
            }
        });
    }
    
    private function updateSelection():Void
    {
        for (i in 0...menuItems.length)
        {
            var item = menuItems.members[i];
            if (i == currentPage)
            {
                item.color = FlxColor.YELLOW;
            }
            else
            {
                item.color = FlxColor.WHITE;
            }
        }
        
        scrollPosition = 0;
        updateScroll();
    }
    
    private function updateScroll():Void
    {
        maxScroll = Math.max(0, contentText.height - (FlxG.height - 90));
        scrollPosition = Math.max(0, Math.min(scrollPosition, maxScroll));
        
        contentText.y = 80 - scrollPosition;
        
        if (maxScroll > 0)
        {
            scrollThumb.visible = true;
            var ratio = scrollPosition / maxScroll;
            scrollThumb.y = scrollBar.y + ratio * (scrollBar.height - scrollThumb.height);
        }
        else
        {
            scrollThumb.visible = false;
        }
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        if (FlxG.keys.justPressed.ENTER)
        {
            isFullscreen = !isFullscreen;
            
            if (isFullscreen)
            {
                FlxTween.tween(sidebar, {x: -200}, 0.3, {ease: FlxEase.quartOut});
                FlxTween.tween(mainContent, {x: 10, width: FlxG.width - 20}, 0.3, {ease: FlxEase.quartOut});
                FlxTween.tween(contentText, {x: 30, fieldWidth: FlxG.width - 60}, 0.3, {ease: FlxEase.quartOut});
                menuItems.visible = false;
            }
            else
            {
                FlxTween.tween(sidebar, {x: 10}, 0.3, {ease: FlxEase.quartOut});
                FlxTween.tween(mainContent, {x: originalMainContentX, width: originalMainContentWidth}, 0.3, {ease: FlxEase.quartOut});
                FlxTween.tween(contentText, {x: 230, fieldWidth: FlxG.width - 280}, 0.3, {ease: FlxEase.quartOut});
                menuItems.visible = true;
            }
        }
        
        if (FlxG.mouse.wheel != 0)
        {
            scrollPosition -= FlxG.mouse.wheel * 20;
            updateScroll();
        }
        
        if (FlxG.mouse.overlaps(scrollThumb))
        {
            if (FlxG.mouse.pressed)
            {
                isDragging = true;
            }
        }
        
        if (isDragging)
        {
            if (FlxG.mouse.pressed)
            {
                var ratio = (FlxG.mouse.y - scrollBar.y) / (scrollBar.height - scrollThumb.height);
                scrollPosition = ratio * maxScroll;
                updateScroll();
            }
            else
            {
                isDragging = false;
            }
        }
    }
}