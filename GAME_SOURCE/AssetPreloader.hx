package;

import backend.StageData;
import backend.Song;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxTimer;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxSound;

class AssetPreloader
{
	// Callbacks
	public var onProgress:Float->String->Void;
	public var onComplete:Void->Void;
	
	// Lista de assets a cargar
	private var assetsToLoad:Array<AssetInfo>;
	private var currentAssetIndex:Int = 0;
	private var totalAssets:Int = 0;
	
	// Estado precargado
	private var preloadedState:FlxState;
	
	// Variables para precarga del estado
	private var stateComponents:Array<String>;
	private var currentComponentIndex:Int = 0;
	
	public function new()
	{
		setupAssetList();
		setupStateComponents();
	}
	
	private function setupAssetList():Void
	{
		assetsToLoad = [
			// Imágenes básicas
			{path: "BG/philly_dark", type: IMAGE, name: "Cargando fondo principal..."},
			{path: "characters/BOYFRIEND", type: IMAGE, name: "Cargando personaje principal..."},
			//{path: "characters/gf", type: IMAGE, name: "Cargando personaje secundario..."},
			{path: "noteSkins/NOTE_assets", type: IMAGE, name: "Cargando notas musicales..."},
			{path: "noteSplashes/noteSplashes", type: IMAGE, name: "Cargando notas musicales..."},
			//{path: "ui/healthbar", type: IMAGE, name: "Cargando interfaz de usuario..."},
			{path: "pausemenu/BoxPause", type: IMAGE, name: "Cargando interfaz de usuario..."},
			{path: "pausemenu/Overlay_Box", type: IMAGE, name: "Cargando interfaz de usuario..."},
			{path: "alphabet", type: IMAGE, name: "Cargando interfaz de usuario..."},
			
			// Sonidos
			{path: "./assets/sounds/notes-sound/loader.ogg", type: SOUND, name: "Cargando efectos de sonido..."},
			{path: "./assets/sounds/notes-sound/sonido-de-disparo.ogg", type: SOUND, name: "Cargando efectos de sonido..."},
			{path: "./assets/sounds/notes-sound/glitch.ogg", type: MUSIC, name: "Cargando música de fondo..."},
			
			// Preparación del estado (AQUÍ ES DONDE SE PRECARGA REALMENTE)
			{path: "", type: STATE_INIT, name: "Inicializando estado principal..."},
			//{path: "", type: STATE_SYSTEMS, name: "Cargando Ecenario principal..."},
			//{path: "", type: STATE_SYSTEMS, name: "Cargando Ecenario principal..."},
			{path: "", type: STATE_COMPONENTS, name: "Cargando componentes del juego..."},
			{path: "", type: STATE_SYSTEMS, name: "Configurando sistemas de juego..."},
			{path: "", type: STATE_FINALIZE, name: "Finalizando preparación..."}
		];
		
		totalAssets = assetsToLoad.length;
	}
	
	private function setupStateComponents():Void
	{
		// Simular los componentes de un estado grande (5,000+ líneas)
		stateComponents = [
			"Sistema de input",
			"Renderizador de sprites",
			"Sistema de audio",
			"Manejador de animaciones",
			"Sistema de partículas",
			"Manejador de colisiones",
			"Sistema de UI",
			"Manejador de estados",
			"Sistema de efectos",
			"Sistema de guardado",
			"Manejador de eventos",
			"Sistema de networking",
			"Motor de scripting",
			"Manejador de recursos",
			"Sistema de debugging",
			"Optimizador de rendimiento",
			"Sistema de configuración"
		];
	}
	
	public function startPreloading():Void
	{
		currentAssetIndex = 0;
		loadNextAsset();
	}
	
	private function loadNextAsset():Void
	{
		if (currentAssetIndex >= totalAssets)
		{
			// Carga completada
			if (onComplete != null)
				onComplete();
			return;
		}
		
		var asset = assetsToLoad[currentAssetIndex];
		var progress = currentAssetIndex / totalAssets;
		
		// Notificar progreso
		if (onProgress != null)
			onProgress(progress, asset.name);
		
		// Cargar asset según su tipo
		switch (asset.type)
		{
			case IMAGE:
				loadImage(asset);
			case SOUND:
				loadSound(asset);
			case MUSIC:
				loadMusic(asset);
			case STATE_INIT:
				initializeState(asset);
			case STATE_COMPONENTS:
				loadStateComponents(asset);
			case STATE_SYSTEMS:
				setupStateSystems(asset);
			case STATE_FINALIZE:
				finalizeState(asset);
		}
	}
	
	private function loadImage(asset:AssetInfo):Void
	{
		try
		{
			var graphic = Paths.image(asset.path);
			if (graphic != null)
			{
				trace('Imagen cargada: ${asset.path}');
			}
		}
		catch (e:Dynamic)
		{
			trace('Error cargando imagen: ${asset.path} - $e');
		}
		
		// Tiempo realista para cargar imagen
		new FlxTimer().start(0.2 + Math.random() * 0.4, function(_) {
			currentAssetIndex++;
			loadNextAsset();
		});
	}
	
	private function loadSound(asset:AssetInfo):Void
	{
		try
		{
			FlxG.sound.cache(asset.path);
			trace('Sonido cargado: ${asset.path}');
		}
		catch (e:Dynamic)
		{
			trace('Error cargando sonido: ${asset.path} - $e');
		}
		
		new FlxTimer().start(0.3 + Math.random() * 0.5, function(_) {
			currentAssetIndex++;
			loadNextAsset();
		});
	}
	
	private function loadMusic(asset:AssetInfo):Void
	{
		try
		{
			FlxG.sound.cache(asset.path);
			trace('Música cargada: ${asset.path}');
		}
		catch (e:Dynamic)
		{
			trace('Error cargando música: ${asset.path} - $e');
		}
		
		new FlxTimer().start(0.4 + Math.random() * 0.6, function(_) {
			currentAssetIndex++;
			loadNextAsset();
		});
	}
	
	private function initializeState(asset:AssetInfo):Void
	{
		trace('Inicializando estado principal...');
		
		// AQUÍ ES DONDE REALMENTE SE PRECARGA EL ESTADO
		// Para un estado de 5,000+ líneas, esto toma tiempo real
		preloadedState = new PlayState();
		
		// Simular tiempo de inicialización realista para estado grande
		new FlxTimer().start(1.0 + Math.random() * 1.5, function(_) {
			currentAssetIndex++;
			loadNextAsset();
		});
	}
	
	private function loadStateComponents(asset:AssetInfo):Void
	{
		trace('Cargando componentes del estado...');
		
		// Simular carga de componentes individuales
		currentComponentIndex = 0;
		loadNextComponent();
	}
	
	private function loadNextComponent():Void
	{
		if (currentComponentIndex >= stateComponents.length)
		{
			// Todos los componentes cargados
			currentAssetIndex++;
			loadNextAsset();
			return;
		}
		
		var component = stateComponents[currentComponentIndex];
		trace('Cargando: $component');
		
		// Actualizar progreso con componente específico
		var componentProgress = currentAssetIndex / totalAssets + 
							   (currentComponentIndex / stateComponents.length) / totalAssets;
		
		if (onProgress != null)
			onProgress(componentProgress, 'Cargando: $component');
		
		// Simular tiempo de carga por componente
		new FlxTimer().start(0.1 + Math.random() * 0.3, function(_) {
			currentComponentIndex++;
			loadNextComponent();
		});
	}
	
	private function setupStateSystems(asset:AssetInfo):Void
	{
		trace('Configurando sistemas de juego...');
		
		// Simular configuración de sistemas complejos
		// Para un estado grande, esto incluiría:
		// - Inicialización de variables
		// - Configuración de eventos
		// - Preparación de sistemas de juego
		
		new FlxTimer().start(0.8 + Math.random() * 1.2, function(_) {
			currentAssetIndex++;
			loadNextAsset();
		});
	}
	
	private function finalizeState(asset:AssetInfo):Void
	{
		trace('Finalizando preparación del estado...');
		
		// Configuración final del estado
		// - Optimizaciones finales
		// - Verificaciones de integridad
		// - Preparación para transición
		
		new FlxTimer().start(0.5 + Math.random() * 0.7, function(_) {
			currentAssetIndex++;
			loadNextAsset();
		});
	}
	
	public function getPreloadedState():FlxState
	{
		return preloadedState != null ? preloadedState : new PlayState();
	}
}

// Enums y tipos actualizados
enum AssetType
{
	IMAGE;
	SOUND;
	MUSIC;
	STATE_INIT;      // Inicialización del estado
	STATE_COMPONENTS; // Carga de componentes individuales
	STATE_SYSTEMS;   // Configuración de sistemas
	STATE_FINALIZE;  // Finalización
}

typedef AssetInfo = {
	path:String,
	type:AssetType,
	name:String
}
