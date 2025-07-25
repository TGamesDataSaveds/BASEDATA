package states;

// If you want to add your stage to the game, copy states/stages/Template.hx,
// and put your stage code there, then, on PlayState, search for
// "switch (curStage)", and add your stage to that list.

// If you want to code Events, you can either code it on a Stage file or on PlayState, if you're doing the latter, search for:
// "function eventPushed" - Only called *one time* when the game loads, use it for precaching events that use the same assets, no matter the values
// "function eventPushedUnique" - Called one time per event, use it for precaching events that uses different assets based on its values
// "function eventEarlyTrigger" - Used for making your event start a few MILLISECONDS earlier
// "function triggerEvent" - Called when the song hits your event's timestamp, this is probably what you were looking for

import cutscenes.DialogueBox;
import states.inicio.StartingState;
import flixel.addons.effects.FlxTrail;
import shaders.Filters;
import flixel.input.keyboard.FlxKeyboard.FlxKeyInput;
import options.ControlsSubState;
import substates.PauseModeSubState;
import substates.GameplayChangersSubstate;
import openfl.display.Stage;
import backend.Highscore;
import backend.StageData;
import backend.WeekData;
import backend.Song;
import backend.Section;
import backend.Rating;
import objects.Notification;
import flixel.input.keyboard.FlxKey;

import flixel.addons.api.FlxGameJolt;

import backend.InputFormatter;

import flixel.effects.FlxFlicker;

import flixel.input.gamepad.FlxGamepad;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSubState;
////
import flixel.math.FlxPoint;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.animation.FlxAnimationController;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import openfl.events.KeyboardEvent;
import tjson.TJSON as Json;

import cutscenes.CutsceneHandler;
import cutscenes.DialogueBoxPsych;

import states.TitleState;
import states.StoryMenuState;
import states.FreeplayState;
import states.editors.ChartingState;
import states.editors.CharacterEditorState;

import substates.PauseModeSubState;
import substates.GameOverSubstate;

#if !flash 
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end

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

import objects.Note.EventNote;
import objects.*;
import states.stages.objects.*;

#if LUA_ALLOWED
import psychlua.*;
#else
import psychlua.FunkinLua;
import psychlua.LuaUtils;
import psychlua.HScript;
#end

#if desktop
	#if (SScript >= "3.0.0")
		import tea.SScript;
	#else
		import tea.SScript;
	#end
#end

class PlayState extends MusicBeatState
{
	public static var STRUM_X = 42;
	public static var STRUM_X_MIDDLESCROLL = -278;

	public static var deathcause:String = '';

	public static var ratingStuffESPANISH:Array<Dynamic> = [
		["La corrupción inicia...", 0.02],
		["Algo va mal...", 0.04],
		["Sientes el caos...", 0.06],
		["La oscuridad crece.", 0.08],
		["Tu control se desvanece.", 0.10],
		["Es solo el comienzo.", 0.12],
		["La música se oscurece.", 0.14],
		["Te estás perdiendo...", 0.16],
		["Notas peligrosas...", 0.18],
		["¿Aún puedes con esto?", 0.20],
		["Cada fallo te corrompe.", 0.22],
		["No hay vuelta atrás.", 0.24],
		["Te consume...", 0.26],
		["La música domina.", 0.28],
		["Estás cayendo...", 0.30],
		["El ritmo se vuelve mortal.", 0.32],
		["Estás perdiendo...", 0.34],
		["La corrupción te atrapa.", 0.36],
		["Te pierdes en la música.", 0.38],
		["Ya no eres tú.", 0.40],
		["Más profundo en la oscuridad.", 0.42],
		["Es una trampa sin fin.", 0.44],
		["Se acerca el final.", 0.46],
		["Nada te salvará.", 0.48],
		["Estás en el borde.", 0.50],
		["El ritmo te devora.", 0.52],
		["Sigues cayendo.", 0.54],
		["El abismo te espera.", 0.56],
		["La luz se apaga.", 0.58],
		["No hay esperanza.", 0.60],
		["Te consume por completo.", 0.62],
		["La oscuridad manda.", 0.64],
		["Estás atrapado.", 0.66],
		["No hay salida.", 0.68],
		["Casi pierdes todo.", 0.70],
		["¿Qué queda de ti?", 0.72],
		["Ya eres otro.", 0.74],
		["La corrupción gana.", 0.76],
		["Estás en su control.", 0.78],
		["Ya no tienes alma.", 0.80],
		["Todo se distorsiona.", 0.82],
		["No queda nada...", 0.84],
		["Eres uno con el caos.", 0.86],
		["El juego te venció.", 0.88],
		["La oscuridad triunfa.", 0.90],
		["Es tu fin...", 0.92],
		["Desvaneces.", 0.94],
		["La corrupción ha ganado.", 0.96],
		["No queda más...", 0.98],
		["Fin del juego.", 1.00],
		["!!ERES LA PERFECCION!!", 1]
	];
	public static var ratingStuffINGLISH:Array<Dynamic> = [
		["Corruption begins...", 0.02],
		["Something feels wrong...", 0.04],
		["Chaos stirs within.", 0.06],
		["Darkness spreads.", 0.08],
		["You're losing control.", 0.10],
		["This is only the start.", 0.12],
		["The music darkens.", 0.14],
		["You’re slipping away...", 0.16],
		["Dangerous notes...", 0.18],
		["Can you keep up?", 0.20],
		["Each miss corrupts you.", 0.22],
		["No turning back.", 0.24],
		["It's taking over...", 0.26],
		["The beat controls you.", 0.28],
		["You're falling...", 0.30],
		["The rhythm becomes deadly.", 0.32],
		["You're losing yourself...", 0.34],
		["Corruption traps you.", 0.36],
		["Lost in the music.", 0.38],
		["You're not the same.", 0.40],
		["Deeper into darkness.", 0.42],
		["An endless trap.", 0.44],
		["The end is near.", 0.46],
		["Nothing can save you.", 0.48],
		["On the edge...", 0.50],
		["The rhythm consumes you.", 0.52],
		["You keep falling.", 0.54],
		["The abyss awaits.", 0.56],
		["The light fades.", 0.58],
		["There’s no hope.", 0.60],
		["It completely owns you.", 0.62],
		["Darkness takes over.", 0.64],
		["You’re trapped.", 0.66],
		["There’s no escape.", 0.68],
		["You’re nearly gone.", 0.70],
		["What’s left of you?", 0.72],
		["You’re no longer yourself.", 0.74],
		["Corruption wins.", 0.76],
		["It controls you now.", 0.78],
		["Your soul is gone.", 0.80],
		["Reality distorts.", 0.82],
		["Nothing is left...", 0.84],
		["You’re one with the chaos.", 0.86],
		["The game defeated you.", 0.88],
		["Darkness prevails.", 0.90],
		["This is your end...", 0.92],
		["You’re fading away.", 0.94],
		["Corruption has won.", 0.96],
		["Nothing remains...", 0.98],
		["Game over.", 1.00],
		["!!You IS PERFECT!!", 1]
	];
	public static var ratingStuffPORTUGUES:Array<Dynamic> = [
		["A corrupção começa...", 0.02],
		["Algo está errado...", 0.04],
		["O caos desperta.", 0.06],
		["A escuridão se espalha.", 0.08],
		["Você está perdendo o controle.", 0.10],
		["Isso é só o começo.", 0.12],
		["A música fica sombria.", 0.14],
		["Você está se perdendo...", 0.16],
		["Notas perigosas...", 0.18],
		["Consegue continuar?", 0.20],
		["Cada erro te corrompe.", 0.22],
		["Não há volta.", 0.24],
		["Está tomando conta...", 0.26],
		["O ritmo te controla.", 0.28],
		["Você está caindo...", 0.30],
		["O ritmo se torna mortal.", 0.32],
		["Você está se perdendo...", 0.34],
		["A corrupção te prende.", 0.36],
		["Perdido na música.", 0.38],
		["Você já não é o mesmo.", 0.40],
		["Mais fundo na escuridão.", 0.42],
		["Uma armadilha sem fim.", 0.44],
		["O fim se aproxima.", 0.46],
		["Nada pode te salvar.", 0.48],
		["No limite...", 0.50],
		["O ritmo te consome.", 0.52],
		["Você continua caindo.", 0.54],
		["O abismo te espera.", 0.56],
		["A luz se apaga.", 0.58],
		["Não há esperança.", 0.60],
		["Está tomando tudo de você.", 0.62],
		["A escuridão prevalece.", 0.64],
		["Você está preso.", 0.66],
		["Não há saída.", 0.68],
		["Quase tudo se foi.", 0.70],
		["O que resta de você?", 0.72],
		["Você não é mais o mesmo.", 0.74],
		["A corrupção venceu.", 0.76],
		["Agora ela te controla.", 0.78],
		["Sua alma se foi.", 0.80],
		["A realidade se distorce.", 0.82],
		["Nada mais resta...", 0.84],
		["Você é um com o caos.", 0.86],
		["O jogo te venceu.", 0.88],
		["A escuridão triunfa.", 0.90],
		["Este é o seu fim...", 0.92],
		["Você está desaparecendo.", 0.94],
		["A corrupção venceu.", 0.96],
		["Nada mais resta...", 0.98],
		["Fim de jogo.", 1.00],
		["!!ÉS PERFEITO!!", 1]
	];

	//event variables
	private var isCameraOnForcedPos:Bool = false;

	public var boyfriendMap:Map<String, Character> = new Map<String, Character>();
	public var dadMap:Map<String, Character> = new Map<String, Character>();
	public var gfMap:Map<String, Character> = new Map<String, Character>();
	
	#if HSCRIPT_ALLOWED
	public var hscriptArray:Array<HScript> = [];
	public var instancesExclude:Array<String> = [];
	#end

	//Effect

	public var animCheck:String = 'hey';

	private var lastDifficultyName:String = Difficulty.getDefault();
	public var curDifficulty:Int = -1;

	var mode1:String;
	var mode2:String;
	var TxtScore:String;

	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;

	public var songSpeedTween:FlxTween;
	public var songSpeed(default, set):Float = 1;
	public var songSpeedType:String = "multiplicative";
	public var noteKillOffset:Float = 350;

	public var playbackRate(default, set):Float = 1;

	public var boyfriendGroup:FlxSpriteGroup;
	public var boyfriendGroup2:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;
	public static var curStage:String = '';
	public static var stageUI:String = "normal";
	public static var isPixelStage(get, never):Bool;

	@:noCompletion
	static function get_isPixelStage():Bool
		return stageUI == "pixel";


	public var NNN:Bool = false;

	public static var SONG:SwagSong = null;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	public var spawnTime:Float = 2000;

	public var vocals:FlxSound;
	public var inst:FlxSound;

	public var dad:Character = null;
	public var gf:Character = null;
	public var boyfriend:Character = null;
	public var boyfriend2:Character = null;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<EventNote> = [];

	public var FadeTime:FlxTimer;

	public var camFollow:FlxObject;
	private static var prevCamFollow:FlxObject;

	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;


	//FIXED
	public static var statusGame:Bool = false;

	public var camZooming:Bool = false;
	public var camZoomingMult:Float = 1;
	public var camZoomingDecay:Float = 1;
	private var curSong:String = "";

	public var gfSpeed:Int = 1;
	public var health:Float = 50;
	public var combo:Int = 0;

	public var overlay:FlxSprite;
	public var overlayLoost:FlxSprite;

	public static var healthBar:HealthBar;
	public var healthp:FlxSprite;

	public var ratingsData:Array<Rating> = Rating.loadDefault();
	public var fullComboFunction:Void->Void = null;

	private var generatedMusic:Bool = false;
	public var endingSong:Bool = false;
	public var startingSong:Bool = false;
	private var updateTime:Bool = true;
	public static var changedDifficulty:Bool = false;
	public static var chartingMode:Bool = false;

	//Gameplay settings
	public var healthGain:Float = 1;
	public var healthLoss:Float = 1;
	public var instakillOnMiss:Bool = false;
	public var cpuControlled:Bool = false;
	public var practiceMode:Bool = false;

	public var botplaySine:Float = 0;

	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camTGame:FlxCamera;
	public var camOther:FlxCamera;
	public var camHD:FlxCamera;
	public var camNotes:FlxCamera;
	public var camVIP:FlxCamera;
	public var camDIALOGUE:FlxCamera;
	public var cameraSpeed:Float = 1;

	//public var instancesExclude:String = '';

	public var babyArrow:StrumNote;

	public var songScore:Int = 0;
	public var songHits:Int = 0;
	public var songMisses:Int = 0;
	public var scoreTxt:FlxText;
	var timeTxt:FlxText;
	var scoreTxtTween:FlxTween;

	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var seenCutscene:Bool = false;
	public static var deathCounter:Int = 0;

	public var defaultCamZoom:Float = 1.05;

	public var dama:Bool = false;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;
	private var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var inCutscene:Bool = false;
	public var skipCountdown:Bool = false;
	var songLength:Float = 0;

	public var boyfriendCameraOffset:Array<Float> = null;
	public var opponentCameraOffset:Array<Float> = null;
	public var girlfriendCameraOffset:Array<Float> = null;

	public var songTimeMath:String;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	//Achievement shit
	var keysPressed:Array<Int> = [];
	var boyfriendIdleTime:Float = 0.0;
	var boyfriendIdleTime2:Float = 0.0;
	var boyfriendIdled:Bool = false;
	var boyfriendIdled2:Bool = false;

	public var songPosition:FlxText;

	//Estadisticas Variables
	public static var hitnotesong:Float;
	public static var missNotesong:Float;
	public static var deaths:Float;
	public static var scoresTotal:Float;
	public static var heyanim:Float;
	public static var pointsWin:Int;

	public var tipControls:FlxText;

	//Experiments
	public static var blackMode:FlxSprite;
	public static var signal:FlxSprite;
	public var transBlack:FlxSprite;
	public var hptext:FlxText;

	// Lua shit
	public static var instance:PlayState;
	public var luaArray:Array<FunkinLua> = [];
	#if LUA_ALLOWED
	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;
	#end
	public var introSoundsSuffix:String = '';

	// Less laggy controls
	private var keysArray:Array<String>;

	public var precacheList:Map<String, String> = new Map<String, String>();
	public var songName:String;

	// Callbacks for stages
	public var startCallback:Void->Void = null;
	public var endCallback:Void->Void = null;

	public var doge:Bool = false;

	public var difficultysong:String = Difficulty.getString().toUpperCase();

	public var mode:Bool;

	var isDad:Bool;
	var isBF:Bool;

	public var colorNum:FlxColor;

	public var statusFade:Bool;
	public var notitext:String = '';

	public var modes1:Bool;
	public var modes2:Bool;

	var boty:Bool = false;

	//Misiones
	public var missionsStatus:Array<Bool> = [false, false, false, false, false];

	public var SPANISH:Bool = ClientPrefs.data.language == 'Spanish';
	public var INGLISH:Bool = ClientPrefs.data.language == 'Inglish';
	public var PORTUGUESE:Bool = ClientPrefs.data.language == 'Portuguese';

	public var failNoti:String = '';

	public var healthTxt:FlxText;

	public var upBar:FlxSprite;
	public var downBar:FlxSprite;

	public var fireMode:Bool = false;
	public var couter:FlxTimer;
	public var fireT:Bool = false;
	#if (LUA_ALLOWED || HSCRIPT_ALLOWED)
	private var luaDebugGroup:FlxTypedGroup<psychlua.DebugLuaText>;
	#end

	public var tipPress:FlxText;

	public var dialogueMode:Bool = false;

	//var filterTV:Filters;

	public function onPress(Timer:FlxTimer):Void
		{
			if(ClientPrefs.data.scoreZoom && !cpuControlled)
				{
					camGame.zoom += 0.015 * camZoomingMult;
					camHUD.zoom += 0.03 * camZoomingMult;
		
					hitnotesong += 1;
		
					if(scoreTxtTween != null) {
						scoreTxtTween.cancel();
					}
					//FlxG.camera.zoom = 1.075;
					scoreTxt.scale.x = 1.075;
					scoreTxt.scale.y = 1.075;
					scoreTxtTween = FlxTween.tween(scoreTxt, {"scale.x": 1, "scale.y": 1}, 0.2, {
						onComplete: function(twn:FlxTween) {
							scoreTxtTween = null;
						}
					});
				}
		}

	override public function create()
	{
		//trace('Playback Rate: ' + playbackRate);

		//Note.preloadCommonAssets();

		startCallback = startCountdown;
		endCallback = startAchievement;

		// for lua
		instance = this;

		FlxGameJolt.init(845799, "2b119d62a23c00652c0b1ea9ae5adf55");
		FlxGameJolt.authUser();

		PauseModeSubState.songName = null; //Reset to default
		playbackRate = ClientPrefs.getGameplaySetting('songspeed');
		fullComboFunction = fullComboUpdate;

		keysArray = [
			'note_left',
			'note_down',
			'note_up',
			'note_right'
		];

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// Gameplay settings
		healthGain = ClientPrefs.getGameplaySetting('healthgain');
		healthLoss = ClientPrefs.getGameplaySetting('healthloss');
		instakillOnMiss = ClientPrefs.getGameplaySetting('instakill');
		practiceMode = ClientPrefs.getGameplaySetting('practice');
		cpuControlled = ClientPrefs.getGameplaySetting('botplay');

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camTGame = new FlxCamera();
		camHUD = new FlxCamera();
		if (ClientPrefs.data.concetration == true) {
		camHD = new FlxCamera();
		camNotes = new FlxCamera();
		}
		camOther = new FlxCamera();
		camVIP = new FlxCamera();
		camDIALOGUE = new FlxCamera();
		camTGame.bgColor.alpha = 0;
		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;
		if (ClientPrefs.data.concetration == true) {
		camNotes.bgColor.alpha = 0;
		camHD.bgColor.alpha = 0;
		}
		camVIP.bgColor.alpha = 0;
		camDIALOGUE.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camTGame, false);
		FlxG.cameras.add(camHUD, false);
		if (ClientPrefs.data.concetration == true) {
		FlxG.cameras.add(camHD, false);
		FlxG.cameras.add(camNotes, false);
		}
		FlxG.cameras.add(camOther, false);
		FlxG.cameras.add(camVIP, false);
		FlxG.cameras.add(camDIALOGUE, false);
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		CustomFadeTransition.nextCamera = camOther;

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.bpm = SONG.bpm;

		#if desktop
		storyDifficultyText = Difficulty.getString();

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
			detailsText = "Story Mode: " + WeekData.getCurrentWeek().weekName;
		else
			detailsText = "Freeplay";

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		#end

		GameOverSubstate.resetVariables();
		songName = Paths.formatToSongPath(SONG.song);
		if(SONG.stage == null || SONG.stage.length < 1) {
			SONG.stage = StageData.vanillaSongStage(songName);
		}
		curStage = SONG.stage;

		var stageData:StageFile = StageData.getStageFile(curStage);
		if(stageData == null) { //Stage couldn't be found, create a dummy stage for preventing a crash
			stageData = StageData.dummy();
		}

		defaultCamZoom = stageData.defaultZoom;

		stageUI = "normal";
		if (stageData.stageUI != null && stageData.stageUI.trim().length > 0)
			stageUI = stageData.stageUI;
		else {
			if (stageData.isPixelStage)
				stageUI = "pixel";
		}
		
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];

		if(stageData.camera_speed != null)
			cameraSpeed = stageData.camera_speed;

		boyfriendCameraOffset = stageData.camera_boyfriend;
		if(boyfriendCameraOffset == null) //Fucks sake should have done it since the start :rolling_eyes:
			boyfriendCameraOffset = [0, 0];

		opponentCameraOffset = stageData.camera_opponent;
		if(opponentCameraOffset == null)
			opponentCameraOffset = [0, 0];

		girlfriendCameraOffset = stageData.camera_girlfriend;
		if(girlfriendCameraOffset == null)
			girlfriendCameraOffset = [0, 0];

		boyfriendGroup = new FlxSpriteGroup(stageData.boyfriend[0], stageData.boyfriend[1]);
		boyfriendGroup2 = new FlxSpriteGroup(stageData.boyfriend[0] + 100, stageData.boyfriend[1] + 20);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);

		switch (curStage)
		{
			case 'Dusk': new states.stages.StageDusk(); //Stage Dusk - Week 1 - VS DADDY
			case 'stage': new states.stages.StageWeek1(); //Week 1 - VS DADDY - DeathMatch
			case 'philly': new states.stages.Philly(); //Week 3
			case 'philly2': new states.stages.Philly_Day2(); //Week 3 //Day 2
			case 'philly3': new states.stages.Philly_Day3(); //Week 3 //Day 3
			case 'school': new states.stages.School(); //Week 6 - Senpai, Roses
			case 'limo': new states.stages.Limo(); //Week 4 - Mom
			case 'limo2': new states.stages.Limo1(); //Week 4 - Mom - Memory
			case 'spooky': new states.stages.Spooky(); //Week 3 - Spookys
			case 'philly_dark': new states.stages.Philly_dark(); //SONG SECRET - VS PICO
			case 'evil': new states.stages.EvilStage(); //YOUR BATLE - VS EVIL
			case 'evil2': new states.stages.EvilStageVS(); //YOUR BATLE - VS EVIL
		}

		if(isPixelStage) {
			introSoundsSuffix = '-pixel';
		}

		add(gfGroup);
		add(boyfriendGroup2);
		add(boyfriendGroup);
		add(dadGroup);

		#if (LUA_ALLOWED || HSCRIPT_ALLOWED)
		luaDebugGroup = new FlxTypedGroup<psychlua.DebugLuaText>();
		luaDebugGroup.cameras = [camOther];
		add(luaDebugGroup);
		#end

		trace('STACK TRACE: ' + haxe.CallStack.toString(haxe.CallStack.callStack()));

		// "GLOBAL" SCRIPTS

		// STAGE SCRIPTS

		#if HSCRIPT_ALLOWED
		//startHScriptsNamed('stages/' + curStage + '.hx');
		#end

		if (!stageData.hide_girlfriend)
		{
			if(SONG.gfVersion == null || SONG.gfVersion.length < 1) SONG.gfVersion = 'gf'; //Fix for the Chart Editor
			gf = new Character(0, 0, SONG.gfVersion);
			startCharacterPos(gf);
			gf.scrollFactor.set(0.95, 0.95);
			gfGroup.add(gf);
			startCharacterScripts(gf.curCharacter);
		}

		boyfriend2 = new Character(0, 0, SONG.player4, true);
		startCharacterPos(boyfriend2);
		boyfriendGroup2.add(boyfriend2);
		startCharacterScripts(boyfriend2.curCharacter);

		boyfriend = new Character(0, 0, SONG.player1, true);
		startCharacterPos(boyfriend);
		boyfriendGroup.add(boyfriend);
		startCharacterScripts(boyfriend.curCharacter);

		dad = new Character(0, 0, SONG.player2);
		startCharacterPos(dad, true);
		dadGroup.add(dad);
		startCharacterScripts(dad.curCharacter);

		var camPos:FlxPoint = FlxPoint.get(girlfriendCameraOffset[0], girlfriendCameraOffset[1]);
		if(gf != null)
		{
			camPos.x += gf.getGraphicMidpoint().x + gf.cameraPosition[0];
			camPos.y += gf.getGraphicMidpoint().y + gf.cameraPosition[1];
		}

		if(dad.curCharacter.startsWith('gf')) {
			dad.setPosition(GF_X, GF_Y);
			if(gf != null)
				gf.visible = false;
		}
		stagesFunc(function(stage:BaseStage) stage.createPost());

		if(SONG.mision1) {
			notitext += '\n>Completa la Cancion';
		}

		if(SONG.mision2) {
			notitext += '\n>Presiona las Flechas Especiales';
		}

		if(SONG.mision3) {
			notitext += '\n>Evita tener mas de 5 fallas';
		}

		if(SONG.mision4) {
			notitext += '\n>Ten una clasificacion superior a 50';
		}

		if(SONG.mision5) {
			notitext += '\n>Manten tu vida debajo de 25%';
		}

		couter = new FlxTimer();

		if (!ClientPrefs.data.nonePost) {
		FlxG.sound.play(Paths.sound('notes-sound/loader'), 0);
		FlxG.sound.play(Paths.sound('notes-sound/sonido-de-disparo'), 0);
		}

		curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));

		if (ClientPrefs.data.concetration == true) {
			  if (ClientPrefs.data.language == 'Spanish') {
				mode1 = 'ACTIVADO';
			  } else if (ClientPrefs.data.language == 'Inglish') {
				mode1 = 'ACTIVATED';
			  } else if (ClientPrefs.data.language == 'Portuguese') {
				mode1 = 'ATIVADO';
			  }
			} else if (ClientPrefs.data.concetration == false) {
			  if (ClientPrefs.data.language == 'Spanish') {
				mode1 = 'DESACTIVADO';
			  } else if (ClientPrefs.data.language == 'Inglish') {
				mode1 = 'DISABLED';
			  } else if (ClientPrefs.data.language == 'Portuguese') {
				mode1 = 'DESATIVADO';
			  }
			}

		if (ClientPrefs.data.alphahud == true) {
			  if (ClientPrefs.data.language == 'Spanish') {
				mode2 = 'ACTIVADO';
			  } else  if (ClientPrefs.data.language == 'Inglish') {
				mode2 = 'ACTIVATED';
			  } else if (ClientPrefs.data.language == 'Portuguese') {
				mode2 = 'ATIVADO';
			  }
		} else if (ClientPrefs.data.alphahud == false) { 
			 if (ClientPrefs.data.language == 'Spanish') {
				mode2 = 'DESACTIVADO';
			 } else if (ClientPrefs.data.language == 'Inglish') {
				mode2 = 'DISABLED';
			 } else if (ClientPrefs.data.language == 'Portuguese') {
				mode2 = 'DESATIVADO';
			 }
			}

		blackMode = new FlxSprite().makeGraphic(FlxG.width + 40, FlxG.height + 40, 0x95000000);
		blackMode.antialiasing = ClientPrefs.data.antialiasing;
		blackMode.alpha = 1;
		blackMode.scrollFactor.set();
		blackMode.screenCenter();
		add(blackMode);

		transBlack = new FlxSprite().makeGraphic(FlxG.width + 40, FlxG.height + 40, FlxColor.BLACK);
		transBlack.alpha = 1;
		transBlack.scrollFactor.set();
		transBlack.screenCenter();

		Conductor.songPosition = -5000 / Conductor.songPosition;
		var showTime:Bool = (ClientPrefs.data.timeBarType != 'Disabled');

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		var splash:NoteSplash = new NoteSplash(100, 100);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.000001; //cant make it invisible or it won't allow precaching

		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();

		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);
		FlxTween.tween(camFollow, {x: camPos.x, y: camPos.y}, 0.1, {ease: SONG.animCamera});
		camPos.put();
				
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.snapToTarget();

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);
		moveCameraSection();

		upBar = new FlxSprite(0, -120).makeGraphic(FlxG.width, 120, FlxColor.BLACK);
		add(upBar);

		downBar = new FlxSprite(0, 720).makeGraphic(FlxG.width, 120, FlxColor.BLACK);
		add(downBar);

		if (stageUI != "pixel" && stageUI != "Death" && stageUI != "Evil") {
		healthBar = new HealthBar(-140, 0, 'healthBar', function() return health, 0, 100, 90);
		healthBar.screenCenter(Y);
		healthBar.leftToRight = false;
		healthBar.scrollFactor.set();
		healthBar.visible = !ClientPrefs.data.hideHud;
		healthBar.alpha = 0;
		} else if (stageUI == "pixel") {
		healthBar = new HealthBar(-140, 0, 'healthBarPIXEL', function() return health, 0, 100, 90);
		healthBar.screenCenter(Y);
		healthBar.leftToRight = false;
		healthBar.scrollFactor.set();
		healthBar.visible = !ClientPrefs.data.hideHud;
		healthBar.alpha = 0;
		} else if (stageUI == "Death") {
		healthBar = new HealthBar(-1000, 0, 'healthBar', function() return health, 0, 100, 90);
		healthBar.screenCenter(Y);
		healthBar.leftToRight = false;
		healthBar.scrollFactor.set();
		healthBar.visible = false;
		healthBar.alpha = 0;
		} else if (stageUI == "Evil") {
		healthBar = new HealthBar(-1000, 0, 'healthBarEvil', function() return health, 0, 100, 90);
		healthBar.screenCenter(Y);
		healthBar.leftToRight = false;
		healthBar.scrollFactor.set();
		healthBar.visible = false;
		healthBar.alpha = 0;
		}
		healthBar.setColors();

		if (stageUI != "pixel") {
			healthTxt = new FlxText(5, FlxG.height - 40, 0, "", 32);
			healthTxt.setFormat(Paths.font("new/ALONE.otf"), 32, FlxColor.WHITE, OUTLINE, FlxColor.BLACK);
			healthTxt.antialiasing = ClientPrefs.data.antialiasing;
			healthTxt.scrollFactor.set();
			healthTxt.visible = !ClientPrefs.data.hideHud;
			healthTxt.alpha = 0;
		} else if (stageUI == "pixel") {
			healthTxt = new FlxText(5, FlxG.height - 40, 0, "", 16);
			healthTxt.setFormat("pixel.otf", 16, FlxColor.WHITE, OUTLINE, FlxColor.BLACK);
			healthTxt.antialiasing = ClientPrefs.data.antialiasing;
			healthTxt.scrollFactor.set();
			healthTxt.visible = !ClientPrefs.data.hideHud;
			healthTxt.alpha = 0;
		}

		if (ClientPrefs.data.overlays == true && stageUI != "pixel" && stageUI != "Death" && stageUI != "Evil") {
		healthp = new FlxSprite(-360, 0).loadGraphic(Paths.image('overlay_healthbar'));
		healthp.screenCenter(Y);
		healthp.scrollFactor.set();
		healthp.visible = !ClientPrefs.data.hideHud;
		healthp.alpha = 0;
		healthp.angle = 90;
		}

		if (ClientPrefs.data.overlays == true && stageUI != "pixel" && stageUI != "Death" && stageUI != "Evil") add(healthp);
		add(healthBar);
		add(healthTxt);
		FlxTween.tween(healthTxt, {alpha: ClientPrefs.data.healthBarAlpha}, 1);
		healthBar.alpha = ClientPrefs.data.healthBarAlpha;

		if (ClientPrefs.data.overlays == true && stageUI != "Death" && stageUI != "Evil") {
		overlay = new FlxSprite(0, 0).loadGraphic(Paths.image('Overlays/GR23'));
		overlay.screenCenter();
		overlay.scrollFactor.set();
		overlay.height = FlxG.height;
		overlay.width = FlxG.width;
		overlay.antialiasing = ClientPrefs.data.antialiasing;
		overlay.visible = ClientPrefs.data.overlays;
		overlay.alpha = 0;
		}
		
		if (ClientPrefs.data.overlays == true && stageUI != "Death" && stageUI != "Evil") {
			overlayLoost = new FlxSprite(0, 0).loadGraphic(Paths.image('Overlays/NBG54'));
			overlayLoost.screenCenter();
			overlayLoost.scrollFactor.set();
			overlayLoost.height = FlxG.height;
			overlayLoost.width = FlxG.width;
			overlayLoost.antialiasing = ClientPrefs.data.antialiasing;
			overlayLoost.alpha = 0;
		}

		hptext = new FlxText(healthBar.x, 0, "", 30);
		hptext.setFormat(Paths.font(Paths.font("new/ALONE.otf")), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		hptext.screenCenter(Y);
		hptext.scrollFactor.set();
		hptext.borderSize = 1.25;
		hptext.alpha = 0;
		hptext.angle = 90;
		add(hptext);
		FlxTween.tween(hptext, {alpha: 1}, 8);

		if (stageUI != "pixel" && stageUI != "Death" && stageUI != "Evil") {
		scoreTxt = new FlxText(0, 0, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font(Paths.font("new/BUND.otf")), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.antialiasing = ClientPrefs.data.antialiasing;
		scoreTxt.visible = !ClientPrefs.data.hideHud;
		scoreTxt.alpha = 0;
		add(scoreTxt);
		FlxTween.tween(scoreTxt, {alpha: 1}, 8);
		} else if (stageUI == "pixel") {
			scoreTxt = new FlxText(0, 0, FlxG.width, "", 20);
			scoreTxt.setFormat(Paths.font("pixel.otf"), 12, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			scoreTxt.scrollFactor.set();
			scoreTxt.borderSize = 1.25;
			scoreTxt.antialiasing = ClientPrefs.data.antialiasing;
			scoreTxt.visible = !ClientPrefs.data.hideHud;
			scoreTxt.alpha = 0;
			add(scoreTxt);
			FlxTween.tween(scoreTxt, {alpha: 1}, 8);
		} else {
			scoreTxt = new FlxText(0, 0, FlxG.width, "", 20);
			scoreTxt.setFormat(Paths.font(Paths.font("new/BUND.otf")), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			scoreTxt.scrollFactor.set();
			scoreTxt.borderSize = 1.25;
			scoreTxt.antialiasing = ClientPrefs.data.antialiasing;
			scoreTxt.visible = !ClientPrefs.data.hideHud;
			scoreTxt.alpha = 0;
			add(scoreTxt);
			FlxTween.tween(scoreTxt, {alpha: 1}, 8);
		}

		if (stageUI != "pixel") {
			timeTxt = new FlxText(FlxG.width - 5, scoreTxt.y - 12, "", 32);
			timeTxt.setFormat(Paths.font(Paths.font("new/BUND.otf")), 32, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
			timeTxt.scrollFactor.set();
			timeTxt.alpha = 0;
			timeTxt.visible = updateTime = showTime;
			timeTxt.screenCenter(X);
			timeTxt.antialiasing = ClientPrefs.data.antialiasing;
			if(ClientPrefs.data.downScroll) timeTxt.y += 10;
			if(ClientPrefs.data.timeBarType == 'Song Name') timeTxt.text = SONG.song.toUpperCase().replace('-', ' ') + ' | ' + difficultysong;
		} else if (stageUI == "pixel") {
			timeTxt = new FlxText(FlxG.width, scoreTxt.y - 15, 0, "", 12);
			timeTxt.setFormat(Paths.font("vcx.ttf"), 12, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
			timeTxt.scrollFactor.set();
			timeTxt.alpha = 0;
			timeTxt.visible = updateTime = showTime;
			timeTxt.screenCenter(X);
			timeTxt.antialiasing = ClientPrefs.data.antialiasing;
			if(ClientPrefs.data.downScroll) timeTxt.y += 10;
			if(ClientPrefs.data.timeBarType == 'Song Name') timeTxt.text = SONG.song.toUpperCase().replace('-', ' ') + ' | ' + difficultysong;
		}

		timeTxt.x += 300;
		add(timeTxt);

		if(ClientPrefs.data.timeBarType == 'Song Name')
			{
				timeTxt.size = 24;
				timeTxt.y += 10;
			}

			
		if (chartingMode == true) {
		var maskEditor = new FlxText(0, FlxG.height - 64, 0, "Mod by TGames".toUpperCase(), 12);
		maskEditor.setFormat(Paths.font("new/BUND.otf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		maskEditor.visible = chartingMode;
		maskEditor.scrollFactor.set();
		maskEditor.screenCenter(X);
		maskEditor.camera = camVIP;
		maskEditor.antialiasing = ClientPrefs.data.antialiasing;
		add(maskEditor);
		var maskEditorV = new FlxText(100, FlxG.height - 44, 0, 'ENDING CORRUPTION V' + ClientPrefs.data.tempName[1] + "(" + ClientPrefs.data.tempName[0] + ") | PATH V" + ClientPrefs.data.pathVersion, 12);
		maskEditorV.setFormat(Paths.font("new/BUND.otf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		maskEditorV.visible = chartingMode;
		maskEditorV.scrollFactor.set();
		maskEditorV.screenCenter(X);
		maskEditorV.camera = camVIP;
		maskEditorV.antialiasing = ClientPrefs.data.antialiasing;
		add(maskEditorV);
		}

		if (stageUI != "Death" && stageUI != "pixel") {
		tipControls = new FlxText(-400, 0, 0,
			 "MODO CONCENTRACION: \n\n[" + mode1 + "]" + 
			 "\n\nEFECTO HUD: \n\n[" + mode2 + "]",
			 24);
		tipControls.setFormat("new/BUND.otf", 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		tipControls.alpha = 0;
		tipControls.screenCenter(Y);
		tipControls.scrollFactor.set();
		tipControls.antialiasing = ClientPrefs.data.antialiasing;
		tipControls.camera = camOther;
		if (stageUI == "Evil") tipControls.visible = false;
		add(tipControls);
		} else if (stageUI == "pixel") {
			tipControls = new FlxText(-400, 0, 0,
				"MODO CONCENTRACION: \n\n[" + mode1 + "]" + 
				"\n\nEFECTO HUD: \n\n[" + mode2 + "]",
				24);
		   tipControls.setFormat("pixel.otf", 18, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		   tipControls.alpha = 0;
		   tipControls.screenCenter(Y);
		   tipControls.scrollFactor.set();
		   tipControls.antialiasing = ClientPrefs.data.antialiasing;
		   tipControls.camera = camOther;
		   add(tipControls);
		}

		if (chartingMode == true) {
			//add(new Notification(camOther, "Charting Mode:", "Status = [" + chartingMode + "]", 1));
			add(new Notification('Status:'.toUpperCase(), "El Status Actual es 'Charting Mode' se esta leyendo el archivo nuevo. se activaron las marcas de desarrollo. Se eliminarion varias optimizaciones de la cancion '".toUpperCase() + SONG.song.toUpperCase() + "'", 1, camOther, 1));
		}

		signal = new FlxSprite(0, 0).loadGraphic(Paths.image('alert-fire'));
		signal.screenCenter();
		signal.antialiasing = ClientPrefs.data.antialiasing;
		signal.visible = false;
		signal.alpha = 0;

		add(signal);

		tipPress = new FlxText(0, 600, FlxG.width, "Presiona 'SPACE' para Disparar".toUpperCase(), 22);
		tipPress.setFormat("new/BUND.otf", 22, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		tipPress.antialiasing = ClientPrefs.data.antialiasing;
		tipPress.screenCenter(X);
		tipPress.visible = false;
		add(tipPress);
		FlxTween.tween(tipPress, {alpha: 0}, 1, {
			type: PINGPONG
		});

		if (ClientPrefs.data.overlays == true && stageUI != "Death") add(overlay);
		if  (ClientPrefs.data.overlays == true && stageUI != "Death") add(overlayLoost);

		if (cpuControlled == true) {
			add(new Notification('Start Status:'.toUpperCase(), "eL Juego Inicio con BotPlay Activado\n\nJugando Actualmente:\n[".toUpperCase() + SONG.song.toUpperCase() + "]|[" + difficultysong + "]", 1, camOther, 1));
		}

		add(transBlack);

	if (ClientPrefs.data.concetration == true) {
		upBar.cameras = [camTGame];
		downBar.cameras = [camTGame];
		scoreTxt.cameras = [camHUD];
		healthBar.cameras = [camOther];
		healthTxt.cameras = [camOther];
		if (ClientPrefs.data.overlays == true && stageUI != "pixel" && stageUI != "Death" && stageUI != "Evil") healthp.cameras = [camOther];

		blackMode.cameras = [camHD];
		notes.cameras = [camNotes];
		strumLineNotes.cameras = [camNotes];
		grpNoteSplashes.cameras = [camNotes];

		timeTxt.cameras = [camVIP];

		tipPress.cameras = [camVIP];

		hptext.cameras = [camOther];

		signal.cameras = [camOther];

		if (ClientPrefs.data.overlays == true && stageUI != "Death" && stageUI != "Evil") overlay.cameras = [camOther];
		if (ClientPrefs.data.overlays == true && stageUI != "Death" && stageUI != "Evil") overlayLoost.cameras = [camOther];

		transBlack.cameras = [camOther];
	} else {

		upBar.cameras = [camTGame];
		downBar.cameras = [camTGame];

		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];

		blackMode.cameras = [camHD];
		scoreTxt.cameras = [camHUD];
		healthBar.cameras = [camOther];
		healthTxt.cameras = [camOther];
		if (ClientPrefs.data.overlays == true && stageUI != "pixel" && stageUI != "Death" && stageUI != "Evil") healthp.cameras = [camOther];

		timeTxt.cameras = [camVIP];

		tipPress.cameras = [camVIP];

		hptext.cameras = [camOther];

		signal.cameras = [camOther];

		blackMode.alpha = 0;

		if (ClientPrefs.data.overlays == true && stageUI != "Death" && stageUI != "Evil") overlay.cameras = [camOther];
		if (ClientPrefs.data.overlays == true && stageUI != "Death" && stageUI != "Evil") overlayLoost.cameras = [camOther];
		transBlack.cameras = [camOther];
	}

		startingSong = true;
		
		noteTypes = null;
		eventsPushed = null;

		if(eventNotes.length > 1)
		{
			for (event in eventNotes) event.strumTime -= eventEarlyTrigger(event);
			eventNotes.sort(sortByTime);
		}

		// SONG SPECIFIC SCRIPTS

		startCallback();
		RecalculateRating();

		//PRECACHING MISS SOUNDS BECAUSE I THINK THEY CAN LAG PEOPLE AND FUCK THEM UP IDK HOW HAXE WORKS
		if(ClientPrefs.data.hitsoundVolume > 0) precacheList.set('hitsound', 'sound');

		if (PauseModeSubState.songName != null) {
			precacheList.set(PauseModeSubState.songName, 'music');
		} else if(ClientPrefs.data.pauseMusic != 'None') {
			precacheList.set(Paths.formatToSongPath(ClientPrefs.data.pauseMusic), 'music');
		}

		precacheList.set('alphabet', 'image');
		precacheList.set('sick', 'image');
		precacheList.set('shit', 'image');
		precacheList.set('good', 'image');
		precacheList.set('combo', 'image');
		precacheList.set('bad', 'image');
		precacheList.set('num0', 'image');
		precacheList.set('num1', 'image');
		precacheList.set('num2', 'image');
		precacheList.set('num3', 'image');
		precacheList.set('num4', 'image');
		precacheList.set('num5', 'image');
		precacheList.set('num6', 'image');
		precacheList.set('num7', 'image');
		precacheList.set('num8', 'image');
		precacheList.set('num9', 'image');
		resetRPC();

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);

		callOnScripts('onCreatePost');

		cacheCountdown();
		cachePopUpScore();
		
		for (key => type in precacheList)
		{
			//trace('Key $key is type $type');
			switch(type)
			{
				case 'image':
					Paths.image(key);
				case 'music':
					Paths.music(key);
			}
		}

		MusicBeatState.updatestate(SONG.song.toUpperCase() + " - " + difficultysong);
		//if (stageUI == "pixel") filterTV = new Filters();

		super.create();
		Paths.clearUnusedMemory();
		
		CustomFadeTransition.nextCamera = camOther;
		if(eventNotes.length < 1) checkEventNote();

		FadeTime = new FlxTimer();
	}

	function set_songSpeed(value:Float):Float
	{
		if(generatedMusic)
		{
			var ratio:Float = value / songSpeed; //funny word huh
			if(ratio != 1)
			{
				for (note in notes.members) note.resizeByRatio(ratio);
				for (note in unspawnNotes) note.resizeByRatio(ratio);
			}
		}
		songSpeed = value;
		noteKillOffset = Math.max(Conductor.stepCrochet, 350 / songSpeed * playbackRate);
		return value;
	}

	function set_playbackRate(value:Float):Float
	{
		if(generatedMusic)
		{
			if(vocals != null) vocals.pitch = value;
			FlxG.sound.music.pitch = value;

			var ratio:Float = playbackRate / value; //funny word huh
			if(ratio != 1)
			{
				for (note in notes.members) note.resizeByRatio(ratio);
				for (note in unspawnNotes) note.resizeByRatio(ratio);
			}
		}
		playbackRate = value;
		FlxAnimationController.globalSpeed = value;
		Conductor.safeZoneOffset = (ClientPrefs.data.safeFrames / 60) * 1000 * value;
		setOnScripts('playbackRate', playbackRate);
		return value;
	}

	public function reloadHealthBarColors() {
		healthBar.setColors(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
	}

	public function addCharacterToList(newCharacter:String, type:Int) {
		switch(type) {
			case 0:
				if(!boyfriendMap.exists(newCharacter)) {
					var newBoyfriend:Character = new Character(0, 0, newCharacter, true);
					boyfriendMap.set(newCharacter, newBoyfriend);
					boyfriendGroup.add(newBoyfriend);
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
					startCharacterScripts(newBoyfriend.curCharacter);
				}

			case 1:
				if(!dadMap.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					dadMap.set(newCharacter, newDad);
					dadGroup.add(newDad);
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					startCharacterScripts(newDad.curCharacter);
				}

			case 2:
				if(gf != null && !gfMap.exists(newCharacter)) {
					var newGf:Character = new Character(0, 0, newCharacter);
					newGf.scrollFactor.set(0.95, 0.95);
					gfMap.set(newCharacter, newGf);
					gfGroup.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
					startCharacterScripts(newGf.curCharacter);
				}
		}
	}

	function startCharacterScripts(name:String)
	{
		// Lua

		// HScript
		#if HSCRIPT_ALLOWED
		var doPush:Bool = false;
		var scriptFile:String = 'characters/' + name + '.hx';
		#if MODS_ALLOWED var replacePath:String = Paths.modFolders(scriptFile); 
		if(FileSystem.exists(replacePath))
		{
			scriptFile = replacePath;
			doPush = true;
		}
		else
		{
			scriptFile = Paths.getPreloadPath(scriptFile);
			if(FileSystem.exists(scriptFile))
				doPush = true;
		}
		
		if(doPush)
		{
			#if !android
			if(SScript.global.exists(scriptFile))
				doPush = false;
			#end

			//if(doPush) initHScript(scriptFile);
		}
			#end
		#end
	}

	function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
		if(gfCheck && char.curCharacter.startsWith('gf')) { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
			char.danceEveryNumBeats = 2;
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}

	public function startVideo(name:String)
	{
		#if VIDEOS_ALLOWED
		inCutscene = true;

		var filepath:String = Paths.video(name);
		#if sys
		if(!FileSystem.exists(filepath))
		#else
		if(!OpenFlAssets.exists(filepath))
		#end
		{
			FlxG.log.warn('Couldnt find video file: ' + name);
			startAndEnd();
			return;
		}

		var video:VideoHandler = new VideoHandler();
			#if (hxCodec >= "3.0.0")
			// Recent versions
			video.play(filepath);
			video.onEndReached.add(function()
			{
				video.dispose();
				startAndEnd();
				return;
			}, true);
			#else
			// Older versions
			video.playVideo(filepath);
			video.finishCallback = function()
			{
				startAndEnd();
				return;
			}
			#end
		#else
		FlxG.log.warn('Platform not supported!');
		startAndEnd();
		return;
		#end
	}

	function startAndEnd()
	{
		if(endingSong)
			endSong();
		else
			startCountdown();
	}

	// Variable para almacenar los diálogos de la canción actual
	public var songDialogues:Map<String, Array<String>> = new Map<String, Array<String>>();
	function initSongDialogues() {
    // Ejemplo de cómo definir diálogos para diferentes canciones
    songDialogues.set('return', [
        'Bienvenido al tutorial!',
        'Presiona las flechas cuando lleguen a su posición.',
        '¡Buena suerte!'
    ]);
    
    songDialogues.set('bopeebo', [
        'Hey, ¿estás listo para rapear?',
        'Vamos a ver qué tienes...',
        '¡Comencemos!'
    ]);
    
    // Añade más diálogos para otras canciones aquí
	}

	// Función para modificar el startCountdown y mostrar diálogos
	public function startCountdownAfterDialogue():Void
	{
		trace('FINALIZASTE CON TODOS LOS DIALOGOS. REGRESANDO...');
    	//dialogueMode = false;
		seenCutscene = true;
    	startCountdown();
	}

	/*var dialogueCount:Int = 0;
	public var psychDialogue:DialogueBoxPsych;
	//You don't have to add a song, just saying. You can just do "startDialogue(DialogueBoxPsych.parseDialogue(Paths.json(songName + '/dialogue')))" and it should load dialogue.json
	public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
	{
		// TO DO: Make this more flexible, maybe?
		if(psychDialogue != null) return;

		if(dialogueFile.dialogue.length > 0) {
			inCutscene = true;
			precacheList.set('dialogue', 'sound');
			precacheList.set('dialogueClose', 'sound');
			psychDialogue = new DialogueBoxPsych(dialogueFile, song);
			psychDialogue.scrollFactor.set();
			if(endingSong) {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					dialogueMode = true;
					endSong();
				}
			} else {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					dialogueMode = true;
					startCountdown();
				}
			}
			psychDialogue.nextDialogueThing = startNextDialogue;
			psychDialogue.skipDialogueThing = skipDialogue;
			//psychDialogue.cameras = [camHUD];
			psychDialogue.cameras = [camDIALOGUE];
			add(psychDialogue);
		} else {
			FlxG.log.warn('Your dialogue file is badly formatted!');
			dialogueMode = true;
			startAndEnd();
		}
	}*/

	var startTimer:FlxTimer;
	var finishTimer:FlxTimer = null;

	// For being able to mess with the sprites on Lua
	public var countdownReady:FlxSprite;
	public var countdownSet:FlxSprite;
	public var countdownGo:FlxSprite;
	public static var startOnTime:Float = 0;

	function cacheCountdown()
	{
		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		var introImagesArray:Array<String> = switch(stageUI) {
			case "pixel": ['${stageUI}UI/ready-pixel', '${stageUI}UI/set-pixel', '${stageUI}UI/date-pixel'];
			case "normal": ["Ready_EC_Inglish", "Set_EC_Inglish" ,"Go_EC_Inglish"];
			case "Death": ["transparent", "transparent", "transparent"];
			case "Evil": ["transparent", "transparent", "transparent"];
			default: ['${stageUI}UI/ready', '${stageUI}UI/set', '${stageUI}UI/go'];
		}
		introAssets.set(stageUI, introImagesArray);
		var introAlts:Array<String> = introAssets.get(stageUI);
		for (asset in introAlts) Paths.image(asset);
		
		Paths.sound('intro3' + introSoundsSuffix);
		Paths.sound('intro2' + introSoundsSuffix);
		Paths.sound('intro1' + introSoundsSuffix);
		Paths.sound('introGo' + introSoundsSuffix);
	}

	public function startCountdown()
	{
		if (!isStoryMode) {
			seenCutscene = true;
			trace('NO ESTAS EN STORYMODE');
		}

		if (seenCutscene) {
		trace('FINALIZASTE TODO CONTINUANDO CON EL JUEGO...');
		inCutscene = false;
		var ret:Dynamic = callOnScripts('onStartCountdown', null, true);
		if(ret != FunkinLua.Function_Stop) {
			if (skipCountdown || startOnTime > 0) skipArrowStartTween = true;

			generateStaticArrows(0);
			generateStaticArrows(1);
			for (i in 0...playerStrums.length) {
				setOnScripts('defaultPlayerStrumX' + i, playerStrums.members[i].x);
				setOnScripts('defaultPlayerStrumY' + i, playerStrums.members[i].y);
			}
			for (i in 0...opponentStrums.length) {
				setOnScripts('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
				setOnScripts('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
				//if(ClientPrefs.data.middleScroll) opponentStrums.members[i].visible = false;
			}

			startedCountdown = true;

			Conductor.songPosition = -Conductor.crochet * 5;
			setOnScripts('startedCountdown', true);
			callOnScripts('onCountdownStarted', null);

			var swagCounter:Int = 0;
			if (startOnTime > 0) {
				clearNotesBefore(startOnTime);
				setSongTime(startOnTime - 350);
				//return true;
			}
			else if (skipCountdown)
			{
				setSongTime(0);
				//return true;
			}
			moveCameraSection();

			startTimer = new FlxTimer().start(Conductor.crochet / 1000 / playbackRate, function(tmr:FlxTimer)
			{
				if (gf != null && tmr.loopsLeft % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
					gf.dance();
				if (tmr.loopsLeft % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
					boyfriend.dance();
				if (tmr.loopsLeft % boyfriend2.danceEveryNumBeats == 0 && boyfriend2.animation.curAnim != null && !boyfriend2.animation.curAnim.name.startsWith('sing') && !boyfriend2.stunned)
					boyfriend2.dance();
				if (tmr.loopsLeft % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
					dad.dance();

				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				var introImagesArray:Array<String> = switch(stageUI) {
					case "pixel": ['${stageUI}UI/ready-pixel', '${stageUI}UI/set-pixel', '${stageUI}UI/date-pixel'];
					case "normal": ["Ready_EC_Inglish", "Set_EC_Inglish" ,"Go_EC_Inglish"];
					case "Death": ["transparent", "transparent", "transparent"];
					case "Evil": ["transparent", "transparent", "transparent"];
					default: ['${stageUI}UI/ready', '${stageUI}UI/set', '${stageUI}UI/go'];
				}
				introAssets.set(stageUI, introImagesArray);

				var introAlts:Array<String> = introAssets.get(stageUI);
				var antialias:Bool = (ClientPrefs.data.antialiasing && !isPixelStage);
				var tick:Countdown = THREE;

				if (stageUI != "Death") {
				switch (swagCounter)
				{
					case 0:
						FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
						tick = THREE;
					case 1:
						countdownReady = createCountdownSprite(introAlts[0], antialias);
						FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
						tick = TWO;
					case 2:
						countdownSet = createCountdownSprite(introAlts[1], antialias);
						FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
						tick = ONE;
					case 3:
						countdownGo = createCountdownSprite(introAlts[2], antialias);
						FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
						tick = GO;
					case 4:
						tick = START;
						closeSubState();
				}
			} else {
				switch (swagCounter)
				{
					case 0:
						FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0);
						tick = THREE;
					case 1:
						countdownReady = createCountdownSprite(introAlts[0], antialias);
						FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0);
						tick = TWO;
					case 2:
						countdownSet = createCountdownSprite(introAlts[1], antialias);
						FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0);
						tick = ONE;
					case 3:
						countdownGo = createCountdownSprite(introAlts[2], antialias);
						FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0);
						tick = GO;
					case 4:
						tick = START;
						closeSubState();
						trace('TERMINAMOS EL CONTEO CONTINUEMOS CON EL JUEGO');
				}
			}

				notes.forEachAlive(function(note:Note) {
					if(ClientPrefs.data.opponentStrums || note.mustPress)
					{
						note.copyAlpha = false;
						note.alpha = note.multAlpha;
						if(ClientPrefs.data.middleScroll && !note.mustPress)
							note.alpha *= 0.35;
					}
				});

				stagesFunc(function(stage:BaseStage) stage.countdownTick(tick, swagCounter));
				callOnLuas('onCountdownTick', [swagCounter]);
				callOnHScript('onCountdownTick', [tick, swagCounter]);

				swagCounter += 1;
			}, 5);

			NNN = true;
		}
	} else {
		// Verificar si hay diálogos para esta canción
        if (songDialogues.exists(SONG.song.toLowerCase()))
        {
            var dialogueBox:DialogueBox = new DialogueBox(songDialogues.get(SONG.song.toLowerCase()), startCountdownAfterDialogue);
            dialogueBox.cameras = [camDIALOGUE];
            add(dialogueBox);
			trace('ENCONTRAMOS EL DIALOGO EJECUTANDO...');
        } else {
			seenCutscene = true;
			startCountdown();
			trace('NO ENCONTRAMOS EL DIALOGO CONTINUANDO CON EL JUEGO...');
		}
	}

	}

	inline private function createCountdownSprite(image:String, antialias:Bool):FlxSprite
	{
		var spr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(image));
		spr.cameras = [camVIP];
		spr.scrollFactor.set();
		spr.updateHitbox();

		if (PlayState.isPixelStage)
			spr.setGraphicSize(Std.int(spr.width * daPixelZoom));

		spr.screenCenter();
		spr.antialiasing = antialias;
		insert(members.indexOf(notes), spr);
		FlxTween.tween(spr, {alpha: 0}, Conductor.crochet / 1000, {
			ease: FlxEase.cubeInOut,
			onComplete: function(twn:FlxTween)
			{
				remove(spr);
				spr.destroy();
			}
		});
		return spr;
	}

	public function addBehindGF(obj:FlxBasic)
	{
		insert(members.indexOf(gfGroup), obj);
	}
	public function addBehindBF(obj:FlxBasic)
	{
		insert(members.indexOf(boyfriendGroup), obj);
	}
	public function addBehindDad(obj:FlxBasic)
	{
		insert(members.indexOf(dadGroup), obj);
	}

	public function clearNotesBefore(time:Float)
	{
		var i:Int = unspawnNotes.length - 1;
		while (i >= 0) {
			var daNote:Note = unspawnNotes[i];
			if(daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				unspawnNotes.remove(daNote);
				daNote.destroy();
			}
			--i;
		}

		i = notes.length - 1;
		while (i >= 0) {
			var daNote:Note = notes.members[i];
			if(daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				notes.remove(daNote, true);
				daNote.destroy();
			}
			--i;
		}
	}

	private function convText(text:String) {

		//Dividir el texto en palabras
		var palabras:Array<String> = text.split(" ");

		//Convertir cada palabra a mayúsculas
		for (i in 0...palabras.length) {
			palabras[i] = palabras[i].toUpperCase();
		}

		//Unir las palabras de nuevo en un solo texto
		var textEnMayusculas:String = palabras.join(" ");

		return textEnMayusculas;
	}

	public function updateScore(miss:Bool = false)
	{
		#if desktop
		if (stageUI == "Death") {
			DiscordClient.changePresence("SONG - " +  SONG.song.toUpperCase() + "(" + difficultysong + ")", "Misses: " + songMisses);
		} else {
			DiscordClient.changePresence("SONG - " +  SONG.song.toUpperCase() + "(" + difficultysong + ")", "Health: " + healthBar.percent + "%");
		}
		#end

		if (INGLISH && stageUI != "Death" && stageUI != "Evil") {
			healthTxt.text = "HEALTH: " + healthBar.percent + "%";
		} else if (SPANISH && stageUI != "Death" && stageUI != "Evil"|| PORTUGUESE && stageUI != "Death" && stageUI != "Evil") {
			healthTxt.text = "VIDA: " + healthBar.percent + "%";
		} else if (INGLISH && stageUI == "Death" && stageUI != "Evil") {
			healthTxt.text = "MISSES: " + songMisses + " (MAX: 20)";
			healthTxt.font = Paths.font("new/BUND.otf");
			if (songMisses > 12) {
				healthTxt.color = FlxColor.RED;
				} else if (songMisses >= 0) {
				healthTxt.color = FlxColor.WHITE;
			} else if (songMisses <= -1) {
				healthTxt.color = FlxColor.GREEN;
			}
			healthTxt.screenCenter(X);
			healthTxt.y = 5;
			healthTxt.size = 22;
		} else if (SPANISH && stageUI == "Death" && stageUI != "Evil" || PORTUGUESE && stageUI == "Death" && stageUI != "Evil") {
			healthTxt.text = "FALLAS: " + songMisses + " (MAXIMAS: 20)";
			healthTxt.font = Paths.font("new/BUND.otf");
			if (songMisses > 12) {
				healthTxt.color = FlxColor.RED;
				} else if (songMisses >= 0) {
				healthTxt.color = FlxColor.WHITE;
			} else if (songMisses <= -1) {
				healthTxt.color = FlxColor.GREEN;
			}
			healthTxt.screenCenter(X);
			healthTxt.y = 5;
			healthTxt.size = 22;
		} else {
			if (INGLISH) {
			healthTxt.text = "SANITY: " + CoolUtil.floorDecimal(healthBar.percent, 2) + "%";
			} else if (SPANISH) {
				healthTxt.text = "CORDURA: " + CoolUtil.floorDecimal(healthBar.percent, 2) + "%";
			} else if (PORTUGUESE) {
				healthTxt.text = "SANIDADE: " + CoolUtil.floorDecimal(healthBar.percent, 2) + "%";
			}
		}

		timeTxt.x = FlxG.width - timeTxt.width;
		var str:String = ratingName;

		if (stageUI != "Evil") {
		if (SPANISH) {
			TxtScore = '[PUNTAJE: ' + songScore + '] - [FALLAS: ' + songMisses + ']\n[CLASIFICACION: ' + str + '] - [VELOCIDAD: x' + songSpeed + ']';
		} else if (INGLISH) {
				TxtScore = '[SCORE: ' + songScore
				+ '] - [MISSES: ' + songMisses
				+ ']\n[RATING: ' + str
				+ '] - [VELOCITY: x' + songSpeed + ']';
			} else if (PORTUGUESE) {
				TxtScore = '[Pontuação: '.toUpperCase() + songScore
				+ '] - [SENTE FALTA: ' + songMisses
				+ ']\n[Avaliação: '.toUpperCase() + str
				+ '] - [VELOCIDADE: x' + songSpeed + ']';
			}
		} else {
			if (SPANISH) {
				TxtScore = '[Clasificacion: ' + str + ']';
			} else if (INGLISH) {
					TxtScore = '[Rating: ' + str + ']';
				} else if (PORTUGUESE) {
					TxtScore = '[Avaliação: ' + str + ']';
				} else {
					TxtScore = '--Language not found--';
				}
		}

			scoreTxt.text = convText(TxtScore);

			if (stageUI == "Evil") scoreTxt.font = Paths.font("new/BUND.otf");

			if (songMisses >= 30 && stageUI != 'Evil') {
				healthTxt.color = FlxColor.RED;
			}
		callOnScripts('onUpdateScore', [miss]);
	}

	public function setSongTime(time:Float)
	{
		if(time < 0) time = 0;

		FlxG.sound.music.pause();
		vocals.pause();

		FlxG.sound.music.time = time;
		FlxG.sound.music.pitch = playbackRate;
		FlxG.sound.music.play();

		if (Conductor.songPosition <= vocals.length)
		{
			vocals.time = time;
			vocals.pitch = playbackRate;
		}
		vocals.play();
		Conductor.songPosition = time;
	}

	/*public function startNextDialogue() {
		dialogueCount++;
		callOnScripts('onNextDialogue', [dialogueCount]);
	}

	public function skipDialogue() {
		callOnScripts('onSkipDialogue', [dialogueCount]);
	}*/

	function movementEvil() {
		if (SONG.levitationEnemy) {
		FlxTween.tween(dadGroup.members[0], {y: dadGroup.members[0].y + 85}, 1.8, {
			ease: FlxEase.linear, 
			type: FlxTween.PINGPONG
		});
	}

		if (stageUI == "Evil") {
			FlxTween.tween(boyfriendGroup2.members[0], {y: boyfriendGroup2.members[0].y + 85}, 1.8, {
				ease: FlxEase.linear, 
				type: FlxTween.PINGPONG
			});
			FlxTween.tween(boyfriendGroup2.members[0], {alpha: boyfriend2.alpha - 0.3}, 1.8, {
				ease: FlxEase.linear, 
				type: FlxTween.PINGPONG
			});
		}
	}

	function startSong():Void
	{

		if (stageUI == "Evil") {
			movementEvil();
		}
					//Notes
					for (i in 0...3) {
					strumPlayAnim(false, Std.int(Math.abs(i)), Conductor.stepCrochet * 1.25 / 1000 / playbackRate, false);
					strumPlayAnim(true, Std.int(Math.abs(i)), Conductor.stepCrochet * 1.25 / 1000 / playbackRate, false);
					}

		statusGame = true;

		if (cpuControlled == false) {
			if (chartingMode == false && stageUI != "Death") {
				add(new Notification('Jugando ACTUALMENTE', "Estas Jugando actualmente\n> " + songName + " | [" + Difficulty.getString().toUpperCase() + "]", 2, camVIP, 1.5));
			}	
	}

		FlxTween.tween(transBlack, {alpha: 0}, 1, {ease: FlxEase.circInOut});

		FlxTween.tween(timeTxt, {x: FlxG.width}, 2);

		startingSong = false;

		@:privateAccess
		FlxG.sound.playMusic(inst._sound, 1, false);
		FlxG.sound.music.pitch = playbackRate;
		FlxG.sound.music.onComplete = finishSong.bind();
		vocals.play();

		if (!ClientPrefs.data.noneAnimations && stageUI != "Death") {
		FlxTween.tween(tipControls, {x: 20, alpha: 1}, 2, {
			ease: FlxEase.circIn,
			onComplete: function (twn:FlxTween) {
				FlxTween.tween(tipControls, {x: 100, alpha: 0}, 6, {
					ease: FlxEase.circOut,
					onComplete: function (twn:FlxTween) {
						tipControls.destroy();
					}
				});
			}
		});
	}else if (ClientPrefs.data.noneAnimations && stageUI != "Death") {
		tipControls.x = 100;
		tipControls.alpha = 1;

		new FlxTimer().start(6, function(Timer:FlxTimer) {
			tipControls.alpha = 0;
			tipControls.destroy();
		}, 1);
	}

		if(startOnTime > 0) setSongTime(startOnTime - 500);
		startOnTime = 0;

		if(paused) {
			//trace('Oopsie doopsie! Paused sound');
			FlxG.sound.music.pause();
			vocals.pause();
		}

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;

		if (!ClientPrefs.data.noneAnimations) {
		FlxTween.tween(timeTxt, {alpha: 1}, 6, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween) {
			if (cpuControlled == false) {
				if (chartingMode == false && notitext != '') {
			add(new Notification('Misiones', notitext, 2, camVIP, 1.5));
				}	
		}
		}});
	} else if (ClientPrefs.data.noneAnimations) {
		timeTxt.alpha = 1;
		
		new FlxTimer().start(6, function(Timer:FlxTimer) if (cpuControlled == false) {
			if (chartingMode == false && notitext != '') {
				add(new Notification('Misiones', notitext, 2, camVIP, 2));
		}	
	}, 1);
	}

		setOnScripts('songLength', songLength);
		callOnScripts('onSongStart');
		    // PRECARGAR SOLO SI NO SE HA HECHO ANTES
	}

	var debugNum:Int = 0;
	private var noteTypes:Array<String> = [];
	private var eventsPushed:Array<String> = [];
private function generateSong(dataPath:String):Void { 

	if (!Note.assetsPreloaded) {
        trace('PRECARGANDO ASSETS DURANTE GENERATESONG...');
        //Note.preloadCommonAssets();
    }
	// FlxG.log.add(ChartParser.parse()); 
	songSpeed = PlayState.SONG.speed; 
	songSpeedType = ClientPrefs.getGameplaySetting('scrolltype'); 
	switch(songSpeedType) { 
		case "multiplicative": songSpeed = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed'); 
		case "constant": songSpeed = ClientPrefs.getGameplaySetting('scrollspeed'); 
	}

	var songData = SONG;
	Conductor.bpm = songData.bpm;

	curSong = songData.song;

	vocals = new FlxSound();
	#if desktop
	if (songData.needsVoices) vocals.loadEmbedded(Paths.voices(songData.song));
	#else
	if (songData.needsVoices) vocals.loadStream(OnlineUtil.pathSoundOnline(Paths.formatToSongPath(songData.song) + '/Voices'));
	#end

	vocals.pitch = playbackRate;
	FlxG.sound.list.add(vocals);

	#if desktop
	inst = new FlxSound().loadEmbedded(Paths.inst(songData.song));
	#else
	inst = new FlxSound().loadStream(OnlineUtil.pathSoundOnline(Paths.formatToSongPath(songData.song) + '/Inst'));
	#end

	FlxG.sound.list.add(inst);

	notes = new FlxTypedGroup<Note>();
	add(notes);

	var noteData:Array<SwagSection>;

	// NEW SHIT
	noteData = songData.notes;

	var file:String = Paths.json(songName + '/events');
	#if MODS_ALLOWED
	if (FileSystem.exists(Paths.modsJson(songName + '/events')) || FileSystem.exists(file)) {

	}
	#else
	if (OpenFlAssets.exists(file)) {
		var eventsData:Array<Dynamic> = Song.loadFromJson('events', songName).events;
		for (event in eventsData) //Event Notes
			for (i in 0...event[1].length)
				makeEvent(event, i);
	}
	#end

	for (section in noteData)
	{
		for (songNotes in section.sectionNotes)
		{
			var daStrumTime:Float = songNotes[0];
			var daNoteData:Int = Std.int(songNotes[1] % 4);
			var gottaHitNote:Bool = section.mustHitSection;

			if (songNotes[1] > 3)
			{
				gottaHitNote = !section.mustHitSection;
			}

			var oldNote:Note;
			if (unspawnNotes.length > 0)
				oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
			else
				oldNote = null;

			var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
			swagNote.mustPress = gottaHitNote;
			swagNote.sustainLength = songNotes[2];
			swagNote.gfNote = (section.gfSection && (songNotes[1]<4));
			swagNote.noteType = songNotes[3];
			if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts

			swagNote.scrollFactor.set();

			var susLength:Float = swagNote.sustainLength;

			susLength = susLength / Conductor.stepCrochet;
			unspawnNotes.push(swagNote);

			var floorSus:Int = Math.floor(susLength);
			if(floorSus > 0) {
				for (susNote in 0...floorSus+1)
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote), daNoteData, oldNote, true);
					sustainNote.mustPress = gottaHitNote;
					sustainNote.gfNote = (section.gfSection && (songNotes[1]<4));
					sustainNote.noteType = swagNote.noteType;
					sustainNote.scrollFactor.set();
					swagNote.tail.push(sustainNote);
					sustainNote.parent = swagNote;
					unspawnNotes.push(sustainNote);
					
					sustainNote.correctionOffset = swagNote.height / 2;
					if(!PlayState.isPixelStage)
					{
						if(oldNote.isSustainNote)
						{
							oldNote.scale.y *= Note.SUSTAIN_SIZE / oldNote.frameHeight;
							oldNote.scale.y /= playbackRate;
							oldNote.updateHitbox();
						}

						if(ClientPrefs.data.downScroll)
							sustainNote.correctionOffset = 0;
					}
					else if(oldNote.isSustainNote)
					{
						oldNote.scale.y /= playbackRate;
						oldNote.updateHitbox();
					}

					if (sustainNote.mustPress) sustainNote.x += FlxG.width / 2; // general offset
					else if(ClientPrefs.data.middleScroll)
					{
						sustainNote.x += 310;
						if(daNoteData > 1) //Up and Right
						{
							sustainNote.x += FlxG.width / 2 + 25;
						}
					}
				}
			}

			if (swagNote.mustPress)
			{
				swagNote.x += FlxG.width / 2; // general offset
			}
			else if(ClientPrefs.data.middleScroll)
			{
				swagNote.x += 310;
				if(daNoteData > 1) //Up and Right
				{
					swagNote.x += FlxG.width / 2 + 25;
				}
			}

			if(!noteTypes.contains(swagNote.noteType)) {
				noteTypes.push(swagNote.noteType);
			}
		}
	}
	for (event in songData.events) //Event Notes
		for (i in 0...event[1].length)
			makeEvent(event, i);

	unspawnNotes.sort(sortByTime);
	generatedMusic = true;
}

	// called only once per different event (Used for precaching)
	function eventPushed(event:EventNote) {
		eventPushedUnique(event);
		if(eventsPushed.contains(event.event)) {
			return;
		}

		stagesFunc(function(stage:BaseStage) stage.eventPushed(event));
		eventsPushed.push(event.event);
	}

	// called by every event with the same name
	function eventPushedUnique(event:EventNote) {
		switch(event.event) {
			case "Change Character":
				var charType:Int = 0;
				switch(event.value1.toLowerCase()) {
					case 'gf' | 'girlfriend' | '1':
						charType = 2;
					case 'dad' | 'opponent' | '0':
						charType = 1;
					default:
						var val1:Int = Std.parseInt(event.value1);
						if(Math.isNaN(val1)) val1 = 0;
						charType = val1;
				}

				var newCharacter:String = event.value2;
				addCharacterToList(newCharacter, charType);
		}
		stagesFunc(function(stage:BaseStage) stage.eventPushedUnique(event));
	}

	function eventEarlyTrigger(event:EventNote):Float {
		var returnedValue:Null<Float> = callOnScripts('eventEarlyTrigger', [event.event, event.value1, event.value2, event.strumTime], true, [], [0]);
		if(returnedValue != null && returnedValue != 0 && returnedValue != FunkinLua.Function_Continue) {
			return returnedValue;
		}

		switch(event.event) {
			case 'Kill Henchmen': //Better timing so that the kill sound matches the beat intended
				return 280; //Plays 280ms before the actual position
		}
		return 0;
	}

	//destroy

	public static function sortByTime(Obj1:Dynamic, Obj2:Dynamic):Int
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);

	function makeEvent(event:Array<Dynamic>, i:Int)
	{
		var subEvent:EventNote = {
			strumTime: event[0] + ClientPrefs.data.noteOffset,
			event: event[1][i][0],
			value1: event[1][i][1],
			value2: event[1][i][2],
			value3: event[1][i][3]
		};
		eventNotes.push(subEvent);
		eventPushed(subEvent);
		callOnScripts('onEventPushed', [subEvent.event, subEvent.value1 != null ? subEvent.value1 : '', subEvent.value2 != null ? subEvent.value2 : '', subEvent.strumTime]);
	}

	public var skipArrowStartTween:Bool = false; //for lua
	private function generateStaticArrows(player:Int):Void
	{
		var strumLineX:Float = ClientPrefs.data.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X;
		var strumLineY:Float = ClientPrefs.data.downScroll ? (FlxG.height - 150) : 50;

		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var targetAlpha:Float = 1;
			if (player < 1)
			{
				if(!ClientPrefs.data.opponentStrums) targetAlpha = 0;
				else if(ClientPrefs.data.middleScroll) targetAlpha = 0.5;
			}

			babyArrow = new StrumNote(strumLineX, strumLineY, i, player);
			babyArrow.downScroll = ClientPrefs.data.downScroll;
			if (!isStoryMode && !skipArrowStartTween)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: targetAlpha}, 0.7, {ease: FlxEase.circInOut, startDelay: 4.5 + (0.4 * i)});
			}
			else
				babyArrow.alpha = targetAlpha;

			if (player == 1)
				playerStrums.add(babyArrow);
			else
			{
				if(ClientPrefs.data.middleScroll)
				{
					if (difficultysong == 'WICKED') {
					babyArrow.x += 310;
					if(i > 1) { //Up and Right
						babyArrow.x += FlxG.width / 2 + 25;
					}
					} else if (difficultysong == 'DEMENTIA') {
					babyArrow.x += 643;
					}
				}
				opponentStrums.add(babyArrow);
			}

			strumLineNotes.add(babyArrow);
			babyArrow.postAddedToGroup();
		}

	}

	override function openSubState(SubState:FlxSubState)
	{
		stagesFunc(function(stage:BaseStage) stage.openSubState(SubState));
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (startTimer != null && !startTimer.finished) startTimer.active = false;
			if (finishTimer != null && !finishTimer.finished) finishTimer.active = false;
			if (songSpeedTween != null) songSpeedTween.active = false;

			var chars:Array<Character> = [boyfriend, boyfriend2, gf, dad];
			for (char in chars)
				if(char != null && char.colorTween != null)
					char.colorTween.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (NNN == false) {
			startCountdown();
		}
		if (NNN == true) {
		stagesFunc(function(stage:BaseStage) stage.closeSubState());
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (startTimer != null && !startTimer.finished) startTimer.active = true;
			if (finishTimer != null && !finishTimer.finished) finishTimer.active = true;
			if (songSpeedTween != null) songSpeedTween.active = true;

			var chars:Array<Character> = [boyfriend, boyfriend2, gf, dad];
			for (char in chars)
				if(char != null && char.colorTween != null)
					char.colorTween.active = true;

			paused = false;
			callOnScripts('onResume');
			resetRPC(startTimer != null && startTimer.finished);
		}
	}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		if (health > 0 && !paused) resetRPC(Conductor.songPosition > 0.0);
		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused) DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")");
		#end

		super.onFocusLost();
	}

	// Updating Discord Rich Presence.
	function resetRPC(?cond:Bool = false)
	{
		#if desktop
			DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")");
		#end
	}

	function resyncVocals():Void
	{
		if(finishTimer != null) return;

		vocals.pause();

		FlxG.sound.music.play();
		FlxG.sound.music.pitch = playbackRate;
		Conductor.songPosition = FlxG.sound.music.time;
		if (Conductor.songPosition <= vocals.length)
		{
			vocals.time = Conductor.songPosition;
			vocals.pitch = playbackRate;
		}
		vocals.play();
	}

	public var paused:Bool = false;
	public var canReset:Bool = true;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	override public function update(elapsed:Float)
	{

		if (stageUI == "Death") health = 100;

		callOnScripts('onUpdate', [elapsed]);

		//if (chartingMode == true) songPosition.text = Std.string(FlxMath.roundDecimal(Conductor.songPosition / 1000, 2)) + " / " + Std.string(FlxMath.roundDecimal(FlxG.sound.music.length / 1000, 2));

		FlxG.camera.followLerp = 0;
		if(!inCutscene && !paused) {
			FlxG.camera.followLerp = FlxMath.bound(elapsed * 2.4 * cameraSpeed * playbackRate / (FlxG.updateFramerate / 60), 0, 1);
			if(!startingSong && !endingSong && boyfriend.animation.curAnim != null && boyfriend.animation.curAnim.name.startsWith('idle')) {
				boyfriendIdleTime += elapsed;
				if(boyfriendIdleTime >= 0.15) { // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled = true;
				}
			} else {
				boyfriendIdleTime = 0;
			}
			if(!startingSong && !endingSong && boyfriend2.animation.curAnim != null && boyfriend2.animation.curAnim.name.startsWith('idle')) {
				boyfriendIdleTime2 += elapsed;
				if(boyfriendIdleTime2 >= 0.15) { // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled2 = true;
				}
			} else {
				boyfriendIdleTime2 = 0;
			}
		}

		super.update(elapsed);

		updateScore();

		setOnScripts('curDecStep', curDecStep);
		setOnScripts('curDecBeat', curDecBeat);

		if (controls.PAUSE && startedCountdown && canPause)
		{
			var ret:Dynamic = callOnScripts('onPause', null, true);
			if(ret != FunkinLua.Function_Stop) {
				openPauseMenu();
			}
		}

		if (controls.justPressed('debug_1') && !endingSong && !inCutscene) {
			//if (TitleState.editorresult == true) {
				openChartEditor();
				statusGame = false;
			//}

			/*if (TitleState.editorresult != true) {
				if (ClientPrefs.data.flashing == true) {
				FlxG.camera.flash(0x6E8D0000, 0.2);
				}
				if (ClientPrefs.data.language == 'Spanish') {
					add(new Notification("Error", "Lastimosamente esta opcion esta desactivada por el Creador o no estas Conectado a Internet", 1, camOther, 1));
					}
					if (ClientPrefs.data.language == 'Inglish') {
						add(new Notification("Mistake", "Unfortunately this option is disabled by the Creator or you are not connected to the Internet", 1, camOther, 1));
					}
					if (ClientPrefs.data.language == 'Portuguese') {
						add(new Notification("Erro", "Infelizmente esta opção está desabilitada pelo Criador ou você não está conectado à Internet", 1, camOther, 1));
					}
			}*/
		}

		//if (stageUI == "pixel") filterTV.update(elapsed);

		if (health > 100) health = 100;

		if (!ClientPrefs.data.noneAnimations && ClientPrefs.data.overlays == true && stageUI != "Death" && stageUI != "Evil") {
		if (healthBar.percent >= 80 && stageUI != "pixel" && !endingSong) {
			FlxTween.tween(healthp, {alpha: ClientPrefs.data.healthBarAlpha}, 0.7);
		} else if (healthBar.percent <= 80 && stageUI != "pixel" && !endingSong) {
			FlxTween.tween(healthp, {alpha: 0}, 0.1);
		}

		if (healthBar.percent > 51) {
			FlxTween.cancelTweensOf(overlay);
			FlxTween.tween(overlay, {alpha: 1}, 0.7);
		} else if (healthBar.percent <= 49) {
			FlxTween.cancelTweensOf(overlay);
			FlxTween.tween(overlay, {alpha: 0}, 0.7);
		}

		if (healthBar.percent < 25) {
			FlxTween.cancelTweensOf(overlayLoost);
			FlxTween.tween(overlayLoost, {alpha: 1}, 0.7);
		} else if (healthBar.percent > 26) {
			FlxTween.cancelTweensOf(overlayLoost);
			FlxTween.tween(overlayLoost, {alpha: 0}, 0.7);
		}
	} else if (ClientPrefs.data.noneAnimations && ClientPrefs.data.overlays == true && stageUI != "Death" && stageUI != "Evil") {

		if (healthBar.percent >= 80 && stageUI != "pixel" && !endingSong) {
			healthp.alpha = ClientPrefs.data.healthBarAlpha;
		} else if (healthBar.percent <= 80 && stageUI != "pixel" && !endingSong) {
			healthp.alpha = 0;
		}

		if (healthBar.percent > 51) {
			overlay.alpha = 1;
		} else if (healthBar.percent <= 49) {
			overlay.alpha = 0;
		}

		if (healthBar.percent < 25) {
			overlayLoost.alpha = 1;
		} else if (healthBar.percent > 26) {
			overlayLoost.alpha = 0;
		}
	}

	if (SONG.bfChange && boyfriend.imageFile.contains('bf')) {
	if (healthBar.percent >= 95) {
		triggerEvent('Change Character', 'bf', 'bf', 'no_flash_camera', Conductor.songPosition);
	} else if (healthBar.percent >= 90 && healthBar.percent < 95) {
		triggerEvent('Change Character', 'bf', 'bf_corruption_90', 'no_flash_camera', Conductor.songPosition);
	} else if (healthBar.percent >= 70 && healthBar.percent < 90) {
		triggerEvent('Change Character', 'bf', 'bf_corruption_70', 'no_flash_camera', Conductor.songPosition);
	} else if (healthBar.percent >= 50 && healthBar.percent < 70) {
		triggerEvent('Change Character', 'bf', 'bf_corruption_50', 'no_flash_camera', Conductor.songPosition);
	} else if (healthBar.percent > 10 && healthBar.percent < 50) {
		triggerEvent('Change Character', 'bf', 'bf_corruption_30', 'no_flash_camera', Conductor.songPosition);
	} else if (healthBar.percent <= 10) {
		triggerEvent('Change Character', 'bf', 'bf_corruption_10', 'no_flash_camera', Conductor.songPosition);
	}
}

		if (controls.justPressed('debug_2') && !endingSong && !inCutscene) {
			//if (TitleState.editorresult == true) {
			openCharacterEditor();
			statusGame = false;
			//}
			if (StartingState.editorresult != true) {
				if (ClientPrefs.data.flashing == true) {
				FlxG.camera.flash(0x6E8D0000, 0.2);
				}
				
				if (ClientPrefs.data.language == 'Spanish') {
					add(new Notification("Error", "Lastimosamente esta opcion esta desactivada por el Creador o no estas Conectado a Internet", 1, camOther, 1));
				} else if (ClientPrefs.data.language == 'Inglish') {
					add(new Notification("Mistake", "Unfortunately this option is disabled by the Creator or you are not connected to the Internet", 1, camOther, 1));
				} else if (ClientPrefs.data.language == 'Portuguese') {
					add(new Notification("Erro", "Infelizmente esta opção está desabilitada pelo Criador ou você não está conectado à Internet", 1, camOther, 1));
				}
					
			}
		}
		
		if (startedCountdown && !paused)
			Conductor.songPosition += FlxG.elapsed * 1000 * playbackRate;

		if (startingSong)
		{
			if (startedCountdown && Conductor.songPosition >= 0)
				startSong();
			else if(!startedCountdown)
				Conductor.songPosition = -Conductor.crochet * 5;
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, FlxMath.bound(1 - (elapsed * 3.125 * camZoomingDecay * playbackRate), 0, 1));
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, FlxMath.bound(1 - (elapsed * 3.125 * camZoomingDecay * playbackRate), 0, 1));
		}

		#if debug
		FlxG.watch.addQuick("secShit", curSection);
		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);
		#end

		// RESET = Quick Game Over Screen
		if (!ClientPrefs.data.noReset && controls.RESET && canReset && !inCutscene && startedCountdown && !endingSong)
		{
			health = 0;
			trace("RESET = True");
		}

		if (unspawnNotes[0] != null)
		{
			var time:Float = spawnTime * playbackRate;
			if(songSpeed < 1) time /= songSpeed;
			if(unspawnNotes[0].multSpeed < 1) time /= unspawnNotes[0].multSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.insert(0, dunceNote);
				dunceNote.spawned = true;

				callOnLuas('onSpawnNote', [notes.members.indexOf(dunceNote), dunceNote.noteData, dunceNote.noteType, dunceNote.isSustainNote, dunceNote.strumTime]);
				callOnHScript('onSpawnNote', [dunceNote]);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			if(!inCutscene)
			{
				if(!cpuControlled) {
					keysCheck();
				} else if(boyfriend.animation.curAnim != null && boyfriend.holdTimer > Conductor.stepCrochet * (0.0011 / FlxG.sound.music.pitch) * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss')) {
					boyfriend.dance();
					//boyfriend.animation.curAnim.finish();
				}

				if (!cpuControlled) {
					keysCheck();
				} else if (boyfriend2.animation.curAnim != null && boyfriend2.holdTimer > Conductor.stepCrochet * (0.0011 / FlxG.sound.music.pitch) * boyfriend2.singDuration && boyfriend2.animation.curAnim.name.startsWith('sing') && !boyfriend2.animation.curAnim.name.endsWith('miss')) {
					boyfriend2.dance();
					//boyfriend2.animation.curAnim.finish();
				}

				if(notes.length > 0)
				{
					if(startedCountdown)
					{
						var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
						notes.forEachAlive(function(daNote:Note)
						{
							var strumGroup:FlxTypedGroup<StrumNote> = playerStrums;
							if(!daNote.mustPress) strumGroup = opponentStrums;

							var strum:StrumNote = strumGroup.members[daNote.noteData];
							daNote.followStrumNote(strum, fakeCrochet, songSpeed / playbackRate);

							if(daNote.mustPress)
							{
								if(cpuControlled && !daNote.blockHit && daNote.canBeHit && (daNote.isSustainNote || daNote.strumTime <= Conductor.songPosition))
									goodNoteHit(daNote);
							}
							else if (daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
								opponentNoteHit(daNote);

							if(daNote.isSustainNote && strum.sustainReduce) daNote.clipToStrumNote(strum);

							// Kill extremely late notes and cause misses
							if (Conductor.songPosition - daNote.strumTime > noteKillOffset)
							{
								if (daNote.mustPress && !cpuControlled &&!daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit))
									noteMiss(daNote);

								daNote.active = false;
								daNote.visible = false;

								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
							}
						});
					}
					else
					{
						notes.forEachAlive(function(daNote:Note)
						{
							daNote.canBeHit = false;
							daNote.wasGoodHit = false;
						});
					}
				}
			}
			checkEventNote();
		}

		#if debug
		if(!endingSong && !startingSong) {
			if (FlxG.keys.justPressed.ONE) {
				KillNotes();
				FlxG.sound.music.onComplete();
			}
			if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
				setSongTime(Conductor.songPosition + 10000);
				clearNotesBefore(Conductor.songPosition);
			}
		}
		#end

		setOnScripts('cameraX', camFollow.x);
		setOnScripts('cameraY', camFollow.y);
		setOnScripts('botPlay', cpuControlled);
		callOnScripts('onUpdatePost', [elapsed]);

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (FlxG.keys.justPressed.SHIFT && boyfriend.animOffsets.exists('hey')) {
			boyfriend.playAnim('hey');
			boyfriend.specialAnim = true;

			heyanim += 1;
		}

		if (songMisses > 5) missionsStatus[2] = true;

		if (FlxG.keys.justPressed.CONTROL) {
			if (cpuControlled == false) {
				mode = true;
				boty = true;
				add(new Notification('Cpu Controller:', "El BotPlay se Activo\n\nDesabilitaron:\n-Score\n-Puntaje\n-Fallas".toUpperCase(), 1, camVIP, 1));
			} else if (cpuControlled == true) {
				mode = false;
				add(new Notification('Cpu Controller:', "El BotPlay se Desactivo\n\nESTA MUSICA NO SERA REGISTRADA.", 1, camVIP, 1));
			}

			cpuControlled = mode;
		}
		if (stageUI != "Death") {
		if (ClientPrefs.data.dodge == true && !fireMode) {
		if (FlxG.keys.justPressed.SPACE) {
			if (boyfriend.animOffsets.exists('dodge')) {
				boyfriend.playAnim('dodge');
				boyfriend.specialAnim = true;
			}
			doge = true;
			if (doge != false) FadeTime.start(0.7, function(Timer:FlxTimer) doge = false, 1);
		}
		}
	} else if (stageUI == "Death") {
	if (fireMode && fireT && FlxG.keys.justPressed.SPACE) { 
		FlxG.sound.play(Paths.sound('notes-sound/sonido-de-disparo'), 1);
		camGame.flash(FlxColor.WHITE, 0.9);
		boyfriend.playAnim('singDOWN', true);
		boyfriend.specialAnim = true;
		songMisses -= FlxG.random.int(1, 5);
		fireT = false;
		tipPress.visible = false;
		if (fireMode) couter.start(FlxG.random.int(1, 8), counth, 1);
	}
}
	}

	function openPauseMenu()
	{
		FlxG.camera.followLerp = 0;
		persistentUpdate = false;
		persistentDraw = true;
		paused = true;

		if(FlxG.sound.music != null) {
			FlxG.sound.music.pause();
			vocals.pause();
		}
		if(!cpuControlled)
		{
			for (note in playerStrums)
				if(note.animation.curAnim != null && note.animation.curAnim.name != 'static')
				{
					note.playAnim('static');
					note.resetAnim = 0;
				}
		}
		openSubState(new PauseModeSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

		#if desktop
		DiscordClient.changePresence("SONG: " + SONG.song.toUpperCase() + "(" + difficultysong + ")", "PAUSED - SCORE: " + songScore);
		#end
	}

	function openChartEditor()
	{
		FlxG.camera.followLerp = 0;
		persistentUpdate = false;
		paused = true;
		cancelMusicFadeTween();
		chartingMode = true;

		#if desktop
		DiscordClient.changePresence("Chart Editor", null, null, true);
		//DiscordClient.resetClientID();
		#end
		
		MusicBeatState.switchState(new ChartingState());
	}

	function openCharacterEditor()
	{
		FlxG.camera.followLerp = 0;
		persistentUpdate = false;
		paused = true;
		cancelMusicFadeTween();
		//#if desktop DiscordClient.resetClientID(); #end
		MusicBeatState.switchState(new CharacterEditorState(SONG.player2));
	}

	public var isDead:Bool = false; //Don't mess with this on Lua!!!
	function doDeathCheck(?skipHealthCheck:Bool = false) {
		if (((skipHealthCheck && instakillOnMiss) || health <= 0) && !practiceMode && !isDead || stageUI == "Death" && songMisses > 20)
		{
			var ret:Dynamic = callOnScripts('onGameOver', null, true);
			if(ret != FunkinLua.Function_Stop) {
				boyfriend.stunned = true;
				boyfriend2.stunned = true;
				deathCounter++;

				deaths += 1;
				scoresTotal += songScore;

				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				persistentUpdate = false;
				persistentDraw = false;

				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x - boyfriend.positionArray[0], boyfriend.getScreenPosition().y - boyfriend.positionArray[1], camFollow.x, camFollow.y));

				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Game Over - " + SONG.song.toUpperCase() + "(" + difficultysong + ")", "Misses: " + songMisses + " - Score: " + songScore);
				#end
				isDead = true;
				return true;
			}
		}
		return false;
	}

	public function checkEventNote() {
		while(eventNotes.length > 0) {
			var leStrumTime:Float = eventNotes[0].strumTime;
			if(Conductor.songPosition < leStrumTime) {
				return;
			}

			var value1:String = '';
			if(eventNotes[0].value1 != null)
				value1 = eventNotes[0].value1;

			var value2:String = '';
			if(eventNotes[0].value2 != null)
				value2 = eventNotes[0].value2;

			var value3:String = '';
			if(eventNotes[0].value3 != null)
				value3 = eventNotes[0].value3;

			triggerEvent(eventNotes[0].event, value1, value2, value3, leStrumTime);
			eventNotes.shift();
		}
	}

	public function triggerEvent(eventName:String, value1:String, value2:String, value3:String, strumTime:Float) {
		var flValue1:Null<Float> = Std.parseFloat(value1);
		var flValue2:Null<Float> = Std.parseFloat(value2);
		var flValue3:Null<Float> = Std.parseFloat(value3);
		if(Math.isNaN(flValue1)) flValue1 = null;
		if(Math.isNaN(flValue2)) flValue2 = null;
		if(Math.isNaN(flValue3)) flValue3 = null;

		switch(eventName) {
			case 'Hey!':
				var value:Int = 2;
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						value = 0;
					case 'gf' | 'girlfriend' | '1':
						value = 1;
				}

				if(flValue2 == null || flValue2 <= 0) flValue2 = 0.6;

				if(value != 0) {
					if(dad.curCharacter.startsWith('gf')) { //Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
						dad.playAnim('cheer', true);
						dad.specialAnim = true;
						dad.heyTimer = flValue2;
					} else if (gf != null) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = flValue2;
					}
				}
				if(value != 1) {
					boyfriend.playAnim('hey', true);
					boyfriend.specialAnim = true;
					boyfriend.heyTimer = flValue2;
				}

			case 'Set GF Speed':
				if(flValue1 == null || flValue1 < 1) flValue1 = 1;
				gfSpeed = Math.round(flValue1);

			case 'Add Camera Zoom':
				if(ClientPrefs.data.camZooms && FlxG.camera.zoom < 1.35) {
					if(flValue1 == null) flValue1 = 0.015;
					if(flValue2 == null) flValue2 = 0.03;

					camGame.zoom += flValue1;
				}

			case 'Play Animation':
				//trace('Anim to play: ' + value1);
				var char:Character = dad;
				if (ClientPrefs.data.alphahud == true) {
				FlxTween.tween(camHUD, {alpha: 1}, 0.5);
				}

				if (ClientPrefs.data.concetration == true) {
					FlxTween.tween(blackMode, {alpha: 1}, 0.2);
				}
				switch(value2.toLowerCase().trim()) {
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					default:
						if(flValue2 == null) flValue2 = 0;
						switch(Math.round(flValue2)) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.playAnim(value1, true);
					char.specialAnim = true;
				}

			case 'Camera Follow Pos':
				if(camFollow != null)
				{
					isCameraOnForcedPos = false;
					if(flValue1 != null || flValue2 != null)
					{
						isCameraOnForcedPos = true;
						if(flValue1 == null) flValue1 = 0;
						if(flValue2 == null) flValue2 = 0;
						camFollow.x = flValue1;
						camFollow.y = flValue2;
					}
				}

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch(value1.toLowerCase().trim()) {
					case 'gf' | 'girlfriend':
						char = gf;
					case 'boyfriend' | 'bf':
						char = boyfriend;
					default:
						var val:Int = Std.parseInt(value1);
						if(Math.isNaN(val)) val = 0;

						switch(val) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.idleSuffix = value2;
					char.recalculateDanceIdle();
				}

				//eventCalled

			case 'Screen Shake':
				var valuesArray:Array<String> = [value1, value2];
				var targetsArray:Array<FlxCamera> = [camGame, camHUD];
				for (i in 0...targetsArray.length) {
					var split:Array<String> = valuesArray[i].split(',');
					var duration:Float = 0;
					var intensity:Float = 0;
					if(split[0] != null) duration = Std.parseFloat(split[0].trim());
					if(split[1] != null) intensity = Std.parseFloat(split[1].trim());
					if(Math.isNaN(duration)) duration = 0;
					if(Math.isNaN(intensity)) intensity = 0;

					if(duration > 0 && intensity != 0) {
						targetsArray[i].shake(intensity, duration);
					}
				}


			case 'Change Character':
				var charType:Int = 0;
				
				if (value3 == null) camGame.flash(FlxColor.WHITE, 0.1);

				switch(value1.toLowerCase().trim()) {
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				switch(charType) {
					case 0:
						if(boyfriend.curCharacter != value2) {
							if(!boyfriendMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = boyfriend.alpha;
							boyfriend.alpha = 0.00001;
							boyfriend = boyfriendMap.get(value2);
							boyfriend.alpha = lastAlpha;
						}
						setOnScripts('boyfriendName', boyfriend.curCharacter);

					case 1:
						if(dad.curCharacter != value2) {
							if(!dadMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf-') || dad.curCharacter == 'gf';
							var lastAlpha:Float = dad.alpha;
							dad.alpha = 0.00001;
							dad = dadMap.get(value2);
							if(!dad.curCharacter.startsWith('gf-') && dad.curCharacter != 'gf') {
								if(wasGf && gf != null) {
									gf.visible = true;
								}
							} else if(gf != null) {
								gf.visible = false;
							}
							dad.alpha = lastAlpha;
						}
						setOnScripts('dadName', dad.curCharacter);

					case 2:
						if(gf != null)
						{
							if(gf.curCharacter != value2)
							{
								if(!gfMap.exists(value2)) {
									addCharacterToList(value2, charType);
								}

								var lastAlpha:Float = gf.alpha;
								gf.alpha = 0.00001;
								gf = gfMap.get(value2);
								gf.alpha = lastAlpha;
							}
							setOnScripts('gfName', gf.curCharacter);
						}
				}

			case 'Change Scroll Speed':
				if (songSpeedType != "constant")
				{
					if(flValue1 == null) flValue1 = 1;
					if(flValue2 == null) flValue2 = 0;

					var newValue:Float = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed') * flValue1;
					if(flValue2 <= 0)
						songSpeed = newValue;
					else
						songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, flValue2 / playbackRate, {ease: FlxEase.linear, onComplete:
							function (twn:FlxTween)
							{
								songSpeedTween = null;
							}
						});
				}

			case 'Set Property':
				try
				{
					var split:Array<String> = value1.split('.');
					if(split.length > 1) {
						LuaUtils.setVarInArray(LuaUtils.getPropertyLoop(split), split[split.length-1], value2);
					} else {
						LuaUtils.setVarInArray(this, value1, value2);
					}
				}
				catch(e:Dynamic)
				{
					trace('ERROR ("Set Property" Event) - ' + e.message.substr(0, e.message.indexOf('\n')));
				}
			
			case 'Play Sound':
				if(flValue2 == null) flValue2 = 1;
				//FlxG.sound.play(Paths.sound(value1), flValue2);
				if (ClientPrefs.data.alphahud == true) {
				FlxTween.tween(camHUD, {alpha: 0}, 0.5);
				}
				if (ClientPrefs.data.concetration == true) {
					FlxTween.tween(blackMode, {alpha: 0}, 0.2);
				}
				FlxTween.tween(scoreTxt, {alpha: 1}, 8);

			case 'Speed Aument':
				if (songSpeedType != "constant")
					{
						if(flValue2 == null) flValue2 = 1;
	
						var newValue:Float = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed') * flValue1;
						if(flValue2 <= 0)
							songSpeed = newValue;
						else
							FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, flValue2);
							songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, flValue2 / playbackRate, {ease: FlxEase.linear, onComplete:
								function (twn:FlxTween)
								{
									songSpeedTween = null;
								}
							});
					}

			case 'Warning':
				if(flValue1 == null) flValue1 = 1;
				if(flValue2 == null) flValue2 = 0.7;

				if (difficultysong == 'DEMENTIA') {

				FlxTween.tween(signal, {alpha: flValue1}, flValue2, {
					onComplete: function (twn:FlxTween) {
						FlxTween.tween(signal, {alpha: 0}, flValue2);
					}
				});
			}

			case 'Alpha HUD':
				if(flValue1 == null) flValue1 = 1;
				if(flValue2 == null) flValue2 = 0.5;

						if (ClientPrefs.data.alphahud == true) {
							FlxTween.tween(camHUD, {alpha: flValue1}, flValue2);
							if (flValue1 == 0 && ClientPrefs.data.concetration == false) {
								FlxTween.tween(camOther, {alpha: flValue1 + 1}, flValue2);
							}
							
							}
			
							if (ClientPrefs.data.concetration == true) {
								FlxTween.tween(camHD, {alpha: flValue1}, 0.2);
								FlxTween.tween(camNotes, {alpha: flValue1}, flValue2);
								FlxTween.tween(camOther, {alpha: flValue1}, flValue2);
							}

			case 'Fade Camera':
				if (flValue1 == null) flValue1 = 1;
				if (flValue2 == null) flValue2 = 1;

				if (flValue1 == 1) statusFade = true;
				if (flValue1 == 0) statusFade = false;

				camGame.fade(FlxColor.BLACK, flValue2, statusFade);
				camHUD.fade(FlxColor.BLACK, flValue2, statusFade);

			case 'Volume Song':
				if (flValue1 == null) flValue1 = 1;
				if (flValue2 == null) flValue2 = 1;

				if (flValue1 >= inst.volume) {
					modes1 = true;
					modes2 = false;
				}
				if (flValue1 < inst.volume) {
					modes1 = false;
					modes2 = true;
				}

				volumeSong(flValue1, modes1, modes2, flValue2);

			case 'Flash':
				if (flValue1 == null) flValue1 = 1;
				if (flValue2 == null) flValue2 = 1;

				if (flValue1 == 0) colorNum = FlxColor.WHITE;
				if (flValue1 == 1) colorNum = FlxColor.BLACK;
				if (flValue1 == 2) colorNum = FlxColor.GREEN;
				if (flValue1 == 3) colorNum = FlxColor.YELLOW;
				if (flValue1 == 4) colorNum = FlxColor.BLUE;
				if (flValue1 == 5) colorNum = FlxColor.RED;
				if (flValue1 == 6) colorNum = FlxColor.PINK;
				if (flValue1 == 7) colorNum = FlxColor.PURPLE;

				if (stageUI != "Death") {
					camGame.flash(colorNum, flValue2);
				} else {
					camGame.flash(colorNum, 1.2);
				}

			case 'damage':
				if (flValue1 == null) flValue1 = 0;
				if (flValue2 == null) flValue2 = 1;

				if (flValue2 == 1) {
				if (flValue1 < health) {
					health -= flValue1;
				}
				if (flValue1 >= health) {
					flValue1 = health;
					flValue1 -= 10;

					health -= flValue1;
				}
			}
			if (flValue2 == 0) {
				health -= flValue1;
			}

			case 'Cinematics':
				if (flValue2 == null) 0.5;

				if (value1 == 'true' || value1 == 'True' || value1 == 'TRUE' || flValue1 == 1) {
					FlxTween.cancelTweensOf(upBar);
					FlxTween.cancelTweensOf(downBar);
					FlxTween.tween(upBar, {y: 0}, flValue2, {
						ease: FlxEase.circOut
					});
					FlxTween.tween(downBar, {y: 600}, flValue2, {
						ease: FlxEase.circOut
					});
					allVisible(false);
				} else if (value1 == 'false' || value1 == 'False' || value1 == 'FALSE' || flValue1 == 2) {
					FlxTween.cancelTweensOf(downBar);
					FlxTween.cancelTweensOf(upBar);
					FlxTween.tween(downBar, {y: 720}, flValue2, {
						ease: FlxEase.circOut
					});
					FlxTween.tween(upBar, {y: -120}, flValue2, {
						ease: FlxEase.circOut
					});
					allVisible(true);
				}

			case 'fireMode':
				if (flValue1 == 1) fireMode = true;
				if (flValue1 == 0) fireMode = false;

				if (fireMode) {
					couter.start(flValue2, counth, 1);
				} else {
					couter.cancel();
					tipPress.visible = false;
				}

			case 'hitSong':
				hitNotesong();
		}
		
		stagesFunc(function(stage:BaseStage) stage.eventCalled(eventName, value1, value2, flValue1, flValue2, strumTime));
		callOnScripts('onEvent', [eventName, value1, value2, strumTime]);
	}

	function allVisible(visible:Bool) {
		if (!visible) {
		healthBar.visible = false;
		timeTxt.visible = false;
		healthTxt.visible = false;
		scoreTxt.visible = false;
		if (ClientPrefs.data.overlays) {
			if (stageUI != "Death" && stageUI != "Evil") overlay.visible = false;
			if (stageUI != "Death" && stageUI != "Evil") overlayLoost.visible = false;
			if (stageUI != "Death" && stageUI != "Evil") healthp.visible = false;
		}
		} else {
		if (stageUI != "Death") healthBar.visible = true;
		timeTxt.visible = true;
		healthTxt.visible = true;
		if (stageUI != "Death") scoreTxt.visible = true;
		if (ClientPrefs.data.overlays) {
			if (stageUI != "Death" && stageUI != "Evil") overlay.visible = true;
			if (stageUI != "Death" && stageUI != "Evil") overlayLoost.visible = true;
			if (stageUI != "Death" && stageUI != "Evil") healthp.visible = true;
		}
		}
	}

	public function counth(Timer:FlxTimer) {
		camGame.flash(FlxColor.BLACK, 0.4);
		fireT = true;
		FlxG.sound.play(Paths.sound('notes-sound/loader'), 1);
		tipPress.visible = true;
	}

	public function volumeSong(volume:Float, ?fadeIn:Bool, ?fadeOut:Bool = false, ?duration:Float = 1) {
		if (fadeIn == true && fadeOut == false) {
			inst.fadeIn(duration, inst.volume, volume);
		} else if (fadeIn == false && fadeOut == true) {
			inst.fadeOut(duration, volume);
		} else if (fadeIn == false && fadeOut == false) {
			inst.volume = volume;
		} else if (fadeIn == true && fadeOut == true) {
			trace("ERROR!! No se puede iniciar con un [IN] y un [OUT]");
		}
	}

	function moveCameraSection(?sec:Null<Int>):Void {
		if(sec == null) sec = curSection;
		if(sec < 0) sec = 0;

		if(SONG.notes[sec] == null) return;

		if (gf != null && SONG.notes[sec].gfSection)
		{
			camFollow.setPosition(gf.getMidpoint().x, gf.getMidpoint().y);
			camFollow.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
			camFollow.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];
			//tweenCamIn();
			callOnScripts('onMoveCamera', ['gf']);
			return;
		}

		moveCamera(isDad, isBF);
		callOnScripts('onMoveCamera', [isDad ? 'dad' : 'boyfriend']);
	}

	var cameraTwn:FlxTween;
	var numT:Int;
	public function moveCamera(isDad:Bool, isBF:Bool)
	{
		if(isDad && !isBF)
		{
			//camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			FlxTween.cancelTweensOf(camFollow);
			FlxTween.tween(camFollow, {x: (dad.getMidpoint().x + 150) - (dad.cameraPosition[0] - opponentCameraOffset[0]), y: (dad.getMidpoint().y - 100) + (dad.cameraPosition[1] + opponentCameraOffset[1])}, 0.1, {ease: SONG.animCamera});
			//tweenCamIn();
		} else if (!isBF && !isDad) {
			
			numT = FlxG.random.int(0, 1);

			if (numT == 0) {
				FlxTween.cancelTweensOf(camFollow);
				FlxTween.tween(camFollow, {x: (dad.getMidpoint().x + 150) - (dad.cameraPosition[0] - opponentCameraOffset[0]), y: (dad.getMidpoint().y - 100) + (dad.cameraPosition[1] + opponentCameraOffset[1])}, 0.3, {ease: SONG.animCamera});
			} else if (numT == 1) {
				FlxTween.cancelTweensOf(camFollow);
				FlxTween.tween(camFollow, {x: (boyfriend.getMidpoint().x - 100) - (boyfriend.cameraPosition[0] - boyfriendCameraOffset[0]), y: (boyfriend.getMidpoint().y - 100) + (boyfriend.cameraPosition[1] + boyfriendCameraOffset[1])}, 0.3, {ease: SONG.animCamera});
			}
		} else if (isBF && isDad) {
			if (health < 90) {
				FlxTween.cancelTweensOf(camFollow);
				FlxTween.tween(camFollow, {x: (dad.getMidpoint().x + 150) - (dad.cameraPosition[0] - opponentCameraOffset[0]), y: (dad.getMidpoint().y - 100) + (dad.cameraPosition[1] + opponentCameraOffset[1])}, 0.3, {ease: SONG.animCamera});
			}

			if (health > 90) {
				FlxTween.cancelTweensOf(camFollow);
				FlxTween.tween(camFollow, {x: (boyfriend.getMidpoint().x - 100) - (boyfriend.cameraPosition[0] - boyfriendCameraOffset[0]), y: (boyfriend.getMidpoint().y - 100) + (boyfriend.cameraPosition[1] + boyfriendCameraOffset[1])}, 0.3, {ease: SONG.animCamera});
			}
		} else if (isBF && !isDad) {
			//camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			FlxTween.cancelTweensOf(camFollow);
			FlxTween.tween(camFollow, {x: (boyfriend.getMidpoint().x - 100) - (boyfriend.cameraPosition[0] - boyfriendCameraOffset[0]), y: (boyfriend.getMidpoint().y - 100) + (boyfriend.cameraPosition[1] + boyfriendCameraOffset[1])}, 0.3, {ease: SONG.animCamera});

			if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1)
			{
				cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
					function (twn:FlxTween)
					{
						cameraTwn = null;
					}
				});
			}
		}
	}

	public function finishSong(?ignoreNoteOffset:Bool = false):Void
	{
		updateTime = false;
		FlxG.sound.music.volume = 0;
		//missNotesong += songMisses;
		scoresTotal += songScore;
		vocals.volume = 0;

		statusGame = false;

		//Mision Test Final

		if (healthBar.percent > 25) missionsStatus[4] = true;

		if (ratingPercent < 0.5) missionsStatus[3] = true;

		vocals.pause();
		if(ClientPrefs.data.noteOffset <= 0 || ignoreNoteOffset) {
			endCallback();
		} else {
			finishTimer = new FlxTimer().start(ClientPrefs.data.noteOffset / 1000, function(tmr:FlxTimer) {
				endCallback();
			});
		}
	}


	public var transitioning = false;
	public function endSong()
	{

		var ganadoHealth:Int = FlxG.random.int(65, 95);
		var ganadoRating:Int = FlxG.random.int(15, 20);
		var ganadoMisseds:Int = FlxG.random.int(25, 55);
		var ganadoSpecial:Int = FlxG.random.int(20, 50);
		var ganador:Int = FlxG.random.int(50, 80);
		var ganadoSong:Int = 0;

		if (stageUI == "pixel") stageUI = "normal";

		if (!boty) FlxGameJolt.addScore(SONG.song, songScore, 877566, true, ClientPrefs.data.username);

		//ADD COINS
		if (missionsStatus[0] == false && SONG.mision1 && Highscore.getScore(SONG.song, curDifficulty) == 0 && !boty) {
			ClientPrefs.data.coins += ganador;
			ganadoSong = ganador;
		}
		if (missionsStatus[1] == false && SONG.mision2 && !boty) {
			ClientPrefs.data.coins += ganadoSpecial;
		}
		if (missionsStatus[2] == false && SONG.mision3 && !boty) {
			ClientPrefs.data.coins += ganadoMisseds;
		}
		if (missionsStatus[3] == false && SONG.mision4 && !boty) {
			ClientPrefs.data.coins += ganadoRating;
		}
		if (missionsStatus[4] == false && SONG.mision5 && !boty) {
			ClientPrefs.data.coins += ganadoHealth;
		}

		if (!boty) pointsWin += ganadoHealth + ganadoRating + ganadoMisseds + ganadoSpecial + ganadoSong;

		FlxTween.tween(camHUD, {alpha: 0}, 1);
		if(!startingSong) {
			notes.forEach(function(daNote:Note) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 1 * healthLoss;
				}
			});
			for (daNote in unspawnNotes) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 1 * healthLoss;
				}
			}

			if(doDeathCheck()) {
				return false;
			}
		}
		
		timeTxt.visible = false;
		canPause = false;
		endingSong = true;
		camZooming = false;
		inCutscene = false;
		updateTime = false;

		deathCounter = 0;
		seenCutscene = false;

		var ret:Dynamic = callOnScripts('onEndSong', null, true);
		if(ret != FunkinLua.Function_Stop && !transitioning)
		{
			#if !switch
			var percent:Float = ratingPercent;
			if(Math.isNaN(percent)) percent = 0;
			Highscore.saveScore(SONG.song, songScore, storyDifficulty, percent);
			#end
			playbackRate = 1;

			if (chartingMode)
			{
				openChartEditor();
				return false;
			}

			if (isStoryMode)
			{
				campaignScore += songScore;
				campaignMisses += songMisses;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					Mods.loadTopMod();
					//#if desktop DiscordClient.resetClientID(); #end

					cancelMusicFadeTween();
				FlxTween.tween(transBlack, {alpha: 1}, 1, {
					onComplete: function(twn:FlxTween) {
						if (ClientPrefs.data.music == 'Disabled') FlxG.sound.playMusic(Paths.music('none'));

						if (ClientPrefs.data.music == 'Hallucination') FlxG.sound.playMusic(Paths.music('Hallucination'), 1.2);

						if (ClientPrefs.data.music == 'TerminalMusic') FlxG.sound.playMusic(Paths.music('TerminalMusic'));
						
						MusicBeatState.switchState(new StoryMenuState());

						if(!ClientPrefs.getGameplaySetting('practice') && !ClientPrefs.getGameplaySetting('botplay')) {
							StoryMenuState.weekCompleted.set(WeekData.weeksList[storyWeek], true);
							Highscore.saveWeekScore(WeekData.getWeekFileName(), campaignScore, storyDifficulty);
	
							FlxG.save.data.weekCompleted = StoryMenuState.weekCompleted;
							FlxG.save.flush();
						}
						changedDifficulty = false;
						}
					});
				}
				else
				{
					var difficulty:String = Difficulty.getFilePath();

					trace('LOADING NEXT SONG');
					trace(Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);
					prevCamFollow = camFollow;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					cancelMusicFadeTween();
					FlxTween.tween(transBlack, {alpha: 1}, 1, {
						onComplete: function(twn:FlxTween) {
							LoadingState.loadAndSwitchState(new PlayState());
						}
					});

				}
			}
			else
			{
				trace('Regresaste a FreePlay??');
				Mods.loadTopMod();
				//#if desktop DiscordClient.resetClientID(); #end

				cancelMusicFadeTween();
				FlxTween.tween(transBlack, {alpha: 1}, 1, {
					onComplete: function(twn:FlxTween) {
						MusicBeatState.switchState(new FreeplayState());
						changedDifficulty = false;
					}
				});
			}
			transitioning = true;
		}
		return true;
	}

	#if ACHIEVEMENTS_ALLOWED
	var achievementObj:AchievementPopup = null;
	var notifi:Notification = null;
	function startAchievement() {
			
			if (missionsStatus[0] == true && SONG.mision1 && !boty) {
				failNoti += '\n>Extraño? no completaste la cancion?';
			}
			if (missionsStatus[1] == true && SONG.mision2 && !boty) {
				failNoti += '\n>Fallaste las flechas especiales';
			}
			if (missionsStatus[2] == true && SONG.mision3 && !boty) {
				failNoti += '\n>Fallaste mas de 5 Flechas';
			}
			if (missionsStatus[3] == true && SONG.mision4 && !boty) {
				failNoti += '\n>No tuvistes una clasificacion superior a 50%';
			}
			if (missionsStatus[4] == true && SONG.mision5 && !boty) {
				failNoti += '\n>Tu vida es por encima de 25%';
			}

			if (failNoti != '' && !boty) {
				add(new Notification('Misiones Fallidas', failNoti, 2, camVIP, 1.5));
			} else if (boty) {
				add(new Notification('ERROR', 'Utilizaste el BOTPLAY durante la cancion. se te desabilitaron los Logros'.toUpperCase(), 2, camVIP, 1.5));
			}

			statusGame = false;

			FlxTween.tween(camHUD, {alpha: 0}, 2, {
				onComplete: function(twn:FlxTween) {
					endSong();
				}
			});
	}
	#end

	public function KillNotes() {
		while(notes.length > 0) {
			var daNote:Note = notes.members[0];
			daNote.active = false;
			daNote.visible = false;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}
		unspawnNotes = [];
		eventNotes = [];
	}

	public var totalPlayed:Int = 0;
	public var totalNotesHit:Float = 0.0;

	public var showCombo:Bool = false;
	public var showComboNum:Bool = true;
	public var showRating:Bool = true;

	// stores the last judgement object
	var lastRating:FlxSprite;
	// stores the last combo sprite object
	var lastCombo:FlxSprite;
	// stores the last combo score objects in an array
	var lastScore:Array<FlxSprite> = [];

	private function cachePopUpScore()
	{
		var uiPrefix:String = '';
		var uiSuffix:String = '';
		if (stageUI != "normal")
		{
			uiPrefix = '${stageUI}UI/';
			if (PlayState.isPixelStage) uiSuffix = '-pixel';
		}

		for (rating in ratingsData) {
			if (stageUI != "Death" && stageUI != "Evil") Paths.image(uiPrefix + rating.image + uiSuffix);
		if (stageUI == "Death" || stageUI == "Evil") Paths.image(rating.image);
		}
		for (i in 0...10) {
			if (stageUI != "Death" && stageUI != "Evil") Paths.image(uiPrefix + 'num' + i + uiSuffix);
		if (stageUI == "Death" || stageUI == "Evil") Paths.image('num' + i);
		}
	}

	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + ClientPrefs.data.ratingOffset);
		vocals.volume = 1;

		var placement:Float =  FlxG.width * 0.35;
		var rating:FlxSprite = new FlxSprite();
		var score:Int = FlxG.random.int(50, 755);

		//tryna do MS based judgment due to popular demand
		var daRating:Rating = Conductor.judgeNote(ratingsData, noteDiff / playbackRate);

		totalNotesHit += daRating.ratingMod;
		note.ratingMod = daRating.ratingMod;
		if(!note.ratingDisabled) daRating.hits++;
		note.rating = daRating.name;
		score = daRating.score;

		if(daRating.noteSplash && !note.noteSplashData.disabled)
			spawnNoteSplashOnNote(note);

		if(!practiceMode && !cpuControlled) {
			songScore += score;
			if(!note.ratingDisabled)
			{
				songHits++;
				totalPlayed++;
				RecalculateRating(false);
			}
		}

		var uiPrefix:String = "";
		var uiSuffix:String = '';
		var antialias:Bool = ClientPrefs.data.antialiasing;

		if (stageUI != "normal")
		{
			uiPrefix = '${stageUI}UI/';
			if (PlayState.isPixelStage) uiSuffix = '-pixel';
			antialias = !isPixelStage;
		}

		if (stageUI != "Death" && stageUI != "Evil") rating.loadGraphic(Paths.image(uiPrefix + daRating.image + uiSuffix));
		if (stageUI == "Death" || stageUI == "Evil") rating.loadGraphic(Paths.image(daRating.image));
		rating.cameras = [camHUD];
		rating.screenCenter();
		rating.x = placement - 40;
		rating.y -= 60;
		if (!ClientPrefs.data.noneAnimations) {
		rating.acceleration.y = 550 * playbackRate * playbackRate;
		rating.velocity.y -= FlxG.random.int(175, 375) * playbackRate;
		rating.velocity.x -= FlxG.random.int(-150, 190) * playbackRate;
		}
		if (ClientPrefs.data.noneAnimations) {
			rating.acceleration.y = 0;
			rating.velocity.y -= 0;
			rating.velocity.x -= 0;
		}
		rating.visible = (!ClientPrefs.data.hideHud && showRating);
		rating.x += ClientPrefs.data.comboOffset[0];
		rating.y -= ClientPrefs.data.comboOffset[1];
		rating.antialiasing = antialias;

		var comboSpr:FlxSprite = new FlxSprite();
		if (stageUI != "Death" && stageUI != "Evil") comboSpr.loadGraphic(Paths.image(uiPrefix + 'combo' + uiSuffix));
		if (stageUI == "Death" || stageUI == "Evil") comboSpr.loadGraphic(Paths.image('combo'));
		comboSpr.cameras = [camHUD];
		comboSpr.screenCenter();
		comboSpr.x = placement;
		comboSpr.acceleration.y = FlxG.random.int(200, 300) * playbackRate * playbackRate;
		comboSpr.velocity.y -= FlxG.random.int(140, 160) * playbackRate;
		comboSpr.visible = (!ClientPrefs.data.hideHud && showCombo);
		comboSpr.x += ClientPrefs.data.comboOffset[0];
		comboSpr.y -= ClientPrefs.data.comboOffset[1];
		comboSpr.antialiasing = antialias;
		comboSpr.y += 60;
		comboSpr.velocity.x += FlxG.random.int(1, 10) * playbackRate;

		insert(members.indexOf(strumLineNotes), rating);
		
		if (!ClientPrefs.data.comboStacking)
		{
			if (lastRating != null) lastRating.kill();
			lastRating = rating;
		}

		if (!PlayState.isPixelStage)
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.85));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.85));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		if (combo >= 10000) seperatedScore.push(Math.floor(combo / 10000) % 10);
		if(combo >= 1000) seperatedScore.push(Math.floor(combo / 1000) % 10);
		if (combo >= 100) seperatedScore.push(Math.floor(combo / 100) % 10);
		if (combo >= 10) seperatedScore.push(Math.floor(combo / 10) % 10);
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		var xThing:Float = 0;
		if (showCombo)
		{
			insert(members.indexOf(strumLineNotes), comboSpr);
		}
		if (!ClientPrefs.data.comboStacking)
		{
			if (lastCombo != null) lastCombo.kill();
			lastCombo = comboSpr;
		}
		if (lastScore != null)
		{
			while (lastScore.length > 0)
			{
				lastScore[0].kill();
				lastScore.remove(lastScore[0]);
			}
		}
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite();
			if (stageUI != "Death" && stageUI != "Evil") numScore.loadGraphic(Paths.image(uiPrefix + 'num' + Std.int(i) + uiSuffix));
			if (stageUI == "Death" || stageUI == "Evil") numScore.loadGraphic(Paths.image('num' + Std.int(i)));
			numScore.cameras = [camHUD];
			numScore.screenCenter();
			numScore.x = placement + (43 * daLoop) - 90 + ClientPrefs.data.comboOffset[2];
			numScore.y += 80 - ClientPrefs.data.comboOffset[3];
			
			if (!ClientPrefs.data.comboStacking)
				lastScore.push(numScore);

			if (!PlayState.isPixelStage) numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			else numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			numScore.updateHitbox();

			if (!ClientPrefs.data.noneAnimations) {
			numScore.acceleration.y = FlxG.random.int(200, 300) * playbackRate * playbackRate;
			numScore.velocity.y -= FlxG.random.int(40, 90) * playbackRate;
			numScore.velocity.x = FlxG.random.float(20, 140) * playbackRate;
			}
			if (ClientPrefs.data.noneAnimations) {
			numScore.acceleration.y = 0;
			numScore.velocity.y -= 0;
			numScore.velocity.x =0;
			}
			numScore.visible = !ClientPrefs.data.hideHud;
			numScore.antialiasing = antialias;

			//if (combo >= 10 || combo == 0)
			if(showComboNum)
				insert(members.indexOf(strumLineNotes), numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2 / playbackRate, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002 / playbackRate
			});

			daLoop++;
			if(numScore.x > xThing) xThing = numScore.x;
		}
		comboSpr.x = xThing + 50;
		FlxTween.tween(rating, {alpha: 0}, 0.2 / playbackRate, {
			startDelay: Conductor.crochet * 0.001 / playbackRate
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2 / playbackRate, {
			onComplete: function(tween:FlxTween)
			{
				comboSpr.destroy();
				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.002 / playbackRate
		});
	}

	public var strumsBlocked:Array<Bool> = [];
	private function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(keysArray, eventKey);
		if (!controls.controllerMode && FlxG.keys.checkStatus(eventKey, JUST_PRESSED)) keyPressed(key);
	}

	private function keyPressed(key:Int)
	{
		if (!cpuControlled && startedCountdown && !paused && key > -1)
		{
			if(notes.length > 0 && !boyfriend.stunned && !boyfriend2.stunned && generatedMusic && !endingSong)
			{
				//more accurate hit time for the ratings?
				var lastTime:Float = Conductor.songPosition;
				if(Conductor.songPosition >= 0) Conductor.songPosition = FlxG.sound.music.time;

				var canMiss:Bool = !ClientPrefs.data.ghostTapping;

				// heavily based on my own code LOL if it aint broke dont fix it
				var pressNotes:Array<Note> = [];
				var notesStopped:Bool = false;
				var sortedNotesList:Array<Note> = [];
				notes.forEachAlive(function(daNote:Note)
				{
					if (strumsBlocked[daNote.noteData] != true && daNote.canBeHit && daNote.mustPress &&
						!daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && !daNote.blockHit)
					{
						if(daNote.noteData == key) sortedNotesList.push(daNote);
						canMiss = true;
					}
				});
				sortedNotesList.sort(sortHitNotes);

				if (sortedNotesList.length > 0) {
					for (epicNote in sortedNotesList)
					{
						for (doubleNote in pressNotes) {
							if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 1) {
								doubleNote.kill();
								notes.remove(doubleNote, true);
								doubleNote.destroy();
							} else
								notesStopped = true;
						}

						// eee jack detection before was not super good
						if (!notesStopped) {
							goodNoteHit(epicNote);
							pressNotes.push(epicNote);
						}

					}
				}
				else {
					callOnScripts('onGhostTap', [key]);
					if (canMiss && !boyfriend.stunned) noteMissPress(key);
					if (canMiss && !boyfriend2.stunned) noteMissPress(key);
				}

				// I dunno what you need this for but here you go
				//									- Shubs

				// Shubs, this is for the "Just the Two of Us" achievement lol
				//									- Shadow Mario
				if(!keysPressed.contains(key)) keysPressed.push(key);

				//more accurate hit time for the ratings? part 2 (Now that the calculations are done, go back to the time it was before for not causing a note stutter)
				Conductor.songPosition = lastTime;
			}

			var spr:StrumNote = playerStrums.members[key];
			if(strumsBlocked[key] != true && spr != null && spr.animation.curAnim.name != 'confirm')
			{
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			callOnScripts('onKeyPress', [key]);
		}
	}

	public static function sortHitNotes(a:Note, b:Note):Int
	{
		if (a.lowPriority && !b.lowPriority)
			return 1;
		else if (!a.lowPriority && b.lowPriority)
			return -1;

		return FlxSort.byValues(FlxSort.ASCENDING, a.strumTime, b.strumTime);
	}

	private function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(keysArray, eventKey);
		//trace('Pressed: ' + eventKey);

		if(!controls.controllerMode && key > -1) keyReleased(key);
	}

	private function keyReleased(key:Int)
	{
		if(!cpuControlled && startedCountdown && !paused)
		{
			var spr:StrumNote = playerStrums.members[key];
			if(spr != null)
			{
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
			callOnScripts('onKeyRelease', [key]);
		}
	}

	public static function getKeyFromEvent(arr:Array<String>, key:FlxKey):Int
	{
		if(key != NONE)
		{
			for (i in 0...arr.length)
			{
				var note:Array<FlxKey> = Controls.instance.keyboardBinds[arr[i]];
				for (noteKey in note)
					if(key == noteKey)
						return i;
			}
		}
		return -1;
	}

	// Hold notes
	private function keysCheck():Void
	{
		// HOLDING
		var holdArray:Array<Bool> = [];
		var pressArray:Array<Bool> = [];
		var releaseArray:Array<Bool> = [];
		for (key in keysArray)
		{
			holdArray.push(controls.pressed(key));
			pressArray.push(controls.justPressed(key));
			releaseArray.push(controls.justReleased(key));
		}

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(controls.controllerMode && pressArray.contains(true))
			for (i in 0...pressArray.length)
				if(pressArray[i] && strumsBlocked[i] != true)
					keyPressed(i);

		if (startedCountdown && !boyfriend.stunned && !boyfriend2.stunned && generatedMusic)
		{
			// rewritten inputs???
			if(notes.length > 0)
			{
				notes.forEachAlive(function(daNote:Note)
				{
					// hold note functions
					if (strumsBlocked[daNote.noteData] != true && daNote.isSustainNote && holdArray[daNote.noteData] && daNote.canBeHit
					&& daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.blockHit) {
						goodNoteHit(daNote);
					}
				});
			}

		if (boyfriend.animation.curAnim != null && boyfriend.holdTimer > Conductor.stepCrochet * (0.0011 / FlxG.sound.music.pitch) * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.dance();
				//boyfriend.animation.curAnim.finish();
			}
		if (boyfriend2.animation.curAnim != null && boyfriend2.holdTimer > Conductor.stepCrochet * (0.0011 / FlxG.sound.music.pitch) * boyfriend2.singDuration && boyfriend2.animation.curAnim.name.startsWith('sing') && !boyfriend2.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend2.dance();
				//boyfriend2.animation.curAnim.finish();
			}
		}

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if((controls.controllerMode || strumsBlocked.contains(true)) && releaseArray.contains(true))
			for (i in 0...releaseArray.length)
				if(releaseArray[i] || strumsBlocked[i] == true)
					keyReleased(i);
	}

	function noteMiss(daNote:Note):Void { //You didn't hit the key and let it go offscreen, also used by Hurt Notes
		//Dupe note remove

		switch(daNote.noteType) {
			case 'corrupt-Note':
			if (stageUI == "Death") songMisses += FlxG.random.int(1, 2);

			if (stageUI != "Death") health -= 15;

			if (boyfriend.animOffsets.exists('hurt')) {
				boyfriend.playAnim('hurt', true);
				boyfriend.specialAnim = true;
			}

			camGame.flash(0x59DB0087, 0.6);

			case 'des-corrupt-Note':
				if (boyfriend.animOffsets.exists('hey')) {
					boyfriend.playAnim('hey', true);
					boyfriend.specialAnim = true;
				}
			
			case 'Glitch Note':
				FlxG.sound.play(Paths.sound('notes-sound/glitch'), 0.6);
				
				health -= 15;

				missionsStatus[1] = true;

			case 'nota de peligro':
				FlxG.sound.play(Paths.sound('notes-sound/sonido-de-disparo'));
				if (ClientPrefs.data.flashing == true) {
					FlxG.camera.flash(FlxColor.WHITE, 1);
				}

				if (doge == true){
					boyfriend.playAnim('dodge');
					boyfriend.specialAnim = true;
				}

				missionsStatus[1] = true;

				if (doge == false) {
				health = 0;

				boyfriend.playAnim('hurt', true);
				boyfriend.specialAnim = true;
				}

			dad.playAnim('singDOWN', true);
			dad.specialAnim = true;
		}

		notes.forEachAlive(function(note:Note) {
			if (daNote != note && daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 1) {
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		});
		
		noteMissCommon(daNote.noteData, daNote);
		var result:Dynamic = callOnLuas('noteMiss', [notes.members.indexOf(daNote), daNote.noteData, daNote.noteType, daNote.isSustainNote]);
		if(result != FunkinLua.Function_Stop && result != FunkinLua.Function_StopHScript && result != FunkinLua.Function_StopAll) callOnHScript('noteMiss', [daNote]);
	}

	function noteMissPress(direction:Int = 1):Void //You pressed a key when there was no notes to press for this key
	{
		if(ClientPrefs.data.ghostTapping) return; //fuck it

		noteMissCommon(direction);
		FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
		callOnScripts('noteMissPress', [direction]);
	}

	function noteMissCommon(direction:Int, note:Note = null)
	{

		moveCameraSection();
		// score and data
		var subtract:Float = 0.10;
		if(note != null) subtract = note.missHealth;

		if (note.noteType != 'des-corrupt-Note') health -= 5 * healthLoss;

		if (note.noteType != 'des-corrupt-Note') missNotesong += 1;

		if(instakillOnMiss)
		{
			vocals.volume = 0;
			doDeathCheck(true);
		}
		if (note.noteType != 'des-corrupt-Note') combo = 0;

		if (songMisses > 20 && stageUI == "Death") {
			vocals.volume = 0;
			doDeathCheck(true);
		}

		if (songMisses < 50 && stageUI != "Death") {
			instakillOnMiss = false;
		}

		if (songMisses > 50 && stageUI != "Death") {
			instakillOnMiss = true;
			//deathcause = 'Muchas fallas';
		}

		if(!practiceMode && note.noteType != 'des-corrupt-Note') songScore -= 10;
		if(!endingSong && note.noteType != 'des-corrupt-Note') songMisses++;
		totalPlayed++;
		if (note.noteType != 'des-corrupt-Note') {
			RecalculateRating(true);
		} else {
			RecalculateRating(false);
		}

		if (note.noteType != 'des-corrupt-Note') {
		// play character anims
		var char:Character = boyfriend;

		if (note.boy2) {
			char = boyfriend2;
		}
		if((note != null && note.gfNote) || (SONG.notes[curSection] != null && SONG.notes[curSection].gfSection)) char = gf;

		var charColor:FlxColor = 0x5BFF6666;
		var chars:Array<Character> = [boyfriend, gf];

		if (note.boy2) {
			var chars = [boyfriend2, gf];
		}

		if (note.double) {
			var chars = [boyfriend2, boyfriend, gf];
		}
		
			var suffix:String = '';
			if(note != null) suffix = note.animSuffix;

			
			if(!note.noMissAnimation) {//var animToPlay:String = singAnimations[Std.int(Math.abs(Math.min(singAnimations.length-1, direction)))] + 'miss' + suffix;
			var animToPlay:String = singAnimations[Std.int(Math.abs(Math.min(singAnimations.length-1, note.noteData)))];
			char.playAnim(animToPlay + note.animSuffix, true);

			for (who in chars)
				{
					who.color = charColor;
				}
			}
			
			if(char != gf && combo > 5 && gf != null && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
				gf.specialAnim = true;
			}

		vocals.volume = 0.3;

		FlxTween.tween(gf, {alpha: 0}, 0.5, {
			onComplete: function (twn:FlxTween) {

				for (who in chars)
					{
						who.color = FlxColor.WHITE;
					}
			}
		});
	}
	}

	function opponentNoteHit(note:Note):Void
	{
		//isDad = true;
		if (Paths.formatToSongPath(SONG.song) != 'tutorial')
			camZooming = true;

		if(note.noteType == 'Hey!' && dad.animOffsets.exists('hey')) {
			dad.playAnim('hey', true);
			dad.specialAnim = true;
			dad.heyTimer = 0.6;
		} else if(!note.noAnimation) {
			var altAnim:String = note.animSuffix;

			if (SONG.notes[curSection] != null)
			{
				if (SONG.notes[curSection].altAnim && !SONG.notes[curSection].gfSection) {
					altAnim = '-alt';
				}
			}

			var char:Character = dad;
			var animToPlay:String = singAnimations[Std.int(Math.abs(Math.min(singAnimations.length-1, note.noteData)))] + altAnim;
			if(note.gfNote) {
				char = gf;
			}

			if(char != null)
			{
				char.playAnim(animToPlay, true);
				char.holdTimer = 0;
			}
		}

		moveCameraSection();

			if (health >= note.hitHealth * healthLoss + note.hitHealth * healthLoss) {
			health -= note.hitHealth * healthLoss;
		}

		if (SONG.needsVoices)
			vocals.volume = 1;

		if (difficultysong == 'DEMENTIA') strumPlayAnim(false, Std.int(Math.abs(note.noteData)), Conductor.stepCrochet * 1.25 / 1000 / playbackRate, note.isSustainNote);
		strumPlayAnim(true, Std.int(Math.abs(note.noteData)), Conductor.stepCrochet * 1.25 / 1000 / playbackRate, note.isSustainNote);
		//strumPlayOponnentAnim(false, Std.int(Math.abs(note.noteData)), Conductor.stepCrochet * 1.25 / 1000 / playbackRate);
		note.hitByOpponent = true;

		var result:Dynamic = callOnLuas('opponentNoteHit', [notes.members.indexOf(note), Math.abs(note.noteData), note.noteType, note.isSustainNote]);
		if(result != FunkinLua.Function_Stop && result != FunkinLua.Function_StopHScript && result != FunkinLua.Function_StopAll) callOnHScript('opponentNoteHit', [note]);

		if (!note.isSustainNote)
		{
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!cpuControlled) hitnotesong += 1;

		if (!note.wasGoodHit)
		{
			if(cpuControlled && (note.ignoreNote || note.hitCausesMiss)) return;

			note.wasGoodHit = true;

			if(note.hitCausesMiss) {
				if(!note.noMissAnimation)
				{
					switch(note.noteType) {
						case 'corrupt-Note':
							//FlxG.sound.play(Paths.sound('notes-sound/cor'), 0.4);
							if (stageUI == "Death") songMisses -= FlxG.random.int(1, 2);

							if (stageUI != "Death") health += 15;

							camGame.flash(FlxColor.PINK, 0.6);

						case 'des-corrupt-Note':
							if (stageUI == "Death") songMisses += FlxG.random.int(1, 2);

							if (stageUI != "Death") health -= 15;

							if (boyfriend.animOffsets.exists('hurt')) {
								boyfriend.playAnim('hurt', true);
								boyfriend.specialAnim = true;
							}

							camGame.flash(0x59DB0087, 0.6);

						case 'Glitch Note':
							FlxG.sound.play(Paths.sound('notes-sound/glitch'), 0.4);
							
							health += 5;

						case 'Hurt Note': //Hurt note
								boyfriend.playAnim('dodge', true);
								boyfriend.specialAnim = true;

						case 'nota de peligro': //Fire Note
								FlxG.sound.play(Paths.sound('notes-sound/sonido-de-disparo'));
								if (ClientPrefs.data.flashing == true) {
									FlxG.camera.flash(FlxColor.WHITE, 1);
								}
								boyfriend.playAnim('dodge', true);
								boyfriend.specialAnim = true;
								dad.playAnim('singDOWN', true);
								dad.specialAnim = true;
					}
				}

				//if (!note.noAnimation) isBF = true;

				if (!note.isSustainNote)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
				return;
			}

			if (!note.isSustainNote)
			{
				combo++;
				if(combo > 9999) combo = 9999;
				popUpScore(note);
			}

			moveCameraSection();
			health += note.hitHealth * healthGain + 0.5;

			if(!note.noAnimation) {
				var animToPlay:String = singAnimations[Std.int(Math.abs(Math.min(singAnimations.length-1, note.noteData)))];

				var doubleTap:Bool = false;

				var char:Character = boyfriend;
				var char2:Character = boyfriend2;

				if (note.boy2) {
					char = boyfriend2;
				}
				if (note.double) {
					doubleTap = true;
				}
				
				if(char != null)
				{
					char.playAnim(animToPlay + note.animSuffix, true);
					char.holdTimer = 0;

					if (doubleTap) {
						char2.playAnim(animToPlay + note.animSuffix, true);
						char2.holdTimer = 0;
					}
					
					if(note.noteType == 'Hey!') {
						if(char.animOffsets.exists(animCheck)) {
							char.playAnim(animCheck, true);
							char.specialAnim = true;
							char.heyTimer = 0.6;
						}
					}

					if(note.noteType == 'Hey!') {
						if(char2.animOffsets.exists(animCheck)) {
							char2.playAnim(animCheck, true);
							char2.specialAnim = true;
							char2.heyTimer = 0.6;
						}
					}
				}
			}
			
			strumPlayAnim(false, Std.int(Math.abs(note.noteData)), Conductor.stepCrochet * 1.25 / 1000 / playbackRate, note.isSustainNote);
			if (difficultysong == 'DEMENTIA') strumPlayAnim(true, Std.int(Math.abs(note.noteData)), Conductor.stepCrochet * 1.25 / 1000 / playbackRate, note.isSustainNote);

			vocals.volume = 1;

			var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;
			
			var result:Dynamic = callOnLuas('goodNoteHit', [notes.members.indexOf(note), leData, leType, isSus]);
			if(result != FunkinLua.Function_Stop && result != FunkinLua.Function_StopHScript && result != FunkinLua.Function_StopAll) callOnHScript('goodNoteHit', [note]);

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	public function spawnNoteSplashOnNote(note:Note) {
		if(note != null) {
			var strum:StrumNote = playerStrums.members[note.noteData];
			if(strum != null)
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null) {
		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, note);
		grpNoteSplashes.add(splash);
	}

	override function destroy() {

		#if HSCRIPT_ALLOWED
		for (script in hscriptArray)
			if(script != null)
			{
				script.call('onDestroy');
				script.destroy();
				//script.destroy();
			}

		while (hscriptArray.length > 0)
			hscriptArray.pop();
		#end

		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		FlxAnimationController.globalSpeed = 1;
		FlxG.sound.music.pitch = 1;
		Note.globalRgbShaders = [];
		backend.NoteTypesConfig.clearNoteTypesData();
		instance = null;
		super.destroy();
	}

	public static function cancelMusicFadeTween() {
		if(FlxG.sound.music.fadeTween != null) {
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	var lastStepHit:Int = -1;
	override function stepHit()
	{
		if(FlxG.sound.music.time >= -ClientPrefs.data.noteOffset)
		{
			if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > (20 * playbackRate)
				|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > (20 * playbackRate)))
			{
				resyncVocals();
			}
		}

		super.stepHit();

		if(curStep == lastStepHit) {
			return;
		}

		lastStepHit = curStep;
		setOnScripts('curStep', curStep);
		callOnScripts('onStepHit');
	}

	var lastBeatHit:Int = -1;

	override function beatHit()
	{

		if(lastBeatHit >= curBeat) {
			//trace('BEAT HIT: ' + curBeat + ', LAST HIT: ' + lastBeatHit);
			return;
		}

		if (generatedMusic)
			notes.sort(FlxSort.byY, ClientPrefs.data.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);

		if (!endingSong) {
		if (gf != null && curBeat % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
			gf.dance();
		if (curBeat % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
			boyfriend.dance();
		if  (curBeat % boyfriend2.danceEveryNumBeats == 0 && boyfriend2.animation.curAnim != null && !boyfriend2.animation.curAnim.name.startsWith('sing') && !boyfriend2.stunned)
			boyfriend2.dance();
		if (curBeat % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
			dad.dance();
	}

		super.beatHit();
		lastBeatHit = curBeat;

		setOnScripts('curBeat', curBeat);
		callOnScripts('onBeatHit');
	}

	function hitNotesong() {
		if (!SONG.beatSectionAuto) {
		if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.data.camZooms)
			{
				FlxG.camera.zoom += 0.015 * camZoomingMult;
				camHUD.zoom += 0.03 * camZoomingMult;
			}
			stagesFunc(function(stage:BaseStage) stage.additionalEffects());
		}
	}

	override function sectionHit()
	{
		if (SONG.beatSectionAuto) stagesFunc(function(stage:BaseStage) stage.additionalEffects());
		
		if (SONG.notes[curSection] != null)
		{
			if (SONG.notes[curSection].isbf && !SONG.notes[curSection].isdad) {
				isBF = true;
				isDad = false;
			} else if (!SONG.notes[curSection].isbf && SONG.notes[curSection].isdad) {
				isDad = true;
				isBF = false;
			} else if (SONG.notes[curSection].isbf && SONG.notes[curSection].isdad) {
				isDad = true;
				isBF = true;
			} else if (!SONG.notes[curSection].isbf && !SONG.notes[curSection].isdad) {
				isDad = false;
				isBF = false;
			}

			if (generatedMusic && !endingSong && !isCameraOnForcedPos)
				moveCameraSection();

			if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.data.camZooms && SONG.beatSectionAuto)
			{
				FlxG.camera.zoom += 0.015 * camZoomingMult;
				camHUD.zoom += 0.03 * camZoomingMult;
			}

			if (SONG.notes[curSection].changeBPM)
			{
				Conductor.bpm = SONG.notes[curSection].bpm;
				setOnScripts('curBpm', Conductor.bpm);
				setOnScripts('crochet', Conductor.crochet);
				setOnScripts('stepCrochet', Conductor.stepCrochet);
			}
			setOnScripts('mustHitSection', SONG.notes[curSection].mustHitSection);
			setOnScripts('altAnim', SONG.notes[curSection].altAnim);
			setOnScripts('gfSection', SONG.notes[curSection].gfSection);
		}
		super.sectionHit();
		
		setOnScripts('curSection', curSection);
		callOnScripts('onSectionHit');
	}

	#if HSCRIPT_ALLOWED
	public function startHScriptsNamed(scriptFile:String)
	{
		#if MODS_ALLOWED
		var scriptToLoad:String = Paths.modFolders(scriptFile);
		if(!FileSystem.exists(scriptToLoad))
			scriptToLoad = Paths.getSharedPath(scriptFile);
		#else
		var scriptToLoad:String = Paths.getSharedPath(scriptFile);
		#end

		if(FileSystem.exists(scriptToLoad))
		{
			if (SScript.global.exists(scriptToLoad)) return false;

			initHScript(scriptToLoad);
			return true;
		}
		return false;
	}

	public function initHScript(file:String)
	{
		try
		{
			var newScript:HScript = new HScript(null, file);
			if(newScript.parsingException != null)
			{
				addTextToDebug('ERROR ON LOADING: ${newScript.parsingException.message}', FlxColor.RED);
				newScript.destroy();
				return;
			}

			hscriptArray.push(newScript);
			if(newScript.exists('onCreate'))
			{
				var callValue = newScript.call('onCreate');
				if(!callValue.succeeded)
				{
					for (e in callValue.exceptions)
					{
						if (e != null)
						{
							var len:Int = e.message.indexOf('\n') + 1;
							if(len <= 0) len = e.message.length;
								addTextToDebug('ERROR ($file: onCreate) - ${e.message.substr(0, len)}', FlxColor.RED);
						}
					}

					newScript.destroy();
					hscriptArray.remove(newScript);
					trace('failed to initialize tea interp!!! ($file)');
				}
				else trace('initialized tea interp successfully: $file');
			}

		}
		catch(e)
		{
			var len:Int = e.message.indexOf('\n') + 1;
			if(len <= 0) len = e.message.length;
			addTextToDebug('ERROR - ' + e.message.substr(0, len), FlxColor.RED);
			var newScript:HScript = cast (SScript.global.get(file), HScript);
			if(newScript != null)
			{
				newScript.destroy();
				hscriptArray.remove(newScript);
			}
		}
	}
	#end

//	pause

	#if (LUA_ALLOWED || HSCRIPT_ALLOWED)
	public function addTextToDebug(text:String, color:FlxColor) {
		var newText:psychlua.DebugLuaText = luaDebugGroup.recycle(psychlua.DebugLuaText);
		newText.text = text;
		newText.color = color;
		newText.disableTime = 6;
		newText.alpha = 1;
		newText.setPosition(10, 8 - newText.height);

		luaDebugGroup.forEachAlive(function(spr:psychlua.DebugLuaText) {
			spr.y += newText.height + 2;
		});
		luaDebugGroup.add(newText);

		Sys.println(text);
	}
	#end



	public function callOnScripts(funcToCall:String, args:Array<Dynamic> = null, ignoreStops = false, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
		var returnVal:Dynamic = psychlua.FunkinLua.Function_Continue;
		if(args == null) args = [];
		if(exclusions == null) exclusions = [];
		if(excludeValues == null) excludeValues = [psychlua.FunkinLua.Function_Continue];

		var result:Dynamic = callOnLuas(funcToCall, args, ignoreStops, exclusions, excludeValues);
		if(result == null || excludeValues.contains(result)) result = callOnHScript(funcToCall, args, ignoreStops, exclusions, excludeValues);
		return result;
	}

	public function callOnLuas(funcToCall:String, args:Array<Dynamic> = null, ignoreStops = false, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
		var returnVal:Dynamic = FunkinLua.Function_Continue;
		return returnVal;
	}
	
	public function callOnHScript(funcToCall:String, args:Array<Dynamic> = null, ?ignoreStops:Bool = false, exclusions:Array<String> = null, excludeValues:Array<Dynamic> = null):Dynamic {
		var returnVal:Dynamic = psychlua.FunkinLua.Function_Continue;

		#if HSCRIPT_ALLOWED
		if(exclusions == null) exclusions = new Array();
		if(excludeValues == null) excludeValues = new Array();
		excludeValues.push(psychlua.FunkinLua.Function_Continue);

		var len:Int = hscriptArray.length;
		if (len < 1)
			return returnVal;
		for(i in 0...len)
		{
			var script:HScript = hscriptArray[i];
			if(script == null || !script.exists(funcToCall) || exclusions.contains(script.origin))
				continue;

			var myValue:Dynamic = null;
			try
			{
				var callValue = script.call(funcToCall, args);
				if(!callValue.succeeded)
				{
					var e = callValue.exceptions[0];
					if(e != null)
						FunkinLua.luaTrace('ERROR (${script.origin}: ${callValue.calledFunction}) - ' + e.message.substr(0, e.message.indexOf('\n')), true, false, FlxColor.RED);
				}
				else
				{
					myValue = callValue.returnValue;
					if((myValue == FunkinLua.Function_StopHScript || myValue == FunkinLua.Function_StopAll) && !excludeValues.contains(myValue) && !ignoreStops)
					{
						returnVal = myValue;
						break;
					}
					
					if(myValue != null && !excludeValues.contains(myValue))
						returnVal = myValue;
				}
			}
		}
		#end

		return returnVal;
	}

	public function setOnScripts(variable:String, arg:Dynamic, exclusions:Array<String> = null) {
		if(exclusions == null) exclusions = [];
		setOnHScript(variable, arg, exclusions);
	}

	public function setOnHScript(variable:String, arg:Dynamic, exclusions:Array<String> = null) {
		#if HSCRIPT_ALLOWED
		if(exclusions == null) exclusions = [];
		for (script in hscriptArray) {
			if(exclusions.contains(script.origin))
				continue;

			script.set(variable, arg);
		}
		#end
	}

	function strumPlayAnim(isDad:Bool, id:Int, time:Float, sustance:Bool) {
		var spr:StrumNote = null;
		var pos:Float = ClientPrefs.data.downScroll ? (FlxG.height - 150) : 50;
		var posx:Float = ClientPrefs.data.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X;

		if(isDad) {
			spr = opponentStrums.members[id];
		} else {
			spr = playerStrums.members[id];
		}

		if (difficultysong == 'DEMENTIA') {
			opponentStrums.members[id].alpha = 0.6;
			opponentStrums.members[id].x = playerStrums.members[id].x;
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}

		if (!ClientPrefs.data.noneAnimations) {
		if(spr != null) {
			if (!sustance) {
			if (ClientPrefs.data.downScroll == true) FlxTween.tween(spr, {y: pos - 15}, 0.2, {
				type: PERSIST,
				onComplete: function (twn:FlxTween) {
					FlxTween.tween(spr, {y: pos}, 0.1);
				}
			});
			if (ClientPrefs.data.downScroll == false) FlxTween.tween(spr, {y: pos + 15}, 0.2, {
				type: PERSIST,
				onComplete: function (twn:FlxTween) {
					FlxTween.tween(spr, {y: pos}, 0.1);
				}
			});
		} else {
			FlxTween.cancelTweensOf(spr);
			if (ClientPrefs.data.downScroll == true) FlxTween.tween(spr, {y: pos - 15}, 0.2, {
				type: PERSIST,
				onComplete: function (twn:FlxTween) {
					FlxTween.tween(spr, {y: pos}, 0.1);
				}
			});
			if (ClientPrefs.data.downScroll == false) FlxTween.tween(spr, {y: pos + 15}, 0.2, {
				type: PERSIST,
				onComplete: function (twn:FlxTween) {
					FlxTween.tween(spr, {y: pos}, 0.1);
				}
			});
		}
		}
	}
	}

	function strumPlayOponnentAnim(isDad:Bool, id:Int, time:Float) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = opponentStrums.members[id];
		} else {
			spr = playerStrums.members[id];
		}
	}

	public var ratingName:String = '?';
	public var ratingPercent:Float;
	public var ratingFC:String;
	public function RecalculateRating(badHit:Bool = false) {
		setOnScripts('score', songScore);
		setOnScripts('misses', songMisses);
		setOnScripts('hits', songHits);
		setOnScripts('combo', combo);

		/*
		*/

		var ret:Dynamic = callOnScripts('onRecalculateRating', null, true);
		if(ret != FunkinLua.Function_Stop)
		{
			ratingName = '?';
			if(totalPlayed != 0) //Prevent divide by 0
			{
				// Rating Percent
				ratingPercent = Math.min(1, Math.max(0, totalNotesHit / totalPlayed));
				//trace((totalNotesHit / totalPlayed) + ', Total: ' + totalPlayed + ', notes hit: ' + totalNotesHit);

				// Rating Name
				if (ClientPrefs.data.language == 'Inglish') {
				ratingName = ratingStuffINGLISH[ratingStuffINGLISH.length-1][0]; //Uses last string
				if(ratingPercent < 1)
					for (i in 0...ratingStuffINGLISH.length-1)
						if(ratingPercent < ratingStuffINGLISH[i][1])
						{
							ratingName = ratingStuffINGLISH[i][0];
							break;
						}
				} else if (ClientPrefs.data.language == 'Spanish') {
					ratingName = ratingStuffESPANISH[ratingStuffESPANISH.length-1][0]; //Uses last string
					if(ratingPercent < 1)
						for (i in 0...ratingStuffESPANISH.length-1)
							if(ratingPercent < ratingStuffESPANISH[i][1])
							{
								ratingName = ratingStuffESPANISH[i][0];
								break;
							}
				} else if (ClientPrefs.data.language == 'Portuguese') {
					ratingName = ratingStuffPORTUGUES[ratingStuffPORTUGUES.length-1][0]; //Uses last string
					if(ratingPercent < 1)
						for (i in 0...ratingStuffPORTUGUES.length-1)
							if(ratingPercent < ratingStuffPORTUGUES[i][1])
							{
								ratingName = ratingStuffPORTUGUES[i][0];
								break;
							}
				}

			}
			fullComboFunction();
		}
		updateScore(badHit); // score will only update after rating is calculated, if it's a badHit, it shouldn't bounce -Ghost
		setOnScripts('rating', ratingPercent);
		setOnScripts('ratingName', ratingName);
		setOnScripts('ratingFC', ratingFC);
	}

	function fullComboUpdate()
	{
		var sicks:Int = ratingsData[0].hits;
		var goods:Int = ratingsData[1].hits;
		var bads:Int = ratingsData[2].hits;
		var shits:Int = ratingsData[3].hits;

		ratingFC = 'Clear';
		if(songMisses < 1)
		{
			if (bads > 0 || shits > 0) ratingFC = 'FC';
			else if (goods > 0) ratingFC = 'GFC';
			else if (sicks > 0) ratingFC = 'SFC';
		}
		else if (songMisses < 10)
			ratingFC = 'SDCB';
	}

	#if (!flash && sys)
	public var runtimeShaders:Map<String, Array<String>> = new Map<String, Array<String>>();
	public function createRuntimeShader(name:String):FlxRuntimeShader
	{
		if(!ClientPrefs.data.shaders) return new FlxRuntimeShader();

		#if (!flash && MODS_ALLOWED && sys)
		if(!runtimeShaders.exists(name) && !initLuaShader(name))
		{
			FlxG.log.warn('Shader $name is missing!');
			return new FlxRuntimeShader();
		}

		var arr:Array<String> = runtimeShaders.get(name);
		return new FlxRuntimeShader(arr[0], arr[1]);
		#else
		FlxG.log.warn("Platform unsupported for Runtime Shaders!");
		return null;
		#end
	}

	public function initLuaShader(name:String, ?glslVersion:Int = 120)
	{
		if(!ClientPrefs.data.shaders) return false;

		#if (MODS_ALLOWED && !flash && sys)
		if(runtimeShaders.exists(name))
		{
			FlxG.log.warn('Shader $name was already initialized!');
			return true;
		}

		for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'shaders/'))
		{
			var frag:String = folder + name + '.frag';
			var vert:String = folder + name + '.vert';
			var found:Bool = false;
			if(FileSystem.exists(frag))
			{
				frag = File.getContent(frag);
				found = true;
			}
			else frag = null;

			if(FileSystem.exists(vert))
			{
				vert = File.getContent(vert);
				found = true;
			}
			else vert = null;

			if(found)
			{
				runtimeShaders.set(name, [frag, vert]);
				//trace('Found shader $name!');
				return true;
			}
		}
			#if (LUA_ALLOWED || HSCRIPT_ALLOWED)
			addTextToDebug('Missing shader $name .frag AND .vert files!', FlxColor.RED);
			#else
			FlxG.log.warn('Missing shader $name .frag AND .vert files!');
			#end
		#else
		FlxG.log.warn('This platform doesn\'t support Runtime Shaders!');
		#end
		return false;
	}
	#end
}