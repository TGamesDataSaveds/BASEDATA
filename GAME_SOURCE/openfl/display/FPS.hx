package openfl.display;

import flixel.system.scaleModes.RatioScaleMode;
import openfl.system.Capabilities;
import states.MainMenuState;
import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.sound.FlxSound;
import flixel.input.FlxKeyManager;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end

#if openfl
import openfl.system.System;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	var time:FlxTimer;
	public var fullScreen:Bool = false;

	public static var activeStatus:Bool = false;

	var curColor:Bool = false;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function onColor() {
		if (curColor) {
		textColor = FlxColor.BLACK;
		curColor = false;
		} else {
		textColor = FlxColor.WHITE;
		curColor = true;
		}
	}

	public function new(x:Float = 10, y:Float = 10, ?color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("vcx", 14, color);
		autoSize = LEFT;
		multiline = true;
		text = "";

		cacheCount = 0;
		currentTime = 0;
		times = [];

		FlxG.stage.addEventListener(Event.CLOSE, onClose);

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}

	function onClose(event:Event) {

		Lib.application.window.alert("WINDOWS IS CLOSED", "WARNING");
		event.preventDefault();
	}

	function resolutionFull(active:Bool) {
		switch (ClientPrefs.data.resolutionQuality) {
			case "Low":
				Lib.current.stage.quality = StageQuality.LOW;
			case "Medium":
				Lib.current.stage.quality = StageQuality.MEDIUM;
			case "High":
				Lib.current.stage.quality = StageQuality.HIGH;
			case "Ultra":
				Lib.current.stage.quality = StageQuality.BEST;
			default:
				Lib.current.stage.quality = StageQuality.MEDIUM;
		}

		if (active == false) {
		var scaleMode = new RatioScaleMode();
		scaleMode.gameSize.set(1280, 720);
		FlxG.scaleMode = scaleMode;

		Lib.current.stage.scaleMode = StageScaleMode.NO_BORDER;
    	Lib.current.stage.align = StageAlign.TOP_LEFT;
		} else {
		var scaleMode = new RatioScaleMode();
		scaleMode.gameSize.set(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
		FlxG.scaleMode = scaleMode;

		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
    	Lib.current.stage.align = StageAlign.TOP_LEFT;
		}
	}

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		currentTime += deltaTime;
		times.push(currentTime);

		var keyMode:Int = FlxG.keys.firstJustPressed();
		if (PlayState.stageUI == "pixel") {
			defaultTextFormat = new TextFormat("pixel.otf", 8);
		}
		if (PlayState.stageUI != "pixel") {
			defaultTextFormat = new TextFormat("", 14);
		}

		if (FlxG.keys.justPressed.F11) {
			if (fullScreen) {
				fullScreen = false;
				FlxG.fullscreen = false;
				resolutionFull(false);
			} else {
				fullScreen = true;
				FlxG.fullscreen = true;
				resolutionFull(true);
			}
		}

		var state:String = FlxG.state.toString();

		if (keyMode != -1 && PlayState.statusGame == false) {
			FlxG.sound.play(Paths.sound('key'), 0.3);
			ClientPrefs.data.keysPressed += 1;
		}

		if (PlayState.stageUI == "pixel") {
			defaultTextFormat = new TextFormat("pixel.otf", 8);
		} else if (PlayState.stageUI != "pixel") {
			defaultTextFormat = new TextFormat(Paths.font("new/BUND.otf"), 14);
		}

		//HAY QUE AJUSTAR ESTO PARA QUE SOLO VERIFIQUE SI ES NECESARIO, SINO CONSUMIRA MUCHOS RECURSOS
		ClientPrefs.data.Date = [Std.string(Date.now().getDay()), Std.string(Date.now().getMonth()), Std.string(Date.now().getFullYear()), Std.string(Date.now().getHours()), Std.string(Date.now().getMinutes()), Std.string(Date.now().getSeconds())]; 

		if (FlxG.keys.justPressed.PLUS) {
			FlxG.sound.changeVolume(0.1);
		} else if (FlxG.keys.justPressed.MINUS) {
			FlxG.sound.changeVolume(-0.1);
		}

		if (activeStatus == false) {
			if (FlxG.keys.pressed.INSERT) {
				MusicBeatState.openSubStateY(new openfl.display.Console());
				activeStatus = true;
			}
		}
		if(FlxG.mouse.justPressed || FlxG.mouse.justPressedRight || FlxG.mouse.justPressedMiddle) {
			FlxG.sound.play(Paths.sound('click'), 1);
			ClientPrefs.data.clicks += 1;
        }

		if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.ENTER) {
			Sys.exit(1);
			trace('Exit Mode');
			//AVECES DABA ERROR CUANDO SE APLICABA ESTAS TECLAS POR LO QUE SE EJECUTARA UN SALIR DEL JUEGO PARA EVITAR PROBLEMAS FUTUROS
		}

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}

		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentFPS > ClientPrefs.data.fpsMAX) {
			ClientPrefs.data.fpsMAX = currentFPS;
			trace('!!NUEVO NIVEL DE FPS ALCANZADO!!');
		}
		if (currentFPS > ClientPrefs.data.framerate) currentFPS = ClientPrefs.data.framerate;

		if (currentCount != cacheCount)
		{
			onColor();

			text = 'FPS: ${currentFPS}[${FlxG.random.int(0, 99)}]';

			if (currentFPS <= ClientPrefs.data.framerate / 2)
			{
				textColor = 0xFFFF0000;
			}

			#if (gl_stats && !disable_cffi && (!html5 || !canvas))
			text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
			text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
			text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);
			#end

			text += "\n";
		}

		cacheCount = currentCount;
	}
}
