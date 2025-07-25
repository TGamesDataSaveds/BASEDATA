package;

import openfl.display.FPS;
import flixel.system.FlxPreloader;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import openfl.Assets;
import openfl.utils.AssetLibrary;
import haxe.Log;
import system.PCPerformance;

class MyPreloader extends FlxPreloader
{
    #if desktop
    private var _bgSprite:Sprite;
    private var _loadingText:TextField;
    private var _progressText:TextField;
    private var _progressBar:Sprite;
    private var _assetList:Array<String>;
    private var _isInitialized:Bool = false;
    private var _isLoading:Bool = false;
    private var _PCScore:PCPerformance;

    public function new(MinDisplayTime:Float=3, ?AllowedURLs:Array<String>)
    {
        super(MinDisplayTime, AllowedURLs);
        _assetList = [];
    }

    override private function create():Void
    {
        try {
            _width = FlxG.width;
            _height = FlxG.height;
            
            _bgSprite = new Sprite();
            _bgSprite.graphics.beginFill(0x000000);
            _bgSprite.graphics.drawRect(0, 0, _width, _height);
            _bgSprite.graphics.endFill();
            addChild(_bgSprite);

            _loadingText = new TextField();
            _loadingText.defaultTextFormat = new TextFormat("Arial", 24, 0xFFFFFF, true);
            _loadingText.width = _width;
            _loadingText.y = _height / 2 - 50;
            _loadingText.text = "LEYENDO...";
            _loadingText.selectable = false;
            addChild(_loadingText);

            _progressText = new TextField();
            _progressText.defaultTextFormat = new TextFormat("Arial", 18, 0xFFFFFF);
            _progressText.width = _width;
            _progressText.y = _height / 2 + 30;
            _progressText.selectable = false;
            addChild(_progressText);

            _progressBar = new Sprite();
            _progressBar.y = _height / 2;
            addChild(_progressBar);

            _isInitialized = true;
            Log.trace('Preloader inicializado');

            loadAssets();
        } catch (e:Dynamic) {
            Log.trace('Error en create(): $e');
        }
    }

    private function loadAssets():Void
    {
        _PCScore = new PCPerformance();
        try {
            _isLoading = true;
            _loadingText.text = "Cargando lista de assets...";

        if (_PCScore.getPerformanceScore() >= 0.5) {
            trace('TU PC A OBTENIDO UN PUNTAJE DE: ${_PCScore.getPerformanceScore()}');
        for (i in 0...FlxG.random.int(50, 60000)) {
            _assetList.insert(i, '$#_FILE${i}_#$');
            ClientPrefs.data.cacheSaveKbs += FlxG.random.float(0.2, 1.8);
        }
        } else if (_PCScore.getPerformanceScore() >= 0.3) {
            trace('TU PC A OBTENIDO UN PUNTAJE DE: ${_PCScore.getPerformanceScore()}');
            for (i in 0...FlxG.random.int(20, 5000)) {
            _assetList.insert(i, '$#_FILE${i}_#$');
            ClientPrefs.data.cacheSaveKbs += FlxG.random.float(0.2, 1.8);
        }
        } else {
            trace('TU PC NO TIENE LA CAPACIDAD PARA REALIZAR UNA CARGA TAN RAPIDA...');
            trace('TU PC A OBTENIDO UN PUNTAJE DE: ${_PCScore.getPerformanceScore()}');
        }

            Log.trace('Número de assets encontrados: ${_assetList.length}');

            if (_assetList.length > 0) {
                _loadingText.text = "Iniciando carga de assets...";
                Assets.loadLibrary("default").onComplete(onAssetsLoaded).onError(onAssetsError);
            } else {
                Log.trace('No se encontraron assets para cargar');
                _loadingText.text = "ERROR: Preloader.hx [87]\n\nNO SE PIDO USAR CARGA RAPIDA, INCIALIZANDO CARGA MANUAL...";
            }
        } catch (e:Dynamic) {
            Log.trace('Error en loadAssets(): $e');
        }
    }

    override public function update(Percent:Float):Void
    {
        try {
            if (!_isInitialized) {
                Log.trace('Preloader no inicializado aún');
                return;
            }

            super.update(Percent);

            var actualPercent:Float = 0;
            if (root != null && root.loaderInfo != null) {
                actualPercent = root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal;
            } else {
                Log.trace('root o root.loaderInfo es null');
            }
            
            if (_progressBar != null) {
                _progressBar.graphics.clear();
                _progressBar.graphics.beginFill(0x00FF00);
                _progressBar.graphics.drawRect(0, 0, actualPercent * _width, 20);
                _progressBar.graphics.endFill();
            }

            if (_progressText != null) {
                _progressText.text = "Progreso: " + Std.int(actualPercent * 100) + "%";
            }

            if (_isLoading && _assetList != null && _assetList.length > 0) {
                var currentAssetIndex:Int = Std.int(actualPercent * _assetList.length);
                if (currentAssetIndex < _assetList.length && _loadingText != null) {
                    _loadingText.text = "Cargando: " + _assetList[currentAssetIndex];
                }
            }
        } catch (e:Dynamic) {
            Log.trace('Error en update(): $e');
        }
    }

    private function onAssetsLoaded(library:AssetLibrary):Void
    {
        _isLoading = false;
        if (_loadingText != null) {
            _loadingText.text = "¡Carga completa!";
            Log.trace('Assets cargados: ${_assetList.join(", ")}');
        } else {
            Log.trace('_loadingText es null en onAssetsLoaded');
        }
    }

    private function onAssetsError(error:Dynamic):Void
    {
        _isLoading = false;
        Log.trace('Error al cargar assets: $error');
        if (_loadingText != null) {
            _loadingText.text = "Error al cargar assets";
        }
    }
    #else
    trace('DISPOSITIVO ACTUAL NO ES COMPATIBLE CON PRECARGA DE ARCHIVOS DE TIPO "element for list"');
    #end
}