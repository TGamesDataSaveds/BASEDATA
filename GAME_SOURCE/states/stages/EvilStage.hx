package states.stages;

import states.stages.objects.*;
import objects.Character;
import objects.BGSpriteWeek;
import flixel.effects.particles.FlxEmitter;

class EvilStage extends BaseStage
{

	var bg:BGSprite;
	var tv:BGSprite;

	var InitialScale:Array<Float>;

	override function create()
	{
		bg = new BGSprite("weebEvil/BG", -500, -380, 1, 1);
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.setGraphicSize(Std.int(bg.width) - 180, Std.int(bg.height) - 180);
		add(bg);

		tv = new BGSprite("weebEvil/animation/tv_off", 160, -100, 1, 1, ["tv"], true, 190);
		tv.antialiasing = ClientPrefs.data.antialiasing;
		tv.setGraphicSize(Std.int(tv.width) - 85, Std.int(tv.height) - 85);
		add(tv);

		InitialScale = [tv.scale.x, tv.scale.y]; 
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{

		}	
	}

	override function update(elapsed:Float)
	{

		super.update(elapsed);
	}

	override function additionalEffects() {
		
		FlxTween.cancelTweensOf(tv);
		FlxTween.tween(tv, {"scale.x": InitialScale[0] + 0.05, "scale.y": InitialScale[1] + 0.05}, 0.8, {
			type: BACKWARD,
			ease: FlxEase.linear
		});
		
		super.additionalEffects();
	}
}