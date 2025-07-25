package cutscenes;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * Sistema de diálogos simplificado para Psych Engine
 * Solo muestra un cuadro de texto con fondo oscuro
 */
class DialogueBox extends FlxSpriteGroup
{
	var dialogueData:Array<String> = [];
	var finishCallback:Void->Void;
	
	var bgFade:FlxSprite;
	var box:FlxSprite;
	var textBox:FlxTypeText;
	
	var curDialogue:Int = 0;
	var typing:Bool = false;
	var isEnding:Bool = false;
	
	public function new(dialogueList:Array<String>, ?finishCallback:Void->Void)
	{
		super();
		
		this.dialogueData = dialogueList;
		this.finishCallback = finishCallback;
		
		// Fondo oscuro con fade
		bgFade = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgFade.alpha = 0;
		add(bgFade);
		
		// Cuadro de diálogo
		box = new FlxSprite(50, FlxG.height - 200);
		box.makeGraphic(FlxG.width - 100, 150, FlxColor.BLACK);
		box.alpha = 0.8;
		add(box);
		
		// Texto del diálogo
		textBox = new FlxTypeText(70, FlxG.height - 180, Std.int(box.width - 40), "", 32);
		textBox.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT);
		textBox.sounds = [FlxG.sound.load(Paths.sound('dialogue'), 0.6)];
		add(textBox);
		
		// Iniciar con fade in
		FlxTween.tween(bgFade, {alpha: 0.7}, 0.5);
		
		// Mostrar el primer diálogo
		startDialogue();
	}
	
	private function startDialogue():Void
	{
		cleanDialog();
		
		// No hay más diálogos, terminar
		if (curDialogue >= dialogueData.length)
		{
			endDialogue();
			return;
		}
		
		typing = true;
		textBox.resetText(dialogueData[curDialogue]);
		textBox.start(0.04, true);
	}
	
	private function cleanDialog():Void
	{
		textBox.resetText('');
		// No usamos stop() porque no existe en FlxTypeText
	}
	
	private function endDialogue():Void
	{
		if (isEnding) return;
		
		isEnding = true;
		FlxG.sound.play(Paths.sound('dialogueClose'));
		
		FlxTween.tween(bgFade, {alpha: 0}, 0.5);
		FlxTween.tween(box, {alpha: 0}, 0.5);
		FlxTween.tween(textBox, {alpha: 0}, 0.5, {
			onComplete: function(_) {
				if (finishCallback != null)
					finishCallback();
				kill();
			}
		});
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER)
		{
			if (typing)
			{
				// Si está escribiendo, mostrar todo el texto de una vez
				textBox.skip();
				typing = false;
			}
			else
			{
				// Avanzar al siguiente diálogo
				curDialogue++;
				startDialogue();
			}
		}
	}
}
