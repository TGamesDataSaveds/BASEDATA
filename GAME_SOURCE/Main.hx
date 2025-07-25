/*
//Anterior Codigo
package;

import openfl.system.Capabilities;
import states.MainMenuState;
import flixel.graphics.FlxGraphic;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.MEMORY;
import openfl.display.COINS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import lime.app.Application;
import states.inicio.StartingState;
import backend.ClientPrefs;

#if linux
import lime.graphics.Image;
#end

import openfl.system.System;

//crash handler stuff
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end

#if linux
@:cppInclude('./external/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end

class Main extends Sprite
{
	var game = {
		width: 1280, // WINDOW width
		height: 720, // WINDOW height
		initialState: StartingState, // initial game state
		zoom: 1.0, // game state bounds
		framerate: 60, // default framerate
		skipSplash: true, // if the default flixel splash screen should be skipped
		startFullscreen: false // if the game should start at fullscreen mode
	};

	public static var fpsVar:FPS;
	public static var memoryVar:MEMORY;
	public static var coinVar:COINS;

	public static var endingCorruption:String;
	public static var endingEngine:String;
	public static var pathVersion:String;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		Controls.instance = new Controls();
		ClientPrefs.loadDefaultKeys();
		#if ACHIEVEMENTS_ALLOWED Achievements.load(); #end
		addChild(new FlxGame(game.width, game.height, game.initialState, #if (flixel < "5.00") .game.zoom, #end game.framerate, game.framerate, game.skipSplash, game.startFullscreen));

		if (ClientPrefs.data.noneAnimations) {
		coinVar = new COINS(10, 3, 0xFFFFFF);
		memoryVar = new MEMORY(10, 3, 0xFFFFFF);
		fpsVar = new FPS(10, 3, 0xFFFFFF);
		} else {
		coinVar = new COINS(-60, 3, 0xFFFFFF);
		coinVar.alpha = 0;
		memoryVar = new MEMORY(-60, 3, 0xFFFFFF);
		memoryVar.alpha = 0;
		fpsVar = new FPS(-60, 3, 0xFFFFFF);
		fpsVar.alpha = 0;
		}
		addChild(coinVar);
		addChild(memoryVar);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

		if (ClientPrefs.data.Welcome == false) backend.MusicBeatState.updatestate("Loading Game...", ClientPrefs.data.language);

		FlxG.updateFramerate = ClientPrefs.data.framerateUpdate;
		FlxG.drawFramerate = ClientPrefs.data.framerateDraw;

		FlxG.fullscreen = ClientPrefs.data.fullyscreen;

		#if desktop
		if (ClientPrefs.data.resizeAuto) {
		FlxG.resizeWindow(Std.int(Capabilities.screenResolutionX) - 20, Std.int(Capabilities.screenResolutionY) - 40);
		FlxG.resizeGame(Std.int(Capabilities.screenResolutionX) - 20, Std.int(Capabilities.screenResolutionY) - 40);
		}

		Lib.application.window.move(10, 30);
		#end

		#if linux
		var icon = Image.fromFile("icon.png");
		Lib.current.stage.window.setIcon(icon);
		#end

		#if html5
		FlxG.autoPause = false;
		#end
		
		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end

		#if desktop
		DiscordClient.start();
		#end

	}

	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var timeNow:String = Date.now().getHours() + "_" + Date.now().getMinutes() + "_" + Date.now().getSeconds();
		var dateNow:String = Date.now().getDay() + "_"+ Date.now().getMonth() + "_" + Date.now().getFullYear();

		path = "./error/" + dateNow + "/" + timeNow + ".txt";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line: " + line + " | column: " + column + " | s: " + s + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		if (!ClientPrefs.data.noneNet && OnlineUtil.NetworkStatus() == false) {
			errMsg += "\nCritical Error: " + e.error + "\nThis Error will not be able to send to the servers. since internet connections are blocked. Contact technical support\n\n<!> REPORT INFORM SAVED IN [" + path + "]\n<!> NOT SEND TO SERVER - NETWORK IS DISCONNECTED";
		} else if (!ClientPrefs.data.noneNet && OnlineUtil.NetworkStatus() == true) {
			errMsg += "\nCritical Error: " + e.error + "\nThis Error was sent directly to an external server or saved for later sending. Please connect to the internet to be able to perform this function.\n\n<!> REPORT INFORM SAVED IN [" + path + "]\n<!> SEND TO SERVER";
		}

		errMsg += "\n\n\nENDING ENGINE V" + ClientPrefs.data.tempName[1] + "(" +ClientPrefs.data.tempName[0] + ")\nTGAMES - ENDING GROUP";

		if (!FileSystem.exists("./error/" + dateNow + "/")) {
			FileSystem.createDirectory("./error/" + dateNow + "/");
		}

		File.saveContent(path, errMsg);

		Sys.println(errMsg);
		Sys.println("ERROR REPORT IS SAVED IN [" + Path.normalize(path) + "]");

		ClientPrefs.data.consoleHistorial = "";

		MusicBeatState.notiWindows(errMsg, "ERROR ENGINE");

		Sys.exit(1);

		#if desktop
		DiscordClient.shutdown();
		#end
	}
	#end
}

*/////////////////////////////////////////////////////////////////////

//Nuevo Codigo
package;

import openfl.events.EventType;
import flixel.system.scaleModes.RatioScaleMode;
import openfl.display.StageAlign;
import openfl.display.StageQuality;
import openfl.system.Capabilities;
import states.MainMenuState;
import flixel.graphics.FlxGraphic;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import lime.app.Application;
import states.inicio.StartingState;
import backend.ClientPrefs;

#if linux
import lime.graphics.Image;
#end

#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
#end

class Main extends Sprite
{
    public static var fpsVar:FPS;

    public static var endingCorruption:String;
    public static var endingEngine:String;
    public static var pathVersion:String;

    private var game:FlxGame;

    public static function main():Void
    {
        Lib.current.addChild(new Main());
    }

    public function new()
    {
        super();
        if (stage != null) init();
        else addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(?E:Event):Void
    {
        if (hasEventListener(Event.ADDED_TO_STAGE))
        {
            removeEventListener(Event.ADDED_TO_STAGE, init);
        }

        setupGame();
    }

    private function setupGame():Void
    {

        var gameConfig = {
            width: 1280,
            height: 720,
            initialState: StartingState,
            zoom: 0,
            framerate: 60,
            skipSplash: true,
            startFullscreen: false
        };

        Controls.instance = new Controls();
        ClientPrefs.loadDefaultKeys();
        #if ACHIEVEMENTS_ALLOWED Achievements.load(); #end

        game = new FlxGame(
            gameConfig.width, 
            gameConfig.height, 
            gameConfig.initialState,
			#if (flixel < "5.00")
            gameConfig.zoom, 
			#end
            gameConfig.framerate, 
            gameConfig.framerate, 
            gameConfig.skipSplash, 
            gameConfig.startFullscreen
        );
        addChild(game);

		ClientPrefs.data.openWin += 1;

        setupPerformanceOverlay();
		setupStage();
        applyClientPrefs();

        #if desktop
        setupDesktop();
        #end

        #if CRASH_HANDLER
        Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
        #end
    }

    private function setupPerformanceOverlay():Void
    {
        var overlayConfig = ClientPrefs.data.noneAnimations
            ? {x: 10, y: 3, color: 0xFFFFFF, alpha: 1}
            : {x: -60, y: 3, color: 0xFFFFFF, alpha: 0};

        fpsVar = new FPS(overlayConfig.x, overlayConfig.y, overlayConfig.color);

        fpsVar.alpha = overlayConfig.alpha;

        addChild(fpsVar);
		FlxTween.tween(fpsVar, {x: 10, y: 7}, 1);
    }

    private function setupStage(?E:Event):Void
    {
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

		ClientPrefs.data.cacheSaveKbs = 0;
		var scaleMode = new RatioScaleMode();
		scaleMode.gameSize.set(1280, 720);
		FlxG.scaleMode = scaleMode;

		Lib.current.stage.scaleMode = StageScaleMode.NO_BORDER;
    	Lib.current.stage.align = StageAlign.TOP_LEFT;
		//FlxG.resizeGame(1280, 720);
    }

    private function applyClientPrefs():Void
    {
        if (!ClientPrefs.data.Welcome) 
            backend.MusicBeatState.updatestate("Loading Game...", ClientPrefs.data.language);

        FlxG.updateFramerate = ClientPrefs.data.framerateUpdate;
        FlxG.drawFramerate = ClientPrefs.data.framerateDraw;
        FlxG.fullscreen = ClientPrefs.data.fullyscreen;

        #if desktop
        if (ClientPrefs.data.resizeAuto) {
            //FlxG.resizeWindow(Std.int(Capabilities.screenResolutionX) - 20, Std.int(Capabilities.screenResolutionY) - 40);
            //FlxG.resizeGame(Std.int(Capabilities.screenResolutionX) - 20, Std.int(Capabilities.screenResolutionY) - 40);
			//Lib.application.window.move(10, 30);
        }
        #end

        #if html5
        FlxG.autoPause = false;
        #end
    }

    #if desktop
    private function setupDesktop():Void
    {
        #if linux
        var icon = Image.fromFile("icon.png");
        Lib.current.stage.window.setIcon(icon);
        #end

        DiscordClient.start();
    }
    #end

    #if CRASH_HANDLER
    private function onCrash(e:UncaughtErrorEvent):Void
    {
        var errMsg:String = "";
        var path:String;
        var callStack:Array<StackItem> = CallStack.exceptionStack(true);
        var dateNow:String = Date.now().toString();

        path = './error/${dateNow.replace(" ", "_").replace(":", ",")}.txt';

        for (stackItem in callStack)
        {
            switch (stackItem)
            {
                case FilePos(s, file, line, column):
                    errMsg += '$file (line: [$line])\n';
                default:
                    Sys.println(stackItem);
            }
        }

		if (!ClientPrefs.data.noneNet && OnlineUtil.NetworkStatus() == false) {
			errMsg += "\nCritical Error: " + e.error + "\nThis Error will not be able to send to the servers. since internet connections are blocked. Contact technical support\n\n<!> REPORT INFORM SAVED IN [" + path + "]\n<!> NOT SEND TO SERVER - NETWORK IS DISCONNECTED";
		} else if (!ClientPrefs.data.noneNet && OnlineUtil.NetworkStatus() == true) {
			errMsg += "\nCritical Error: " + e.error + "\nThis Error was sent directly to an external server or saved for later sending. Please connect to the internet to be able to perform this function.\n\n<!> REPORT INFORM SAVED IN [" + path + "]\n<!> SEND TO SERVER";
		}

		errMsg += "\n\n\nENDING ENGINE V" + ClientPrefs.data.tempName[1] + "(" +ClientPrefs.data.tempName[0] + ")\nTGAMES - ENDING GROUP";

		if (!FileSystem.exists("./error/" + dateNow + "/")) {
			FileSystem.createDirectory("./error/" + dateNow + "/");
		}

		File.saveContent(path, errMsg);

		Sys.println(errMsg + '\n\nERROR REPORT IS SAVED IN [' + Path.normalize(path) + ']');
		Sys.println("ERROR REPORT IS SAVED IN [" + Path.normalize(path) + "]");

		ClientPrefs.data.consoleHistorial = "";

		MusicBeatState.notiWindows(errMsg, "ERROR ENGINE");

        DiscordClient.shutdown();
		Sys.exit(1);
    }
    #end
}