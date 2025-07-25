package states.stages;

import states.stages.objects.*;
import objects.Character;

class StageWeek1 extends BaseStage
{
	override function create()
	{
		var stageBack:BGSprite = new BGSprite('weebEvil/DeathMatch/eyesBack', -600, -200, 0.9, 0.9);
		add(stageBack);
		FlxTween.tween(stageBack, {alpha: 0}, 2, {
			type: PINGPONG
		});

		var background:BGSprite = new BGSprite('weebEvil/DeathMatch/background', -600, -200, 0.9, 0.9, ['DeathmatchStage'], true, ClientPrefs.data.SpritesFPS);
		background.antialiasing = ClientPrefs.data.antialiasing;
		add(background);

		var stageFront:BGSprite = new BGSprite('weebEvil/DeathMatch/stagefront', -650, 600, 0.9, 0.9);
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		add(stageFront);
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			
		}
	}

	override function createPost() {
		var stageCurtains:BGSprite = new BGSprite('weebEvil/DeathMatch/stagecurtains', -500, -300, 1.3, 1.3);
		stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 1.1));
		stageCurtains.updateHitbox();
		add(stageCurtains);
	}
}