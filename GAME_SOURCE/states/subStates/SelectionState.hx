package states.subStates;

import flixel.ui.FlxButton;

class SelectionState extends MusicBeatState {
    
    var box1:FlxSprite;
    var box2:FlxSprite;

    var box1Button:FlxButton;
    var box2Button:FlxButton;

    var selectedSomenting:Bool = true;

    public function new() {
        MusicBeatState.updatestate('Diary or Archievements');
        super();   
    }

    override function create() {
        box1 = new FlxSprite(25, 0).loadGraphic(Paths.image('box'));
        box1.y = FlxG.height - (FlxG.height / 2);
        box1.visible = false;
        add(box1);

        box2 = new FlxSprite(0, 0).loadGraphic(Paths.image('box'));
        box2.y = FlxG.height - (FlxG.height / 2);
        box2.x = FlxG.width - (box2.width + 25);
        box2.visible = false;
        add(box2);

        box1Button = new FlxButton(25, 0, "", onDiary);
        box1Button.antialiasing = ClientPrefs.data.antialiasing;
        box1Button.loadGraphicFromSprite(box1);
        box1Button.y = FlxG.height - (FlxG.height / 2);
        add(box1Button);

        box2Button = new FlxButton(0, 0, "", onArchievements);
        box2Button.antialiasing = ClientPrefs.data.antialiasing;
        box2Button.loadGraphicFromSprite(box2);
        box2Button.y = FlxG.height - (FlxG.height / 2);
        box2Button.x = FlxG.width - (box2.width + 25);
        add(box2Button);

        selectedSomenting = false;
        
        super.create();
    }

    function onArchievements() {
        selectedSomenting = true;
        FlxTween.tween(box2, {alpha: 0, "scale.x": 1}, 1.8,{
            ease: FlxEase.circIn,
            onComplete: function(twn:FlxTween) {
               MusicBeatState.switchState(new MainMenuState());
            }
       });
    }

    function onDiary() {
        selectedSomenting = true;
        FlxTween.tween(box1, {alpha: 0, "scale.x": 2.5}, 1,{
             ease: FlxEase.circIn,
             onComplete: function(twn:FlxTween) {
                MusicBeatState.switchState(new MainMenuState());
             }
        });
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (!selectedSomenting) {

        if (FlxG.mouse.overlaps(box1Button)) {
            FlxTween.cancelTweensOf(box1Button);
            FlxTween.tween(box1Button, {y: FlxG.height - (FlxG.height / 2) - 50}, 0.7, {
                ease: FlxEase.linear
            });
        } else {
            FlxTween.tween(box1Button, {y: FlxG.height - (FlxG.height / 2)}, 0.7, {
                ease: FlxEase.linear
            });
        }

        if (FlxG.mouse.overlaps(box2Button)) {
            FlxTween.cancelTweensOf(box2Button);
            FlxTween.tween(box2Button, {y: FlxG.height - (FlxG.height / 2) - 50}, 0.7, {
                ease: FlxEase.linear
            });
        } else {
            FlxTween.tween(box2Button, {y: FlxG.height - (FlxG.height / 2)}, 0.7, {
                ease: FlxEase.linear
            });
        }
        }
    }
}