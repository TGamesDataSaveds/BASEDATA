package states.stages;

import states.stages.objects.*;
import substates.GameOverSubstate;
import cutscenes.DialogueBox;

#if MODS_ALLOWED
import sys.FileSystem;
#else
import openfl.utils.Assets as OpenFlAssets;
#end

class School extends BaseStage
{
	//var bgGirls:BackgroundGirls;

	//BG NORMAL
	var bgSky:BGSprite;
	var bgSchool:BGSprite;
	var bgStreet:BGSprite;
	var fgTrees:BGSprite;
	var bgTrees:FlxSprite;
	var treeLeaves:BGSprite;
	var schoolBG:BGSprite;

	public var mode:Bool = false;

	override function create()
	{
		var _song = PlayState.SONG;
		if(_song.gameOverSound == null || _song.gameOverSound.trim().length < 1) GameOverSubstate.deathSoundName = 'fnf_loss_sfx-pixel';
		if(_song.gameOverLoop == null || _song.gameOverLoop.trim().length < 1) GameOverSubstate.loopSoundName = 'gameOver-pixel';
		if(_song.gameOverEnd == null || _song.gameOverEnd.trim().length < 1) GameOverSubstate.endSoundName = 'gameOverEnd-pixel';

		bgSky = new BGSprite('weeb/weebSky', 0, 0, 0.1, 0.1);
		add(bgSky);
		bgSky.antialiasing = false;

		var repositionShit = -200;

		bgSchool = new BGSprite('weeb/weebSchool', repositionShit, 0, 0.6, 0.90);
		add(bgSchool);
		bgSchool.antialiasing = false;

		bgStreet = new BGSprite('weeb/weebStreet', repositionShit, 0, 0.95, 0.95);
		add(bgStreet);
		bgStreet.antialiasing = false;

		var widShit = Std.int(bgSky.width * PlayState.daPixelZoom);
		if(!ClientPrefs.data.lowQuality) {
			fgTrees = new BGSprite('weeb/weebTreesBack', repositionShit + 170, 130, 0.9, 0.9);
			fgTrees.setGraphicSize(Std.int(widShit * 0.8));
			fgTrees.updateHitbox();
			add(fgTrees);
			fgTrees.antialiasing = false;
		}

		bgTrees = new FlxSprite(repositionShit - 380, -800);
		bgTrees.frames = Paths.getPackerAtlas('weeb/weebTrees');
		if (!ClientPrefs.data.noneBGAnimated) bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], ClientPrefs.data.SpritesFPS);
		if (ClientPrefs.data.noneBGAnimated) bgTrees.animation.add('treeLoop', [0], ClientPrefs.data.SpritesFPS);
		bgTrees.animation.play('treeLoop');
		bgTrees.scrollFactor.set(0.85, 0.85);
		add(bgTrees);
		bgTrees.antialiasing = false;

		if(!ClientPrefs.data.lowQuality) {
			if (!ClientPrefs.data.noneBGAnimated) treeLeaves = new BGSprite('weeb/petals', repositionShit, -40, 0.85, 0.85, ['PETALS ALL'], true);
			if (ClientPrefs.data.noneBGAnimated) treeLeaves = new BGSprite('weeb/petals', repositionShit, -40, 0.85, 0.85, ['PETALS ALL0000'], true);
			treeLeaves.setGraphicSize(widShit);
			treeLeaves.updateHitbox();
			add(treeLeaves);
			treeLeaves.antialiasing = false;
		}

		if (!ClientPrefs.data.noneBGAnimated) schoolBG = new BGSprite('weebEvil/animatedEvilSchool', 400, 250, 0.8, 0.9, ['bgAnimated'], true, ClientPrefs.data.SpritesFPS);
		if (ClientPrefs.data.noneBGAnimated) schoolBG = new BGSprite('weebEvil/animatedEvilSchool', 400, 250, 0.8, 0.9, ['bgAnimated 0000'], true, ClientPrefs.data.SpritesFPS);
		schoolBG.scale.set(PlayState.daPixelZoom, PlayState.daPixelZoom);
		schoolBG.antialiasing = false;
		schoolBG.visible = false;
		add(schoolBG);

		bgSky.setGraphicSize(widShit);
		bgSchool.setGraphicSize(widShit);
		bgStreet.setGraphicSize(widShit);
		bgTrees.setGraphicSize(Std.int(widShit * 1.4));

		bgSky.updateHitbox();
		bgSchool.updateHitbox();
		bgStreet.updateHitbox();
		bgTrees.updateHitbox();
	}

	// For events
	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "BG Freaks Expression":
				FlxG.cameras.flash(FlxColor.WHITE, 0.1);
				if (flValue1 == 0) {
					schoolBG.visible = false;

					bgSky.visible = true;
					bgStreet.visible = true;
					bgTrees.visible = true;
					fgTrees.visible = true;
					treeLeaves.visible = true;
				}
				if (flValue1 == 1) {
					schoolBG.visible = true;

					bgSky.visible = false;
					bgStreet.visible = false;
					bgTrees.visible = false;
					fgTrees.visible = false;
					treeLeaves.visible = false;
				}
			
			case "Change Character":
				if (value2 == 'spirit') {
					schoolBG.visible = true;

					bgSky.visible = false;
					bgStreet.visible = false;
					bgTrees.visible = false;
					fgTrees.visible = false;
					treeLeaves.visible = false;
				}
				if (value2 == 'senpai5' || value2 == 'senpai6' || value2 == 'senpai7') {
					schoolBG.visible = false;

					bgSky.visible = true;
					bgStreet.visible = true;
					bgTrees.visible = true;
					fgTrees.visible = true;
					treeLeaves.visible = true;
				}
		}
	}
}