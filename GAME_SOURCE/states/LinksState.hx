package states;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import substates.Prompt;

import objects.AttachedSprite;

class LinksState extends MusicBeatState
{
	var curSelected:Int = -1;

	public var ignoreWarnings = false;

	private var grpOptions:FlxTypedGroup<FlxText>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var bgAlpha:FlxSprite;
	var descText:FlxText;
	var intendedColor:FlxColor;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var time:FlxTimer;

	var offsetThing:Float = -75;

	public function onAlpha(Timer:FlxTimer) {
		FlxTween.tween(bgAlpha, {alpha: 0}, 4, {
			onComplete: function (twn:FlxTween) {
			FlxTween.tween(bgAlpha, {alpha: 0.5}, 4);
			}
		});
	}

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("LINKS MENU", null);
		#end

		MusicBeatState.updatestate("Links Menu");

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.visible = false;
		add(bg);
		bg.screenCenter();

		bgAlpha = new FlxSprite().loadGraphic(Paths.image('BGMenu/pointAlpha'));
		bgAlpha.antialiasing = ClientPrefs.data.antialiasing;
		bgAlpha.screenCenter();
		bgAlpha.alpha = 0.5;
		add(bgAlpha);
		
		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);


		#if MODS_ALLOWED
		//for (mod in Mods.parseList().enabled) pushModCreditsToList(mod);
		#end

		var defaultList:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color - WebName - ¿REDIRECT TO LINK?
			['ENDING CORRUPTION - CHAPTER 1 - DARK ROAD'],
			[''],
			['Canal De Youtube',					'youtube',		'Youtube.com/@TGames.official',				'https://www.youtube.com/channel/UCIjku6e7Fsuh9szD5QUDI8A',				'5EFF0000', 		'Youtube.com',			'true'],
			[''],
			['Itch.io',								'itch',			'Thonnydevyt.itch.io/endingcorruption', 	'https://thonnydevyt.itch.io/endingcorruption', 						'f54272',			'Itch.io', 				'true'],
			[''],
			['GameBanana',							'gamebanana',	'Gamebana.com/wips/EndingCorruption', 		'https://gamebanana.com/wips/79622', 									'5EFFE100', 		'Gamebanana.com', 		'true'],
			[''],
			['Gamejolt',							'gamejolt',		'Gamejolt.com/games/EndingCorruptionDemo',  'https://gamejolt.com/games/EndingCorruptionDemo/845799', 				'5E00FF00', 		'Gamejolt.com',			'true'],
			[''],
			['Discord Server',						'discord',		'discord.gg/UPYsecaNQC',					'https://discord.gg/UPYsecaNQC',										'5E00A6FF',			'discord.gg',			'true'],
			[''],
			['MEMBERS PUBLIC - ENDING GROUP'],
			[''],
			['Soul_bf',								'youtube',		'Youtube.com/@Soul_bf723', 					'https://www.youtube.com/@Soul_bf723',									'0070cc',			'Youtube.com', 			'true'],
			[''],
			['TiagoMYSF',							'youtube',		'Youtube.com/@TiagoMYSF', 					'https://www.youtube.com/@TiagoMYSF',									'0070cc',			'Youtube.com', 			'true'],
			[''],
			['Daniela',								'youtube',		'ADMINISTRADORA DE \nSERVICIOS PUBLICOS DE TGAMES', 					'',											'0070cc',			'', 					'false'],
			[''],
			['ENDING GROUP ADMINISTRATORS'],
			[''],
			['ThonnyDev',							'discord',		'DIRECTOR/ADMINISTRATOR/PROGRAMATOR',		'',																		'5EFF0000', 		'', 		   			'false'],
			[''],
			['CamelyGamer',							'discord',		'DIRECTORA/ORGANIZADORA/DISEÑADORA',		'',																		'5EFF0000', 		'',            			'false'],
		];
		
		for(i in defaultList) {
			creditsStuff.push(i);
		}
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			//var optionText:Alphabet = new Alphabet(FlxG.width / 2, 300, creditsStuff[i][0], !isSelectable);
			var optionText:FlxText = new FlxText(5, 300, 0, creditsStuff[i][0], 16);
			optionText.bold = !isSelectable;
			optionText.y += (15 * (i - (creditsStuff.length / 2)));
			optionText.ID = i;
			optionText.alignment = LEFT;
			grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Mods.currentModDirectory = creditsStuff[i][5];
				}

				var str:String = 'links/missing_icon';
				if (Paths.image('links/' + creditsStuff[i][1]) != null) str = 'links/' + creditsStuff[i][1];
				var icon:AttachedSprite = new AttachedSprite(str);
				icon.xAdd = optionText.width + 10;
				icon.antialiasing = ClientPrefs.data.antialiasing;
				icon.sprTracker = optionText;
				icon.visible = false;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Mods.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
			else optionText.alignment = LEFT;
		}
		
		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		//descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		bg.color = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
		bgAlpha.color = CoolUtil.colorFromString(creditsStuff[curSelected][4]);

		intendedColor = bgAlpha.color;
		intendedColor = bg.color;
		changeSelection();

		time = new FlxTimer();
		time.start(12, onAlpha, 0);

		#if desktop
		DiscordClient.changePresence("LINKS MENU", null);
		#end

		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT && (creditsStuff[curSelected][3] == null && creditsStuff[curSelected][6] == 'true' || creditsStuff[curSelected][3].length > 4 && creditsStuff[curSelected][6] == 'true')) {
				openSubState(new Prompt('Estas por ser Redirigido a \n' + creditsStuff[curSelected][5] + '\n\nEstas Seguro?', 0, function() {
					CoolUtil.browserLoad(creditsStuff[curSelected][3]);
				},
				null, ignoreWarnings));
			}
			
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:FlxColor = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
		trace('The BG color is: $newColor');
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});

			FlxTween.color(bgAlpha, 1, bgAlpha.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.ID = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.ID == 0) {
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}

	#if MODS_ALLOWED
	function pushModCreditsToList(folder:String)
	{
		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
	}
	#end

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}