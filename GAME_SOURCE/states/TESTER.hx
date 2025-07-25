package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class TESTER extends FlxState
{
	override public function create():Void
	{
		super.create();
		
		// Fondo oscuro estilo VSCode
		FlxG.camera.bgColor = FlxColor.fromRGB(30, 30, 30);
		
		// Texto de bienvenida
		var welcomeText = new FlxText(0, FlxG.height * 0.4, FlxG.width, "¡Carga completada!", 48);
		welcomeText.setFormat(null, 48, FlxColor.WHITE, CENTER);
		add(welcomeText);
		
		var instructionText = new FlxText(0, FlxG.height * 0.6, FlxG.width, "Presiona R para volver a cargar", 16);
		instructionText.setFormat(null, 16, FlxColor.GRAY, CENTER);
		add(instructionText);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// Presionar R para volver a la pantalla de carga
		if (FlxG.keys.justPressed.R)
		{
			FlxG.switchState(new system.LoadingState());
		}
		
		// Presionar ESC para salir
		if (FlxG.keys.justPressed.ESCAPE)
		{
			#if desktop
			Sys.exit(0);
			#end
		}
	}
}
