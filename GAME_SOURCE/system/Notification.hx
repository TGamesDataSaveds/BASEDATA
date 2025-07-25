package system;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

enum NotificationType {
    Normal;
    Important;
    System;
    Debug;
}

class Notification extends FlxSprite {
    public var title:String;
    public var description:String;
    public var type:NotificationType;
    
    private var titleText:FlxText;
    private var descriptionText:FlxText;
    private var expanded:Bool = false;

    public function new(X:Float, Y:Float, Title:String, Description:String, Type:NotificationType) {
        super(X, Y);
        
        title = Title;
        description = Description;
        type = Type;

        makeGraphic(300, 50, FlxColor.BLACK);
        alpha = 0.8;

        titleText = new FlxText(X + 5, Y + 5, 290, title);
        titleText.setFormat(null, 16, FlxColor.WHITE, "left");

        descriptionText = new FlxText(X + 5, Y + 25, 290, description);
        descriptionText.setFormat(null, 12, FlxColor.WHITE, "left");

        switch(type) {
            case Normal: color = FlxColor.GRAY;
            case Important: color = FlxColor.RED;
            case System: color = FlxColor.BLUE;
            case Debug: color = FlxColor.GREEN;
        }
    }

    public function show():Void {
        FlxTween.tween(this, {y: y + 60}, 0.5, {ease: FlxEase.backOut});
    }

    public function hide():Void {
        FlxTween.tween(this, {y: y - 60}, 0.5, {ease: FlxEase.backIn, onComplete: function(_) {
            kill();
        }});
    }

    public function expand():Void {
        if (!expanded) {
            FlxTween.tween(this, {height: 100}, 0.3, {ease: FlxEase.quadOut});
            FlxTween.tween(descriptionText, {y: y + 50}, 0.3, {ease: FlxEase.quadOut});
            expanded = true;
        } else {
            FlxTween.tween(this, {height: 50}, 0.3, {ease: FlxEase.quadIn});
            FlxTween.tween(descriptionText, {y: y + 25}, 0.3, {ease: FlxEase.quadIn});
            expanded = false;
        }
    }

    override public function update(elapsed:Float):Void {
        super.update(elapsed);
        titleText.update(elapsed);
        descriptionText.update(elapsed);
    }

    override public function draw():Void {
        super.draw();
        titleText.draw();
        descriptionText.draw();
    }
}