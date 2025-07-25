package system;

import objects.Note;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.group.FlxSpriteGroup;

class LoadingState extends FlxState
{
	private var loadingText:FlxText;
	private var loadingBar:FlxSprite;
	private var loadingBarBg:FlxSprite;
	private var progressText:FlxText;
	private var loadingIcon:FlxSprite;
	private var loadingIconTrail:FlxSpriteGroup;
	private var backgroundGradient:FlxSprite;
	private var performanceText:FlxText;
	private var backgroundImage:FlxSprite;
	private var vignette:FlxSprite;
	
	private var currentProgress:Float = 0;
	private var displayProgress:Float = 0; // Para animación suave de la barra
	private var assetLoader:AssetPreloader;
	
	// Variables para el movimiento de cámara
	private var cameraDirection:Int = 1;
	private var cameraPaused:Bool = false;
	
	override public function create():Void
	{
		super.create();

		// PRECARGAR ASSETS DE NOTAS PRIMERO
    	//Note.preloadCommonAssets();
		
		// Crear fondo con imagen y efectos
		createBackground();
		setupUI();
		
		// Inicializar el precargador de assets
		assetLoader = new AssetPreloader();
		assetLoader.onProgress = onLoadingProgress;
		assetLoader.onComplete = onLoadingComplete;
		
		// Iniciar precarga después de un pequeño delay
		new FlxTimer().start(0.5, function(_) {
			assetLoader.startPreloading();
		});
	}
	
	private function onLoadingProgress(progress:Float, currentAsset:String):Void
	{
		// Actualizar progreso real
		currentProgress = progress;
		loadingText.text = currentAsset;
		
		// Animar la barra suavemente hacia el nuevo progreso
		animateProgressBar();
		
		trace('Loading progress: ${Math.round(progress * 100)}% - $currentAsset');
	}
	
	private function animateProgressBar():Void
	{
		// Animar desde displayProgress actual hasta currentProgress
		FlxTween.tween(this, {displayProgress: currentProgress}, 0.5, {
			onUpdate: function(_) {
				updateProgressBarVisual();
			}
		});
	}
	
private function onLoadingComplete():Void
{
    loadingText.text = "¡Carga completada!\nLeyendo Codigo...";
    
	FlxTween.tween(loadingIcon, {alpha: 0}, 0.5, {ease: FlxEase.backOut});
	//FlxTween.tween(loadingIconTrail, {alpha: 0}, 0.5, {ease: FlxEase.backOut});
    FlxTween.tween(this, {displayProgress: 1.0}, 0.3, {
        onUpdate: function(_) {
            updateProgressBarVisual();
        },
        onComplete: function(_) {
            new FlxTimer().start(0.5, function(_) {
                // CREAR EL PLAYSTATE AQUÍ, NO EN EL PRELOADER
                FlxG.switchState(new PlayState());
            });
        }
    });
}
	
	private function createBackground():Void
	{
		// Fondo degradado morado
		backgroundGradient = new FlxSprite(0, 0);
		backgroundGradient.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		
		var strips = 50;
		for (i in 0...strips)
		{
			var y:Int = Std.int((FlxG.height / strips) * i);
			var height:Int = Std.int(FlxG.height / strips) + 1;
			
			var progress = i / strips;
			var r:Int = Std.int(FlxMath.lerp(0, 75, progress));
			var g:Int = Std.int(FlxMath.lerp(0, 0, progress));
			var b:Int = Std.int(FlxMath.lerp(0, 130, progress));
			
			var stripColor = FlxColor.fromRGB(r, g, b);
			var strip = new FlxSprite(0, y);
			strip.makeGraphic(FlxG.width, height, stripColor);
			backgroundGradient.stamp(strip);
		}
		add(backgroundGradient);
		
		// Imagen de fondo con movimiento
		backgroundImage = new FlxSprite();
		backgroundImage.loadGraphic("./assets/images/BG/philly_dark.png");
		
		// Centrar la imagen
		backgroundImage.x = (FlxG.width - backgroundImage.width) / 2;
		backgroundImage.y = (FlxG.height - backgroundImage.height) / 2;
		backgroundImage.alpha = 0.7;
		add(backgroundImage);
		
		startCameraMovement();
		createVignette();
	}
	
	private function createVignette():Void
	{
		vignette = new FlxSprite(0, 0);
		vignette.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
		
		var centerX = FlxG.width / 2;
		var centerY = FlxG.height / 2;
		var maxRadius = Math.sqrt(centerX * centerX + centerY * centerY);
		
		var vignetteStrength = 0.8;
		var rings = 20;
		
		for (ring in 0...rings)
		{
			var radius = (ring / rings) * maxRadius;
			var alpha = (ring / rings) * vignetteStrength;
			
			var ringSprite = new FlxSprite(centerX - radius, centerY - radius);
			var ringSize:Int = Std.int(radius * 2);
			if (ringSize > 0)
			{
				ringSprite.makeGraphic(ringSize, ringSize, FlxColor.fromRGBFloat(0, 0, 0, alpha));
				vignette.stamp(ringSprite);
			}
		}
		
		add(vignette);
	}
	
	private function startCameraMovement():Void
	{
		moveCameraHorizontal();
	}
	
	private function moveCameraHorizontal():Void
	{
		if (cameraPaused) return;
		
		var moveDistance = 100;
		var moveTime = 3.0;
		
		var targetX = backgroundImage.x + (moveDistance * cameraDirection);
		
		FlxTween.tween(backgroundImage, {x: targetX}, moveTime, {
			onComplete: function(_) {
				cameraPaused = true;
				new FlxTimer().start(1.0, function(_) {
					cameraDirection *= -1;
					cameraPaused = false;
					moveCameraHorizontal();
				});
			}
		});
	}
	
	private function setupUI():Void
	{
		// Crear grupo para el trail del icono
		loadingIconTrail = new FlxSpriteGroup();
		add(loadingIconTrail);
		
		// Icono de carga principal en la esquina superior derecha
		loadingIcon = new FlxSprite(FlxG.width - 70, 20);
		createLoadingIcon();
		add(loadingIcon);
		
		// Crear trail/cola del icono
		createIconTrail();
		
		// Rotación del icono
		FlxTween.angle(loadingIcon, 0, 360, 1.5, {type: FlxTween.LOOPING});
		
		// Texto de información del sistema
		performanceText = new FlxText(10, 10, FlxG.width - 20, "Iniciando precarga...", 12);
		performanceText.setFormat(null, 12, FlxColor.fromRGB(200, 200, 200), LEFT);
		add(performanceText);
		
		// Texto de carga principal
		loadingText = new FlxText(0, FlxG.height * 0.5, FlxG.width, "Preparando...", 32);
		loadingText.setFormat(null, 32, FlxColor.WHITE, CENTER);
		add(loadingText);
		
		// Texto pequeño sobre la barra
		var loadingLabel = new FlxText(50, FlxG.height - 110, FlxG.width - 100, "Cargando assets", 14);
		loadingLabel.setFormat(null, 14, FlxColor.fromRGB(180, 180, 180), LEFT);
		add(loadingLabel);
		
		// Fondo de la barra de progreso
		loadingBarBg = new FlxSprite(50, FlxG.height - 80);
		loadingBarBg.makeGraphic(FlxG.width - 100, 25, FlxColor.fromRGB(40, 40, 60));
		add(loadingBarBg);
		
		// Barra de progreso
		loadingBar = new FlxSprite(50, FlxG.height - 80);
		loadingBar.makeGraphic(1, 25, FlxColor.fromRGB(150, 50, 200));
		add(loadingBar);
		
		// Texto de porcentaje
		progressText = new FlxText(0, FlxG.height - 50, FlxG.width, "0%", 18);
		progressText.setFormat(null, 18, FlxColor.WHITE, CENTER);
		add(progressText);
	}
	
	private function createLoadingIcon():Void
	{
		loadingIcon.makeGraphic(50, 50, FlxColor.TRANSPARENT);
		
		var centerX = 25;
		var centerY = 25;
		var outerRadius = 22;
		
		for (i in 0...12)
		{
			var angle = (i / 12) * Math.PI * 2;
			var x = centerX + Math.cos(angle) * outerRadius;
			var y = centerY + Math.sin(angle) * outerRadius;
			
			var segment = new FlxSprite(Std.int(x - 2), Std.int(y - 2));
			var alpha = 1.0 - (i / 12);
			var brightness = 0.7 + (alpha * 0.3);
			
			var segmentColor = FlxColor.fromRGBFloat(brightness, brightness, brightness, alpha);
			segment.makeGraphic(4, 8, segmentColor);
			loadingIcon.stamp(segment);
		}
		
		var centerDot = new FlxSprite(centerX - 3, centerY - 3);
		centerDot.makeGraphic(6, 6, FlxColor.WHITE);
		loadingIcon.stamp(centerDot);
	}
	
	private function createIconTrail():Void
	{
		for (i in 0...5)
		{
			var trailIcon = new FlxSprite(loadingIcon.x, loadingIcon.y);
			trailIcon.makeGraphic(50, 50, FlxColor.TRANSPARENT);
			
			var alpha = 0.3 - (i * 0.05);
			trailIcon.alpha = alpha;
			
			createTrailIcon(trailIcon, alpha);
			loadingIconTrail.add(trailIcon);
		}
	}
	
	private function createTrailIcon(sprite:FlxSprite, baseAlpha:Float):Void
	{
		var centerX = 25;
		var centerY = 25;
		var outerRadius = 22;
		
		for (i in 0...12)
		{
			var angle = (i / 12) * Math.PI * 2;
			var x = centerX + Math.cos(angle) * outerRadius;
			var y = centerY + Math.sin(angle) * outerRadius;
			
			var segment = new FlxSprite(Std.int(x - 2), Std.int(y - 2));
			var alpha = (1.0 - (i / 12)) * baseAlpha;
			var brightness = 0.7 + (alpha * 0.3);
			
			var segmentColor = FlxColor.fromRGBFloat(brightness, brightness, brightness, alpha);
			segment.makeGraphic(4, 8, segmentColor);
			sprite.stamp(segment);
		}
	}
	
	private function updateProgressBarVisual():Void
	{
		var maxBarWidth = FlxG.width - 100;
		var barWidth:Int = Std.int(displayProgress * maxBarWidth);
		
		// Recrear la barra con el nuevo ancho
		remove(loadingBar);
		loadingBar = new FlxSprite(50, FlxG.height - 80);
		
		if (barWidth > 0)
		{
			loadingBar.makeGraphic(barWidth, 25, FlxColor.fromRGB(150, 50, 200));
		}
		else
		{
			loadingBar.makeGraphic(1, 25, FlxColor.fromRGB(150, 50, 200));
		}
		
		add(loadingBar);
		
		// Actualizar texto de porcentaje
		var percentage:Int = Math.floor(displayProgress * 100);
		progressText.text = percentage + "%";
		
		// Actualizar información del sistema
		performanceText.text = 'Assets cargados: ${Math.round(displayProgress * 100)}%';
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// Actualizar trail del icono
		updateIconTrail();
		
		if (FlxG.keys.justPressed.ENTER)
		{
			// Permitir saltar si ya se cargó algo
			if (currentProgress > 0.1)
			{
				FlxG.switchState(new PlayState());
			}
		}
	}
	
	private function updateIconTrail():Void
	{
		for (i in 0...loadingIconTrail.length)
		{
			var trailIcon = loadingIconTrail.members[i];
			if (trailIcon != null)
			{
				var delay = (i + 1) * 0.1;
				trailIcon.angle = loadingIcon.angle - (delay * 60);
			}
		}
	}
}
