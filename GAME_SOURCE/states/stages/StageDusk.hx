package states.stages;

import states.stages.objects.*;
import objects.Character;

class StageDusk extends BaseStage
{
	var stageBack2:BGSprite;
	var stageFront2:BGSprite;
	var stageCurtains2:BGSprite;

	var stageBack:BGSprite;
	var stageFront:BGSprite;
	var stageCurtains:BGSprite;
	override function create()
	{
		stageBack = new BGSprite('weebEvil/Dusk/stageback', -600, -200, 0.9, 0.9);
		stageBack.antialiasing = ClientPrefs.data.antialiasing;
		add(stageBack);

		stageFront = new BGSprite('weebEvil/Dusk/stagefront', -650, 600, 0.9, 0.9);
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		add(stageFront);

		stageCurtains = new BGSprite('weebEvil/Dusk/stagecurtains', -550, -300, 1.3, 1.3);
		stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 1.1));
		stageCurtains.updateHitbox();
		add(stageCurtains);


		stageBack2 = new BGSprite('weebEvil/Dusk/original/stageback', -600, -200, 0.9, 0.9);
		stageBack2.antialiasing = ClientPrefs.data.antialiasing;
		stageBack2.visible = false;
		add(stageBack2);

		stageFront2 = new BGSprite('weebEvil/Dusk/original/stagefront', -650, 600, 0.9, 0.9);
		stageFront2.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront2.updateHitbox();
		stageFront2.visible = false;
		add(stageFront2);

		stageCurtains2 = new BGSprite('weebEvil/Dusk/original/stagecurtains', -550, -300, 1.3, 1.3);
		stageCurtains2.setGraphicSize(Std.int(stageCurtains2.width * 1.1));
		stageCurtains2.updateHitbox();
		stageCurtains2.visible = false;
		add(stageCurtains2);
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "change stage":
				if (value1 == 'true' || value1 == 'True' || flValue1 == 1 || value1 == 'TRUE') {
					stageBack.visible = false;
					stageFront.visible = false;
					stageCurtains.visible = false;

					stageBack2.visible = true;
					stageFront2.visible = true;
					stageCurtains2.visible = true;
				}
				if (value1 == 'false' || value1 == 'False' || flValue1 == 0 || value1 == 'FALSE') {
					stageBack.visible = true;
					stageFront.visible = true;
					stageCurtains.visible = true;

					stageBack2.visible = false;
					stageFront2.visible = false;
					stageCurtains2.visible = false;
				}
		}
	}
}