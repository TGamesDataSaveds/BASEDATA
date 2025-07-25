package states.stages;

import flixel.util.FlxDestroyUtil;
import flixel.util.helpers.FlxPointRangeBounds;
import states.stages.objects.*;
import objects.Character;
import objects.BGSpriteWeek;
import flixel.effects.particles.FlxEmitter;

class EvilStageVS extends BaseStage
{

	var bg:BGSprite;
	var tv:BGSprite;
	var background:BGSprite;

	override function create()
	{
		bg = new BGSprite("weebEvil/BG", -500, -380, 1, 1);
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.setGraphicSize(Std.int(bg.width) - 180, Std.int(bg.height) - 180);
		add(bg);

		tv = new BGSprite("weebEvil/animation/tv_off", 160, -100, 1, 1, ["tv"], true, 50);
		tv.antialiasing = ClientPrefs.data.antialiasing;
		tv.setGraphicSize(Std.int(tv.width) - 85, Std.int(tv.height) - 85);
		add(tv);

		
	}

	override function eventPushed(event:objects.Note.EventNote) {
		switch (event.event) {
		case "subState":
			background = new BGSprite('weebEvil/BGMask', -500, -380, 1, 1);
			background.antialiasing = ClientPrefs.data.antialiasing;
			background.setGraphicSize(Std.int(background.width) - 180, Std.int(background.height) - 180);
			addBehindDad(background);
		
		}

	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{

		}	
	}

	override function beatHit() {

		var dustParticles:FlxEmitter;
		dustParticles = new FlxEmitter(0, 0, FlxG.random.int(10, 20));
		dustParticles.makeParticles(FlxG.random.int(14, 25), FlxG.random.int(10, 23), FlxColor.GRAY, 50);
		dustParticles.width = FlxG.width;
		dustParticles.height = FlxG.height;
		add(dustParticles);
		dustParticles.start(false, 0.2, 15);
		FlxTween.tween(dustParticles, {alpha: 0}, FlxG.random.float(0.5, 1.5), {
			type: FlxTweenType.ONESHOT
		});

		super.beatHit();
	}
}