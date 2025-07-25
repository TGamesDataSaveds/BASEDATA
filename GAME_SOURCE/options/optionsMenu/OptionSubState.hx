package options.optionsMenu;

import flixel.util.FlxTimer;
import flixel.ui.FlxButton;
import options.optionsMenu.SubBase;

class OptionsSubState extends SubBase
{
	var options:Array<String> = [
		//'Note Colors',
		//'Controls',
		'Graphics',
		'Visuals UI',
		'UI Custom',
		'Optimizations',
		'Gameplay',
		'All Options',
		'AI SETTINGS',
		#if DEMO_MODE
		'Debug Config'
		#end
	];

	var optionsSpanish:Array<String> = [
		'GRAFICOS',
		'EFECTOS VISUALES',
		'PERSONALIZACION DE UI',
		'OPTIMIZACIONES',
		'GAMEPLAY',
		'TODAS LAS OPCIONES',
		'AJUSTES DE IA',
		#if DEMO_MODE
		'Debug Config'
		#end
	];

	var optionsOther:Array<String> = [
		'GRAFICOS',
		'EFEITOS VISUAIS',
		'PERSONALIZAÇÃO DA IU',
		'OTIMIZAÇÕES',
		'JOGO',
		'TODAS AS OPÇÕES',
		'CONFIGURAÇÕES DE IA',
		#if DEMO_MODE
		'Debug Config'
		#end
	];

	#if !DEMO_MODE
	public function onEffectvineta(Timer:FlxTimer):Void {
		FlxTween.tween(vineta, {alpha: 0}, 3, {
			onComplete: function (twn:FlxTween) {
				FlxTween.tween(vineta, {alpha: 1}, 3, {
					onComplete: function (twn:FlxTween) {
					}
				});
			}
		});
	}
	#end
	
	private var grpOptions:FlxTypedGroup<FlxText>;
	private static var curSelected:Int = 0;
	public static var TipText:FlxText;
	public static var TipText2:FlxText;
	public static var menuBG:FlxSprite;
	public static var onPlayState:Bool = false;
	public var vineta:FlxSprite;

	public var reloadIcon:FlxSprite;

	public var controlsIcon:FlxSprite;
	public var controlsButton:FlxButton;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals UI':
				openSubState(new options.VisualsUISubState());
			case 'UI Custom':
				openSubState(new options.optionsMenu.UICustom());
			case 'Optimizations':
				openSubState(new options.OptimizationsSubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Debug Config':
				openSubState(new options.InitialSettings());
			case 'All Options':
				openSubState(new options.AllOptions());
			case 'AI SETTINGS':
				openSubState(new options.optionsMenu.IASettings());
			}
	}

	function openSpanish(label:String) {
		switch(label) {
			case 'GRAFICOS':
				openSubState(new options.GraphicsSettingsSubState());
			case 'EFECTOS VISUALES':
				openSubState(new options.VisualsUISubState());
			case 'PERSONALIZACION DE UI':
				openSubState(new options.optionsMenu.UICustom());
			case 'OPTIMIZACIONES':
				openSubState(new options.OptimizationsSubState());
			case 'GAMEPLAY':
				openSubState(new options.GameplaySettingsSubState());
			case 'Debug Config':
				openSubState(new options.InitialSettings());
			case 'TODAS LAS OPCIONES':
				openSubState(new options.AllOptions());
			case 'AJUSTES DE IA':
				openSubState(new options.optionsMenu.IASettings());
			}
	}

	/*
		var optionsOther:Array<String> = [
		'AJUSTAR',
		'GRAFICOS',
		'EFEITOS VISUAIS',
		'PERSONALIZAÇÃO DA IU',
		'OTIMIZAÇÕES',
		'JOGO',
		'TODAS AS OPÇÕES',
		#if DEMO_MODE
		'Debug Config'
		#end
	];
	*/

	function openOther(label:String) {
		switch(label) {
			case 'GRAFICOS':
				openSubState(new options.GraphicsSettingsSubState());
			case 'EFEITOS VISUAIS':
				openSubState(new options.VisualsUISubState());
			case 'PERSONALIZAÇÃO DA IU':
				openSubState(new options.optionsMenu.UICustom());
			case 'OTIMIZAÇÕES':
				openSubState(new options.OptimizationsSubState());
			case 'JOGO':
				openSubState(new options.GameplaySettingsSubState());
			case 'Debug Config':
				openSubState(new options.InitialSettings());
			case 'TODAS AS OPÇÕES':
				openSubState(new options.AllOptions());
			case 'CONFIGURAÇÕES DE IA':
				openSubState(new options.optionsMenu.IASettings());
			}
	}

	public function new() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(0, 0, FlxColor.BLACK);
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.screenCenter();
		addObject(bg);

		//vineta
		vineta = new FlxSprite(0, 0).loadGraphic(Paths.image('Vineta'));
		vineta.antialiasing = ClientPrefs.data.antialiasing;
		vineta.width = FlxG.width;
		vineta.height = FlxG.height;
		vineta.updateHitbox();
		vineta.screenCenter();
		vineta.color = 0x000000;
		vineta.alpha = 0;

		grpOptions = new FlxTypedGroup<FlxText>();
		addObject(grpOptions);

		for (i in 0...options.length)
		{
			if (ClientPrefs.data.language == 'Inglish') {
			var optionText:FlxText = new FlxText(50, 300, 0, options[i], 32);
			optionText.font = Paths.font("new/BUND.otf");
			optionText.y += (50 * (i - (options.length / 2)));
			optionText.screenCenter(X);
			optionText.bold = true;
			optionText.ID = i;

			grpOptions.add(optionText);
			} else if (ClientPrefs.data.language == 'Spanish') {
			var optionText:FlxText = new FlxText(50, 300, 0, optionsSpanish[i], 32);
			optionText.font = Paths.font("new/BUND.otf");
			optionText.y += (50 * (i - (options.length / 2)));
			optionText.screenCenter(X);
			optionText.bold = true;
			optionText.ID = i;
	
			grpOptions.add(optionText);
			} else {
			var optionText:FlxText = new FlxText(50, 300, 0, optionsOther[i], 32);
			optionText.font = Paths.font("new/BUND.otf");
			optionText.y += (50 * (i - (options.length / 2)));
			optionText.screenCenter(X);
			optionText.bold = true;
			optionText.ID = i;
	
			grpOptions.add(optionText);
			}
		}

		controlsButton = new FlxButton(FlxG.width - 100, FlxG.height - 100, "", function() openSubState(new options.ControlsSubState()));
		controlsButton.loadGraphic(Paths.image('icons/Menu/controlsIcon'));

		//add(bgCG);
		if (ClientPrefs.data.graphics_internal != 'Low') {
			addObject(vineta);
		FlxTween.tween(vineta, {alpha: 1}, 2);
		}

		changeSelection();
		//ClientPrefs.saveSettings();

		addObject(controlsButton);

		MusicBeatState.updatestate('Options Menu');

		super();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		} else if (FlxG.mouse.wheel > 0) {
			changeSelection(FlxG.mouse.wheel);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		} else if (FlxG.mouse.wheel < 0) {
			changeSelection(FlxG.mouse.wheel);
		}

		if (FlxG.mouse.overlaps(controlsButton)) {
			FlxTween.cancelTweensOf(controlsButton, ["alpha"]);
			FlxTween.tween(controlsButton, {alpha: 1}, 0.3);
			FlxTween.angle(controlsButton, -30, 30, 2, {ease: FlxEase.expoInOut, type: PINGPONG});
		} else {
			if (controlsButton.alpha != 0.3) FlxTween.cancelTweensOf(controlsButton, ["alpha"]);
			FlxTween.tween(controlsButton, {alpha: 0.3}, 0.6);
			FlxTween.angle(controlsButton, -30, 30, 2, {ease: FlxEase.expoInOut, type: PINGPONG});
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.sound.music.fadeOut(2, 0, function (twn:FlxTween) {
				close();
			});
		}
		
		if (controls.ACCEPT){
			if (ClientPrefs.data.language == 'Inglish') {
			openSelectedSubstate(options[curSelected]);
			} else if (ClientPrefs.data.language == 'Spanish') {
				openSpanish(optionsSpanish[curSelected]);
			} else {
				openOther(optionsOther[curSelected]);
			}
		}
	}

	public function updateText() {
		for (i in 0...options.length) {
		for (text in grpOptions.members) {
			if (ClientPrefs.data.language == 'Inglish') {
				text.text = options[i];
			} else if (ClientPrefs.data.language == 'Spanish') {
				text.text = optionsSpanish[i];
			} else {
				text.text = optionsOther[i];
			}
		}
	}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.ID = bullShit - curSelected;
			bullShit++;

			FlxTween.cancelTweensOf(item);
			FlxTween.tween(item, {alpha: 0.6}, 0.2);
			if (item.ID == 0) {
				FlxTween.cancelTweensOf(item);
				FlxTween.tween(item, {alpha: 1}, 0.2);
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	override function destroy()
	{
		ClientPrefs.saveSettings();
		super.destroy();
	}
}