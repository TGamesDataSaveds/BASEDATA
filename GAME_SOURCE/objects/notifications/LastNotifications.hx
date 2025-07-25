package objects.notifications;

class LastNotifications extends FlxSpriteGroup {

    var bg:FlxSprite;
    var textTXT:FlxText;
    public function new(camera:FlxCamera = null, text:String = '', ?color:FlxColor = FlxColor.WHITE, ?textCOLOR:FlxColor = FlxColor.BLACK) {
        super(x, y);

        bg = new FlxSprite(0, 0).loadGraphic(Paths.image('notification_compact'));
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.alpha = 0;
        bg.x = 0 - bg.width;
        add(bg);

        textTXT = new FlxText(bg.x, 5, bg.width, text, 10);
        textTXT.antialiasing = ClientPrefs.data.antialiasing;
        textTXT.color = FlxColor.BLACK;
        textTXT.borderColor = FlxColor.BLACK;
        add(textTXT);

        var cam:Array<FlxCamera> = FlxCamera.defaultCameras;
		if(camera != null) {
			cam = [camera];
		}
		this.cameras = cam;

        FlxTween.color(bg, 0.3, FlxColor.WHITE, color, {
            ease: FlxEase.linear
        });
        FlxTween.color(textTXT, 0.3, FlxColor.BLACK, textCOLOR, {
            ease: FlxEase.linear
        });

        FlxTween.tween(bg, {alpha: 1, x: 0}, 1, {
            ease: FlxEase.linear,
                onComplete: function(twn:FlxTween) {
                    FlxTween.tween(bg, {x: 0 - bg.width, alpha: 0}, 1, {
                        ease: FlxEase.linear,
                        startDelay: 2
                    });
                    FlxTween.tween(Main.fpsVar, {y: 3}, 1.1, {
                        ease: FlxEase.linear,
                        startDelay: 2.1
                    });
                }
            }
        );
        FlxTween.cancelTweensOf(Main.fpsVar);
        FlxTween.tween(Main.fpsVar, {y: 32}, 0.5, {
            ease: FlxEase.linear
        });
    }

    override function update(elapsed:Float) {

        textTXT.x = bg.x;

        super.update(elapsed);
    }
}