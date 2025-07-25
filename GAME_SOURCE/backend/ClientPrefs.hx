package backend;

import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepadInputID;

import states.inicio.StartingState;

// Add a variable here and it will get automatically saved
class SaveVariables {
	//Originals - GamePlay
	public var downScroll:Bool = false;
	public var middleScroll:Bool = true;
	public var opponentStrums:Bool = true;
	public var noteSkin:String = 'Default';
	public var splashSkin:String = 'Psych';
	public var splashAlpha:Float = 0.6;
	public var cacheOnGPU:Bool = #if !switch false #else true #end; //From Stilic
	public var camZooms:Bool = true;
	public var hideHud:Bool = false;
	public var ghostTapping:Bool = true;
	public var timeBarType:String = 'Song Name';
	public var scoreZoom:Bool = true;
	public var noReset:Bool = false;
	public var healthBarAlpha:Float = 1;
	public var hitsoundVolume:Float = 0;
	public var pauseMusic:String = 'Tea Time';

	public var resizeAuto:Bool = true;

	//Originals - Visuals
	public var antialiasing:Bool = true;
	public var lowQuality:Bool = false;
	public var shaders:Bool = true;
	
	//Originals - Window
	public var showFPS:Bool = true;
	public var flashing:Bool = true;
	public var autoPause:Bool = true;
	public var framerate:Int = 60;

	//System Versions
	public var endingCorruprion:String = '5.0';
	public var endingEngine:String = '7.4';
	public var pathVersion:String = '1.0';
	public var username:String = 'User';
	// [Nombre de la Temporada, version de la temporada];
	public var tempName:Array<String> = ['Dark Road', '5.0'];

	//Initial Settings
	public var Welcome:Bool = false;
	public var resolutionQuality:String = 'Medium';
	public var Update_Support:Bool = false;
	public var SpritesFPS:Int = 24;
	public var InitialSettings:Bool = false;
	public var InternetStatus:String = 'Disconnect';
	public var demo:Bool = true;
	public var downloadMode:Bool = false;

	//Menu
	public var musicState:String = 'Hallucination';
	public var notivisible:Bool = true;
	public var timetrans:Int = 1;
	public var language:String = 'Inglish';
	public var Internet:String = 'disabled';
	public var recordoptimization:String = 'Disabled';
	public var music:String = 'TerminalMusic';

	//GamePlay
	public var concetration:Bool = false;
	public var overlays:Bool = true;
	public var dodge:Bool = true;
	public var alphahud:Bool = true;

	//Window
	public var fullyscreen:Bool = false;
	public var width:Int = 1280;
	public var height:Int = 720;
	public var fullscreen:Bool = false;
	public var opacity_mouse:Float = 1;
	public var windowOpacity:Float = 1;
	public var framerateDraw:Int = 60;
	public var framerateUpdate:Int = 60;

	public var resolutionWindowsWidth:Float = 1280;
	public var resolutionWindowsHeight:Float = 720;

	//Plugins
	public var colorplus:Bool = false;
	public var moredebug:Bool = false;
	public var settingsmax:Bool = false;

	//Optimizations
	public var noneAnimations:Bool = false;
	public var noneBGAnimated:Bool = false;
	public var noneFixeds:Bool = false;
	public var movedComponents:Bool = false;
	public var updateState:Bool = false;
	public var noneNet:Bool = false;
	public var nonePost:Bool = false;
	public var noneMods:Bool = false;
	public var nonePlugins:Bool = false;
	public var startLoad:Bool = true;
	public var loadMethor:String = 'RAM';

	public var qualityLOW:Bool = false;

	//UI
	public var R:Int = 0;
	public var G:Int = 0;
	public var B:Int = 0;
	public var A:Int = 255;

	public var ResolutionUI:String = 'NORMAL';

	public var animationsMODE:String = 'neutral';
	public var animationsVEL:Float = 0.1;
	
	public var InputUI:String = 'Mouse/Keybord/GamePad/Touch';

	public var CORDURE:Int = 100;

	public var keepNotifications:Bool = false;

	//IA
	public var ibl:Float = FlxMath.roundDecimal(FlxG.random.float(0.01, 120), 3);
	public var gpt:String = 'GPT3.5';
	public var dll:String = 'GOOD';
	public var internetGPT:Bool = false;

	//Es la Accion o Evento que se esta cargando/buscando/eliminando o Añadiendo
	public var Data:Dynamic = '?';

	//public var updateSettings:Bool = false;

	//Others
	public var coins:Int = 0;
	public var start:Bool = true;
	public var consoleHistorial:String = '';

	//Online
	public var userName:String = '';
	public var password:String = '';
	public var KeyScan:String = '';

	public var ID:String = '';

	public var alwaysLOGIN:Bool = false;

	//Estadistics
	public var hitNote:Int = 0;
	public var Score:Int = 0;
	public var Misses:Int = 0;
	public var Deaths:Int = 0;
	public var winCoins:Int = 0;
	//DIA - MES - AÑO - HORA - MINUTOS - SEGUNDOS
	public var Date:Array<String> = ['', '', '', '', '', ''];
	//Windows
	public var openWin:Int = 0;
	public var clicks:Int = 0;
	public var keysPressed:Int = 0;
	public var fpsMAX:Int = 0;
	public var memoryMAX:Int = 0;

	public var primera_vez:Bool = true;

	//Support
	public var deleteCache:Bool = false;
	public var skipTItle:Bool = false;
	public var blockedIA:Bool = false;
	public var typeLOGIN:String = 'SERVER';
	public var reportProblem:Bool = true;
	public var preloadFULLHD:Bool = false;
	public var reportLOGIN:Bool = false;


	//API INFO

	

	//KBS
	public var cacheSaveKbs:Float = 0;

	public var noteOffset:Int = 0;
	public var arrowRGB:Array<Array<FlxColor>> = [
		[0xFFC24B99, 0xFFFFFFFF, 0xFF3C1F56],
		[0xFF00FFFF, 0xFFFFFFFF, 0xFF1542B7],
		[0xFF12FA05, 0xFFFFFFFF, 0xFF0A4447],
		[0xFFF9393F, 0xFFFFFFFF, 0xFF651038]];
	public var arrowRGBPixel:Array<Array<FlxColor>> = [
		[0xFFE276FF, 0xFFFFF9FF, 0xFF60008D],
		[0xFF3DCAFF, 0xFFF4FFFF, 0xFF003060],
		[0xFF71E300, 0xFFF6FFE6, 0xFF003100],
		[0xFFFF884E, 0xFFFFFAF5, 0xFF6C0000]];

	public var checkForUpdates:Bool = true;
	public var comboStacking:Bool = true;
	public var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative', 
		// anyone reading this, amod is multiplicative speed mod, cmod is constant speed mod, and xmod is bpm based speed mod.
		// an amod example would be chartSpeed * multiplier
		// cmod would just be constantSpeed = chartSpeed
		// and xmod basically works by basing the speed on the bpm.
		// iirc (beatsPerSecond * (conductorToNoteDifference / 1000)) * noteSize (110 or something like that depending on it, prolly just use note.height)
		// bps is calculated by bpm / 60
		// oh yeah and you'd have to actually convert the difference to seconds which I already do, because this is based on beats and stuff. but it should work
		// just fine. but I wont implement it because I don't know how you handle sustains and other stuff like that.
		// oh yeah when you calculate the bps divide it by the songSpeed or rate because it wont scroll correctly when speeds exist.
		// -kade
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'opponentplay' => false
	];

	public var comboOffset:Array<Int> = [0, 0, 0, 0];
	public var ratingOffset:Int = 0;
	public var sickWindow:Int = 45;
	public var goodWindow:Int = 90;
	public var badWindow:Int = 135;
	public var safeFrames:Float = 10;
	public var discordRPC:Bool = true;

	public function new()
	{
		//Why does haxe needs this again?
	}
}

class ClientPrefs {
	public static var data:SaveVariables = null;
	public static var defaultData:SaveVariables = null;

	//Every key has two binds, add your key bind down here and then add your control on options/ControlsSubState.hx and Controls.hx
	public static var keyBinds:Map<String, Array<FlxKey>> = [
		//Key Bind, Name for ControlsSubState
		'note_up'		=> [W, UP],
		'note_left'		=> [A, LEFT],
		'note_down'		=> [S, DOWN],
		'note_right'	=> [D, RIGHT],
		
		'ui_up'			=> [W, UP],
		'ui_left'		=> [A, LEFT],
		'ui_down'		=> [S, DOWN],
		'ui_right'		=> [D, RIGHT],
		
		'accept'		=> [SPACE, ENTER],
		'back'			=> [BACKSPACE, ESCAPE],
		'pause'			=> [ENTER, ESCAPE],
		'reset'			=> [R],
		
		'volume_mute'	=> [ZERO],
		'volume_up'		=> [NUMPADPLUS, PLUS],
		'volume_down'	=> [NUMPADMINUS, MINUS],
		
		'debug_1'		=> [SEVEN],
		'debug_2'		=> [EIGHT]
	];
	public static var gamepadBinds:Map<String, Array<FlxGamepadInputID>> = [
		'note_up'		=> [DPAD_UP, Y],
		'note_left'		=> [DPAD_LEFT, X],
		'note_down'		=> [DPAD_DOWN, A],
		'note_right'	=> [DPAD_RIGHT, B],
		
		'ui_up'			=> [DPAD_UP, LEFT_STICK_DIGITAL_UP],
		'ui_left'		=> [DPAD_LEFT, LEFT_STICK_DIGITAL_LEFT],
		'ui_down'		=> [DPAD_DOWN, LEFT_STICK_DIGITAL_DOWN],
		'ui_right'		=> [DPAD_RIGHT, LEFT_STICK_DIGITAL_RIGHT],
		
		'accept'		=> [A, START],
		'back'			=> [B],
		'pause'			=> [START],
		'reset'			=> [BACK]
	];
	public static var defaultKeys:Map<String, Array<FlxKey>> = null;
	public static var defaultButtons:Map<String, Array<FlxGamepadInputID>> = null;

	public static function resetKeys(controller:Null<Bool> = null) //Null = both, False = Keyboard, True = Controller
	{
		if(controller != true)
		{
			for (key in keyBinds.keys())
			{
				if(defaultKeys.exists(key))
					keyBinds.set(key, defaultKeys.get(key).copy());
			}
		}
		if(controller != false)
		{
			for (button in gamepadBinds.keys())
			{
				if(defaultButtons.exists(button))
					gamepadBinds.set(button, defaultButtons.get(button).copy());
			}
		}
	}

	public static function clearInvalidKeys(key:String) {
		var keyBind:Array<FlxKey> = keyBinds.get(key);
		var gamepadBind:Array<FlxGamepadInputID> = gamepadBinds.get(key);
		while(keyBind != null && keyBind.contains(NONE)) keyBind.remove(NONE);
		while(gamepadBind != null && gamepadBind.contains(NONE)) gamepadBind.remove(NONE);
	}

	public static function loadDefaultKeys() {
		defaultKeys = keyBinds.copy();
		defaultButtons = gamepadBinds.copy();
	}

	public static function saveSettings() {
		for (key in Reflect.fields(data)) {
			//trace('saved variable: $key');
			Reflect.setField(FlxG.save.data, key, Reflect.field(data, key));
		}
//		FlxG.save.data.achievementsMap = Achievements.achievementsMap;
	//	FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;
		FlxG.save.flush();

		//Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		var save:FlxSave = new FlxSave();
		save.bind('controls_v3', CoolUtil.getSavePath());
		save.data.keyboard = keyBinds;
		save.data.gamepad = gamepadBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs() {
		if(data == null) data = new SaveVariables();
		if(defaultData == null) defaultData = new SaveVariables();

		for (key in Reflect.fields(data)) {
			if (key != 'gameplaySettings' && Reflect.hasField(FlxG.save.data, key)) {
				//trace('loaded variable: $key');
				Reflect.setField(data, key, Reflect.field(FlxG.save.data, key));
			}
		}
		
		if(Main.fpsVar != null) {
			Main.fpsVar.visible = data.showFPS;
		}

		#if desktop
		FlxG.autoPause = ClientPrefs.data.autoPause;
		#end

		if(data.framerate > FlxG.drawFramerate) {
			FlxG.updateFramerate = data.framerate;
			FlxG.drawFramerate = data.framerate;
		} else {
			FlxG.drawFramerate = data.framerate;
			FlxG.updateFramerate = data.framerate;
		}

		if(FlxG.save.data.gameplaySettings != null) {
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
				data.gameplaySettings.set(name, value);
		}
		
		// flixel automatically saves your volume!
		if(FlxG.save.data.volume != null)
			FlxG.sound.volume = FlxG.save.data.volume;
		if (FlxG.save.data.mute != null)
			FlxG.sound.muted = FlxG.save.data.mute;

		#if desktop
		DiscordClient.check();
		#end

		// controls on a separate save file
		var save:FlxSave = new FlxSave();
		save.bind('controls_v3', CoolUtil.getSavePath());
		if(save != null)
		{
			if(save.data.keyboard != null) {
				var loadedControls:Map<String, Array<FlxKey>> = save.data.keyboard;
				for (control => keys in loadedControls) {
					if(keyBinds.exists(control)) keyBinds.set(control, keys);
				}
			}
			if(save.data.gamepad != null) {
				var loadedControls:Map<String, Array<FlxGamepadInputID>> = save.data.gamepad;
				for (control => keys in loadedControls) {
					if(gamepadBinds.exists(control)) gamepadBinds.set(control, keys);
				}
			}
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic = null, ?customDefaultValue:Bool = false):Dynamic {
		if(!customDefaultValue) defaultValue = defaultData.gameplaySettings.get(name);
		return /*PlayState.isStoryMode ? defaultValue : */ (data.gameplaySettings.exists(name) ? data.gameplaySettings.get(name) : defaultValue);
	}
}
