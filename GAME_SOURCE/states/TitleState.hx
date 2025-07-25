package states;

class TitleState extends MusicBeatState
{

	var logo:FlxSprite;
	var text:FlxText;
	//var image:FlxSprite;

	//input
	var selectedSomenthing:Bool = false;

	override function create() {

		//ShaderManager.initShaders();

		logo = new FlxSprite(0, 25);
		logo.loadGraphic(Paths.image('EndingCorruption-logo'));
		logo.screenCenter(X);
		logo.alpha = 0;
		add(logo);
		FlxTween.tween(logo, {y: logo.y + 25}, 2, {ease: FlxEase.linear, type: PINGPONG});

		text = new FlxText(0, FlxG.height - 100, 1200, "", 28);
		text.setFormat(Paths.font("new/BUND.otf"), 28, FlxColor.WHITE, CENTER);
		text.antialiasing = ClientPrefs.data.antialiasing;
		text.screenCenter(X);
		text.bold = true;
		add(text);

		//SIRVE PERO DEBE SER UTILIZADO BIEN
		/*image = new FlxSprite(0, 0).loadGraphic(OnlineUtil.imageOnline('iconOG', "png"));
		image.antialiasing = ClientPrefs.data.antialiasing;
		add(image);
		FlxTween.tween(image, {alpha: 1}, 2, {ease: FlxEase.linear, type: PINGPONG});*/

		if (ClientPrefs.data.language == 'Spanish') {
			text.text = 'PRESIONA ENTER PARA CONTINUAR';
		} else if (ClientPrefs.data.language == 'Inglish') {
			text.text = 'PRESS ENTER TO CONTINUE';
		} else if (ClientPrefs.data.language == 'Portuguese') {
			text.text = 'PRESSIONE ENTER PARA CONTINUAR';
		}

		FlxTween.tween(text, {alpha: 1}, 2.5, {onComplete: function(twn:FlxTween) FlxTween.tween(text, {alpha: 0}, 1, {type: PINGPONG, ease: FlxEase.circInOut})});
		FlxTween.tween(logo, {alpha: 1}, 2);
		ClientPrefs.data.Data = "ANIMATED: [LOGO(X - Y) | TEXT(ALPHA)] | WAITING INPUT";

		super.create();
	}

	override function update(elapsed:Float) {

		if ((controls.ACCEPT || FlxG.mouse.justPressed || FlxG.mouse.justPressedMiddle) && !selectedSomenthing) {
			if (ClientPrefs.data.language == 'Spanish') {
				text.text = 'INICIANDO';
			} else if (ClientPrefs.data.language == 'Inglish') {
				text.text = 'STARTING';
			} else if (ClientPrefs.data.language == 'Portuguese') {
				text.text = 'COMECANDO';
			}

			FlxTween.tween(text, {alpha: 1}, 0.2, {onComplete: function(twn:FlxTween) FlxTween.tween(text, {alpha: 0}, 1, {type: PINGPONG, ease: FlxEase.circInOut})});
			MusicBeatState.switchState(new MainMenuState());
			ClientPrefs.data.Data = 'ANIMATED: [LOGO(X[${logo.x}] - Y[${logo.y}]) | TEXT(ALPHA[${text.alpha}])] | LOADING MAINMENUSTATE';
		}

		super.update(elapsed);
	}
}
