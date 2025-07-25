package system;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxButton;

class VSCodeWindow extends FlxSpriteGroup
{
	// Componentes de la ventana
	private var titleBar:FlxSprite;
	private var sideBar:FlxSprite;
	private var editorArea:FlxSprite;
	private var statusBar:FlxSprite;
	private var activityBar:FlxSprite;
	
	// Textos y botones
	private var titleText:FlxText;
	private var closeButton:FlxSprite;
	private var minimizeButton:FlxSprite;
	private var maximizeButton:FlxSprite;
	private var fileExplorer:FlxSpriteGroup;
	
	// Colores de VSCode
	private static inline var COLOR_TITLE_BAR:Int = 0xFF3C3C3C;
	private static inline var COLOR_SIDE_BAR:Int = 0xFF252526;
	private static inline var COLOR_EDITOR:Int = 0xFF1E1E1E;
	private static inline var COLOR_ACTIVITY_BAR:Int = 0xFF333333;
	private static inline var COLOR_STATUS_BAR:Int = 0xFF007ACC;
	
	public function new()
	{
		super();
		
		// Dimensiones de la ventana
		var windowWidth:Int = FlxG.width - 40;
		var windowHeight:Int = FlxG.height - 40;
		var windowX:Int = 20;
		var windowY:Int = 20;
		
		// Crear la barra de título
		titleBar = new FlxSprite(windowX, windowY);
		titleBar.makeGraphic(windowWidth, 30, COLOR_TITLE_BAR);
		
		// Botones de la ventana
		closeButton = new FlxSprite(windowX + windowWidth - 46, windowY + 8);
		closeButton.makeGraphic(14, 14, FlxColor.RED);
		
		maximizeButton = new FlxSprite(windowX + windowWidth - 66, windowY + 8);
		maximizeButton.makeGraphic(14, 14, FlxColor.YELLOW);
		
		minimizeButton = new FlxSprite(windowX + windowWidth - 86, windowY + 8);
		minimizeButton.makeGraphic(14, 14, FlxColor.GREEN);
		
		// Título de la ventana
		titleText = new FlxText(windowX + 10, windowY + 8, 0, "Visual Studio Code - HaxeFlixel", 12);
		titleText.color = FlxColor.WHITE;
		
		// Barra de actividad (izquierda)
		activityBar = new FlxSprite(windowX, windowY + 30);
		activityBar.makeGraphic(50, windowHeight - 30 - 22, COLOR_ACTIVITY_BAR);
		
		// Barra lateral (explorador de archivos)
		sideBar = new FlxSprite(windowX + 50, windowY + 30);
		sideBar.makeGraphic(200, windowHeight - 30 - 22, COLOR_SIDE_BAR);
		
		// Área del editor
		editorArea = new FlxSprite(windowX + 250, windowY + 30);
		editorArea.makeGraphic(windowWidth - 250, windowHeight - 30 - 22, COLOR_EDITOR);
		
		// Barra de estado
		statusBar = new FlxSprite(windowX, windowY + windowHeight - 22);
		statusBar.makeGraphic(windowWidth, 22, COLOR_STATUS_BAR);
		
		// Crear el explorador de archivos
		createFileExplorer(windowX + 50, windowY + 30);
		
		// Añadir todos los elementos al grupo
		add(titleBar);
		add(closeButton);
		add(maximizeButton);
		add(minimizeButton);
		add(titleText);
		add(activityBar);
		add(sideBar);
		add(editorArea);
		add(statusBar);
		add(fileExplorer);
		
		// Añadir iconos a la barra de actividad
		createActivityBarIcons(windowX, windowY + 30);
		
		// Añadir contenido al editor
		createEditorContent(windowX + 250, windowY + 30);
		
		// Añadir texto a la barra de estado
		createStatusBarContent(windowX, windowY + windowHeight - 22);
	}
	
	private function createFileExplorer(x:Float, y:Float):Void
	{
		fileExplorer = new FlxSpriteGroup();
		
		// Título del explorador
		var explorerTitle = new FlxText(x + 10, y + 10, 0, "EXPLORADOR", 10);
		explorerTitle.color = FlxColor.fromRGB(170, 170, 170);
		
		// Archivos
		var fileY = y + 40;
		var fileNames = ["project.xml", "Main.hx", "PlayState.hx", "VSCodeWindow.hx"];
		
		for (fileName in fileNames)
		{
			var fileText = new FlxText(x + 15, fileY, 0, fileName, 10);
			fileText.color = FlxColor.WHITE;
			fileExplorer.add(fileText);
			fileY += 20;
		}
		
		fileExplorer.add(explorerTitle);
	}
	
	private function createActivityBarIcons(x:Float, y:Float):Void
	{
		// Iconos simulados (simplificados como cuadrados de colores)
		var iconY = y + 10;
		var iconColors = [FlxColor.WHITE, FlxColor.LIME, FlxColor.CYAN, FlxColor.ORANGE];
		
		for (color in iconColors)
		{
			var icon = new FlxSprite(x + 17, iconY);
			icon.makeGraphic(16, 16, color);
			add(icon);
			iconY += 40;
		}
	}
	
	private function createEditorContent(x:Float, y:Float):Void
	{
		// Simulación de código
		var codeText = "import flixel.FlxG;\nimport flixel.FlxSprite;\n\nclass VSCodeWindow extends FlxSpriteGroup\n{\n    public function new()\n    {\n        super();\n        // Código aquí\n    }\n}";
		
		var lineNumbers = "";
		for (i in 1...10)
		{
			lineNumbers += i + "\n";
		}
		
		var lineNumbersText = new FlxText(x + 10, y + 10, 0, lineNumbers, 10);
		lineNumbersText.color = FlxColor.GRAY;
		
		var code = new FlxText(x + 40, y + 10, 0, codeText, 10);
		code.color = FlxColor.WHITE;
		
		add(lineNumbersText);
		add(code);
	}
	
	private function createStatusBarContent(x:Float, y:Float):Void
	{
		var statusText = new FlxText(x + 10, y + 4, 0, "HaxeFlixel  UTF-8  Haxe", 9);
		statusText.color = FlxColor.WHITE;
		
		var gitBranch = new FlxText(FlxG.width - 100, y + 4, 0, "main", 9);
		gitBranch.color = FlxColor.WHITE;
		
		add(statusText);
		add(gitBranch);
	}
}