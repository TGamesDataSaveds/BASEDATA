package system;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class LoadingScreen extends FlxState
{
	private var loadingBar:FlxSprite;
	private var loadingBarBg:FlxSprite;
	private var loadingText:FlxText;
	private var progressText:FlxText;
	private var logoSprite:FlxSprite;
	
	private var progress:Float = 0;
	
	override public function create():Void
	{
		super.create();
		
		// Fondo
		FlxG.camera.bgColor = FlxColor.BLACK;
		
		// Logo (simulado con un cuadrado)
		logoSprite = new FlxSprite(FlxG.width / 2 - 50, FlxG.height / 3 - 50);
		logoSprite.makeGraphic(100, 100, FlxColor.WHITE);
		add(logoSprite);
		
		// Texto de carga
		loadingText = new FlxText(0, FlxG.height / 2 + 50, FlxG.width, "Cargando...", 16);
		loadingText.alignment = CENTER;
		loadingText.color = FlxColor.WHITE;
		add(loadingText);
		
		// Fondo de la barra de progreso
		loadingBarBg = new FlxSprite(FlxG.width / 2 - 150, FlxG.height / 2 + 100);
		loadingBarBg.makeGraphic(300, 20, FlxColor.GRAY);
		add(loadingBarBg);
		
		// Barra de progreso
		loadingBar = new FlxSprite(FlxG.width / 2 - 150, FlxG.height / 2 + 100);
		loadingBar.makeGraphic(1, 20, FlxColor.LIME);
		add(loadingBar);
		
		// Texto de porcentaje
		progressText = new FlxText(0, FlxG.height / 2 + 130, FlxG.width, "0%", 12);
		progressText.alignment = CENTER;
		progressText.color = FlxColor.WHITE;
		add(progressText);
		
		// Iniciar la simulación de carga
		startLoading();
	}
	
	private function startLoading():Void
	{
		// Simular carga con un temporizador
		new FlxTimer().start(0.05, updateProgress, 100);
		
		// Hacer que el logo pulse
		FlxTween.tween(logoSprite, {alpha: 0.5}, 1, {type: FlxTween.PINGPONG});
	}
	
	private function updateProgress(timer:FlxTimer):Void
	{
		// Incrementar progreso
		progress += 0.01;
		if (progress > 1) progress = 1;
		
		// Actualizar barra de progreso
		loadingBar.scale.x = progress * 300;
		
		// Actualizar texto de porcentaje
		progressText.text = Math.floor(progress * 100) + "%";
		
		// Si la carga está completa, ir al estado principal
		if (progress >= 1)
		{
			new FlxTimer().start(1, function(_) {
				FlxG.switchState(new PlayState());
			});
		}
	}
}
