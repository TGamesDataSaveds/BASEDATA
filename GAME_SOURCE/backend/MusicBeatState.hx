package backend;

import flixel.FlxSubState;
import states.MainMenuState;
import states.TitleState;
import lime.ui.Window;
import flixel.addons.ui.FlxUIState;
//
import flixel.FlxState;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

#if VIDEOS_ALLOWED 
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler;
#else import vlc.MP4Handler as VideoHandler; #end
#end

class MusicBeatState extends FlxUIState
{
	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;

	public static var fps:String;
	public static var memory:String;

	private var curDecBeat:Float = 0;
	
	public static var Blacktrans:FlxSprite;
	public var controls(get, never):Controls;
	private var Tcomplete:Bool = false;
	private function get_controls()
	{
		return Controls.instance;
	}

	public static var stateName:String = '';

	public static var leftSprite:FlxSprite;
	public static var rightSprite:FlxSprite;

	#if VIDEO_ALLOWED
	public static var video:VideoHandler;
	#end

	override function create() {
		
//		var skip:Bool = FlxTransitionableState.skipNextTransOut;
		#if MODS_ALLOWED Mods.updatedOnState = false; #end

		leftSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width / 2), FlxG.height, FlxColor.BLACK);
		leftSprite.screenCenter(Y);
		leftSprite.alpha = 1;
		add(leftSprite);

		rightSprite = new FlxSprite(leftSprite.width, 0).makeGraphic(Std.int(FlxG.width / 2), FlxG.height, FlxColor.BLACK);
		rightSprite.screenCenter(Y);
		rightSprite.alpha = 1;
		add(rightSprite);

		FlxTween.tween(leftSprite, {x: leftSprite.x - Std.int(FlxG.width / 2), alpha: 0}, 0.9, {ease: FlxEase.linear});
		FlxTween.tween(rightSprite, {x: FlxG.width, alpha: 0}, 0.9, {ease: FlxEase.linear});

		FlxG.cameras.fade(FlxColor.BLACK, 1, true, function() Tcomplete = true, true);

		super.create();
		
		timePassedOnState = 0;
	}

	public static var timePassedOnState:Float = 0;
	override function update(elapsed:Float)
	{
		//everyStep();
		var oldStep:Int = curStep;
		timePassedOnState += elapsed;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
		{
			if(curStep > 0)
				stepHit();

			if(PlayState.SONG != null)
			{
				if (oldStep < curStep)
					updateSection();
				else
					rollbackSection();
			}
		}
		
		stagesFunc(function(stage:BaseStage) {
			stage.update(elapsed);
		});

		super.update(elapsed);
	}

	private function updateSection():Void
	{
		if(stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while(curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	static function exitMenu(?setTimeValue:Float = null) {
		if (setTimeValue == null) {
		FlxTween.tween(leftSprite, {x: 0, alpha: 1}, 0.9, {ease: FlxEase.linear});
		FlxTween.tween(rightSprite, {x: leftSprite.width, alpha: 1}, 0.9, {ease: FlxEase.linear});
		} else {
			FlxTween.tween(leftSprite, {x: 0, alpha: 1}, setTimeValue, {ease: FlxEase.linear});
			FlxTween.tween(rightSprite, {x: leftSprite.width, alpha: 1}, setTimeValue, {ease: FlxEase.linear});
		}
	}

	public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();
	public static function getVariables()
		return getState().variables;

	private function rollbackSection():Void
	{
		if(curStep < 0) return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if(stepsToDo > curStep) break;
				
				curSection++;
			}
		}

		if(curSection > lastSection) sectionHit();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.data.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public static function switchState(nextState:FlxState = null) {
		if(nextState == null) nextState = FlxG.state;
		if(nextState == FlxG.state)
		{
			resetState();
			return;
		}

		WindowProperty.VolumeControlls(true);

		if (PlayState.stageUI == "pixel") PlayState.stageUI = "normal";

		//Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();

		openfl.display.FPS.activeStatus = false;
		exitMenu();
		FlxG.cameras.fade(FlxColor.BLACK, 1, false, function() FlxG.switchState(nextState), true);
	}

	public static function fastSwitchState(nextState:FlxState = null) {
		if(nextState == null) nextState = FlxG.state;
		if(nextState == FlxG.state)
		{
			fastResetState();
			return;
		}

		WindowProperty.VolumeControlls(true);

		if (PlayState.stageUI == "pixel") PlayState.stageUI = "normal";

		openfl.display.FPS.activeStatus = false;
		exitMenu(0.1);
		FlxG.cameras.fade(FlxColor.BLACK, 0.2, false, function() FlxG.switchState(nextState), true);
	}

	public static function nullswitchState(nextState:FlxState = null) {
		openfl.display.FPS.activeStatus = false;
		if(nextState == null) nextState = FlxG.state;
		if(nextState == FlxG.state)
		{
			resetState();
			return;
		}

		WindowProperty.VolumeControlls(true);

		FlxG.switchState(nextState);
	}

	public static function updatestate(state:String, ?language:String) {

		stateName = state;

		if (ClientPrefs.data.updateState) Lib.application.window.title = "Friday Night Funkin': Ending Corruption";
		
		if (!ClientPrefs.data.updateState) Lib.application.window.title = "Friday Night Funkin': Ending Corruption (" + state + ")";
	}

	public static function updateFPS() {
		Lib.application.window.title = "Friday Night Funkin': Ending Corruption";
	}

	public static function notiWindows(?message:String, ?title:String) {
		Lib.application.window.alert(message, title);
	}

	public static function test(alpha:Float) {
		//Lib.application.window.opacity = alpha;
	}

	public static function newVideo(name:String, nextState:FlxState = null)
		{
			#if VIDEOS_ALLOWED
	
			var filepath:String = Paths.video(name);
			#if sys
			if(!FileSystem.exists(filepath))
			#else
			if(!OpenFlAssets.exists(filepath))
			#end
			{
				FlxG.log.warn('Couldnt find video file: ' + name);
				return;
			}
	
				video = new VideoHandler();
				#if (hxCodec >= "3.0.0")
				// Recent versions
				video.play(filepath);
				video.onEndReached.add(function()
				{
					video.dispose();
					switchState(nextState);
					return;
				}, true);
				#else
				// Older versions
				video.playVideo(filepath);
				video.finishCallback = function()
				{
					return;
				}
				#end

			#else
			FlxG.log.warn('Platform not supported!');
			return;
			#end
		}


	public static function openSubStateY(subState:FlxSubState) {
		FlxG.state.openSubState(subState);
		trace('SubState Open');
	}
	public static function resetState() {
		openfl.display.FPS.activeStatus = false;
		exitMenu(0.1);
		WindowProperty.VolumeControlls(true);
		FlxG.cameras.fade(FlxColor.BLACK, 0.2, false, function() FlxG.resetState(), true);
	}
	public static function fastResetState() {
		openfl.display.FPS.activeStatus = false;
		exitMenu(0.09);
		WindowProperty.VolumeControlls(true);
		FlxG.cameras.fade(FlxColor.BLACK, 0.1, false, function() FlxG.resetState(), true);
	}

	// Custom made Trans in
	public static function startTransition(nextState:FlxState = null)
	{
		if(nextState == null)
			nextState = FlxG.state;

		FlxG.state.openSubState(new CustomFadeTransition(0.6, false));
		if(nextState == FlxG.state)
			CustomFadeTransition.finishCallback = function() FlxG.resetState();
		else
			CustomFadeTransition.finishCallback = function() FlxG.switchState(nextState);
	}

	public static function getState():MusicBeatState {
		return cast (FlxG.state, MusicBeatState);
	}

	public function stepHit():Void
	{
		stagesFunc(function(stage:BaseStage) {
			stage.curStep = curStep;
			stage.curDecStep = curDecStep;
			stage.stepHit();
		});

		if (curStep % 4 == 0)
			beatHit();
	}

	public var stages:Array<BaseStage> = [];
	public function beatHit():Void
	{
		//trace('Beat: ' + curBeat);
		stagesFunc(function(stage:BaseStage) {
			stage.curBeat = curBeat;
			stage.curDecBeat = curDecBeat;
			stage.beatHit();
		});
	}

	public function sectionHit():Void
	{
	/*	//trace('Section: ' + curSection + ', Beat: ' + curBeat + ', Step: ' + curStep);
		stagesFunc(function(stage:BaseStage) {
			stage.curSection = curSection;
			stage.sectionHit();
		});*/
	}

	function stagesFunc(func:BaseStage->Void)
	{
		for (stage in stages)
			if(stage != null && stage.exists && stage.active)
				func(stage);
	}

	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}
}
