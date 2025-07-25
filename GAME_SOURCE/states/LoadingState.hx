package states;

import haxe.Http;
import objects.HealthBar;
import lime.app.Promise;
import lime.app.Future;

import flixel.FlxState;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import flixel.util.FlxTimer;

import objects.HealthBar;

import backend.StageData;

import haxe.io.Path;

class LoadingState extends MusicBeatState
{
	inline static var MIN_TIME = 1.0;
	
	var target:FlxState;
	var stopMusic = false;
	var directory:String;
	var callbacks:MultiCallback;
	var targetShit:Float = 0;

	var curT:Array<String> = [];

	var progress:Float = 0;

	var Time:FlxTimer;

	public static var loading:FlxText;
	var webTags:Array<String>;
	public static var consejo:FlxText;

	public static var pixel:Bool = false;

	function new(target:FlxState, stopMusic:Bool, directory:String)
	{
		super();
		this.target = target;
		this.stopMusic = stopMusic;
		this.directory = directory;
	}

	function loadWeb() {
		var https = new Http('https://raw.githubusercontent.com/ThonnyDevYT/FNFVersion/main/Dark/Loading/' + ClientPrefs.data.language + 'Tags.txt');

		https.onData = function(data:String) {
			webTags = data.split('\n');
			trace('ARRAY COMPLETE');
		}

		https.onError = function(e) {
			trace('ARRAY ERROR');
		}

		https.request();
	}


	var Barload:FlxText;
	override function create()
	{
		loadWeb();

			if (ClientPrefs.data.language == 'Inglish') {
				 loading = new FlxText(-100, 0, 0, "Loading", 60);
				 MusicBeatState.updatestate("Loading");
			} else if (ClientPrefs.data.language == 'Spanish') { 
				loading = new FlxText(-100, 0, 0, "Cargando", 60);
				MusicBeatState.updatestate("Cargando");
			} else if (ClientPrefs.data.language == 'Portuguese')  {
				loading = new FlxText(-100, 0, 0, "Carregando", 60);
				MusicBeatState.updatestate("Carregando");
			}
			if (pixel == false) {
			loading.setFormat(Paths.font("new/BUND.otf"), 60, FlxColor.WHITE, RIGHT);
			} else if (pixel == true) {
			loading.setFormat("pixel.otf", 45, FlxColor.WHITE, RIGHT);
			}
			loading.antialiasing = ClientPrefs.data.antialiasing;
			loading.alpha = 0;
			add(loading);
			FlxTween.tween(loading, {x: 0, alpha: 1}, 0.2, {ease: FlxEase.linear});

			consejo = new FlxText(0, 0, FlxG.width, webTags[FlxG.random.int(0, webTags.length)], 32);
			consejo.setFormat(Paths.font("new/BUND.otf"), 32, FlxColor.WHITE, CENTER);
			consejo.antialiasing = ClientPrefs.data.antialiasing;
			consejo.screenCenter();
			consejo.alpha = 0;
			add(consejo);
			FlxTween.tween(consejo, {alpha: 1}, 0.2, {ease: FlxEase.linear});
		
		initSongsManifest().onComplete
		(
			function (lib)
			{
				callbacks = new MultiCallback(onLoad);
				var introComplete = callbacks.add("introComplete");
				if (PlayState.SONG != null) {
					checkLoadSong(getSongPath());
					if (PlayState.SONG.needsVoices)
						checkLoadSong(getVocalPath());
				}
				checkLibrary("shared");
				if(directory != null && directory.length > 0 && directory != 'shared') {
					checkLibrary('week_assets');
				}

				var fadeTime = 0.5;
				FlxG.camera.fade(FlxG.camera.bgColor, fadeTime, true);
				new FlxTimer().start(fadeTime + MIN_TIME, function(_) introComplete());
			}
		);

		new FlxTimer().start(0.4, function(Timer:FlxTimer) onLoad(), 1);
	}
	
	function checkLoadSong(path:String)
	{
		if (!Assets.cache.hasSound(path))
		{
			var library = Assets.getLibrary("songs");
			final symbolPath = path.split(":").pop();
			// @:privateAccess
			// library.types.set(symbolPath, SOUND);
			// @:privateAccess
			// library.pathGroups.set(symbolPath, [library.__cacheBreak(symbolPath)]);
			var callback = callbacks.add("song:" + path);
			Assets.loadSound(path).onComplete(function (_) { callback(); });
		}
	}
	
	function checkLibrary(library:String) {
		trace(Assets.hasLibrary(library));
		if (Assets.getLibrary(library) == null)
		{
			@:privateAccess
			if (!LimeAssets.libraryPaths.exists(library))
				throw "Missing library: " + library;

			var callback = callbacks.add("library:" + library);
			Assets.loadLibrary(library).onComplete(function (_) { callback(); });
		}
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if(callbacks != null) {
			targetShit = FlxMath.remapToRange(callbacks.numRemaining / callbacks.length, 1, 0, 0, 1);
		}

		loading.x = FlxG.width - loading.width;
		loading.y = FlxG.height - loading.height;
	}
	
	function onLoad()
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		MusicBeatState.nullswitchState(target);
	}
	
	static function getSongPath()
	{
		return Paths.inst(PlayState.SONG.song);
	}
	
	static function getVocalPath()
	{
		return Paths.voices(PlayState.SONG.song);
	}
	
	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		MusicBeatState.nullswitchState(getNextState(target, stopMusic));
	}
	
	static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
		var directory:String = 'shared';
		var weekDir:String = StageData.forceNextDirectory;
		StageData.forceNextDirectory = null;

		if(weekDir != null && weekDir.length > 0 && weekDir != '') directory = weekDir;

		Paths.setCurrentLevel(directory);
		trace('Setting asset folder to ' + directory);


		var loaded:Bool = false;
		if (PlayState.SONG != null) {
			loaded = isSoundLoaded(getSongPath()) && (!PlayState.SONG.needsVoices || isSoundLoaded(getVocalPath())) && isLibraryLoaded("shared") && isLibraryLoaded('week_assets');
		}
		
		if (!loaded) {
			return new LoadingState(target, stopMusic, directory);
		}

		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		return target;
	}
	
	static function isSoundLoaded(path:String):Bool
	{
		trace(path);
		return Assets.cache.hasSound(path);
	}
	
	static function isLibraryLoaded(library:String):Bool
	{
		return Assets.getLibrary(library) != null;
	}
	
	override function destroy()
	{
		super.destroy();
		
		callbacks = null;
	}
	
	static function initSongsManifest()
	{
		var id = "songs";
		var promise = new Promise<AssetLibrary>();

		var library = LimeAssets.getLibrary(id);

		if (library != null)
		{
			return Future.withValue(library);
		}

		var path = id;
		var rootPath = null;

		@:privateAccess
		var libraryPaths = LimeAssets.libraryPaths;
		if (libraryPaths.exists(id))
		{
			path = libraryPaths[id];
			rootPath = Path.directory(path);
		}
		else
		{
			if (StringTools.endsWith(path, ".bundle"))
			{
				rootPath = path;
				path += "/library.json";
			}
			else
			{
				rootPath = Path.directory(path);
			}
			@:privateAccess
			path = LimeAssets.__cacheBreak(path);
		}

		AssetManifest.loadFromFile(path, rootPath).onComplete(function(manifest)
		{
			if (manifest == null)
			{
				promise.error("Cannot parse asset manifest for library \"" + id + "\"");
				return;
			}

			var library = AssetLibrary.fromManifest(manifest);

			if (library == null)
			{
				promise.error("Cannot open library \"" + id + "\"");
			}
			else
			{
				@:privateAccess
				LimeAssets.libraries.set(id, library);
				library.onChange.add(LimeAssets.onChange.dispatch);
				promise.completeWith(Future.withValue(library));
			}
		}).onError(function(_)
		{
			promise.error("There is no asset library with an ID of \"" + id + "\"");
		});

		return promise.future;
	}
}

class MultiCallback
{
	public var callback:Void->Void;
	public var logId:String = null;
	public var length(default, null) = 0;
	public var numRemaining(default, null) = 0;
	
	var unfired = new Map<String, Void->Void>();
	var fired = new Array<String>();
	
	public function new (callback:Void->Void, logId:String = null)
	{
		this.callback = callback;
		this.logId = logId;
	}
	
	public function add(id = "untitled")
	{
		id = '$length:$id';
		length++;
		numRemaining++;
		var func:Void->Void = null;
		func = function ()
		{
			if (unfired.exists(id))
			{
				unfired.remove(id);
				fired.push(id);
				numRemaining--;
				
				if (logId != null)
					log('fired $id, $numRemaining remaining');
				
				if (numRemaining == 0)
				{
					if (logId != null)
						log('all callbacks fired');
					callback();
				}
			}
			else
				log('already fired $id');
		}
		unfired[id] = func;
		return func;
	}
	
	inline function log(msg):Void
	{
		if (logId != null)
			trace('$logId: $msg');
	}
	
	public function getFired() return fired.copy();
	public function getUnfired() return [for (id in unfired.keys()) id];
}