package options;

import objects.CheckboxThingie;
import objects.AttachedText;
import options.Option;
import objects.Notification;

class BaseOptionsMenu extends MusicBeatSubstate
{
	private var curOption:Option = null;
	private var curSelected:Int = 0;
	private var optionsArray:Array<Option>;

	private var grpOptions:FlxTypedGroup<FlxText>;
	private var checkboxGroup:FlxTypedGroup<CheckboxThingie>;
	private var grpTexts:FlxTypedGroup<FlxText>;

	private var descText:FlxText;

	public var title:String;
	public var rpcTitle:String;

	public var ready:Bool = false;

	public static var bgApha:FlxSprite;

	public var num:Int = 0;

	public static function colorNew(r:Int, g:Int, b:Int, a:Int) {
		bgApha.color = FlxColor.fromRGB(r, g, b, a);
	}

	public function new()
	{
		super();

		if(title == null) title = 'Options';
		if(rpcTitle == null) rpcTitle = 'Options Menu';
		
		#if desktop
		DiscordClient.changePresence(rpcTitle, null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0x000000;
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		bgApha = new FlxSprite().makeGraphic(0, 0, FlxColor.fromRGB(ClientPrefs.data.R, ClientPrefs.data.G, ClientPrefs.data.B, ClientPrefs.data.A));
		bgApha.screenCenter();
		bgApha.alpha = 0;
		FlxTween.tween(bgApha, {alpha: 1}, 0.1);
		add(bgApha);

		// avoids lagspikes while scrolling through menus!
		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		grpTexts = new FlxTypedGroup<FlxText>();
		add(grpTexts);

		checkboxGroup = new FlxTypedGroup<CheckboxThingie>();
		add(checkboxGroup);

		var titleText:FlxText = new FlxText(75, 45, FlxG.width, title, 22);
		titleText.alpha = 0;
		FlxTween.tween(titleText, {alpha: 0.4}, 1.2);
		add(titleText);

		descText = new FlxText(30, 600, FlxG.width - 30, "", 28);
		descText.setFormat(Paths.font("new/ALONE.otf"), 28, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 1;
		descText.alpha = 0;
		FlxTween.tween(descText, {alpha: 0.8}, 1.5, {
			ease: FlxEase.linear,
			onComplete: function (twn:FlxTween) {
				ready = true;
			}
		});
		add(descText);

		for (i in 0...optionsArray.length)
		{
			var optionText:FlxText = new FlxText(0, 360, FlxG.width, optionsArray[i].name, 25);
			optionText.font = Paths.font("new/BUND.otf");
			optionText.bold = true;
			optionText.alpha = 0;
			optionText.y += (40 * (i - (optionsArray.length / 2)));
			optionText.ID = i;
			optionText.antialiasing = ClientPrefs.data.antialiasing;
			grpOptions.add(optionText);

			var valueText:FlxText = new FlxText(FlxG.width + 100, optionText.y, 0, '' + optionsArray[i].getValue(), 25);
			valueText.font = Paths.font("new/BUND.otf");
			valueText.bold = true;
			valueText.ID = i;
			valueText.alpha = 0.6;
			valueText.antialiasing = ClientPrefs.data.antialiasing;
			grpTexts.add(valueText);
			optionsArray[i].child = valueText;
			updateTextFrom(optionsArray[i]);
		}

		changeSelection(0, true);

		for (i in 0...optionsArray.length) {
			changeSelection(i, false);
			changeSelection(i, false);
			changeSelection(i, false);

			changeSelection(0, false);
		}
	}

	public function addOption(option:Option) {
		if(optionsArray == null || optionsArray.length < 1) optionsArray = [];
		optionsArray.push(option);
	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	var holdValue:Float = 0;
	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		for (text in grpTexts.members) {
			if (text.ID == curSelected) {
				if (optionsArray[curSelected].type == 'bool') {

					if (optionsArray[curSelected].getValue() == true) {
						FlxTween.cancelTweensOf(text);
						text.color = FlxColor.GREEN;
						text.text = optionsArray[curSelected].getValue();
					} else if (optionsArray[curSelected].getValue() == false) {
						FlxTween.cancelTweensOf(text);
						text.color = FlxColor.RED;
						text.text = optionsArray[curSelected].getValue();
					}

					if(optionsArray[curSelected].getValue() == true) {
						if (ClientPrefs.data.language == 'Inglish') {
							text.text = 'ACTIVED';
						} else if (ClientPrefs.data.language == 'Spanish') {
							text.text = 'ACTIVADO';
						} else if (ClientPrefs.data.language == 'Portuguese') {
							text.text = 'ACTIVADO';
						}
						} else if (optionsArray[curSelected].getValue() == false) {
						if (ClientPrefs.data.language == 'Inglish') {
							text.text = 'DESACTIVATED';
						} else if (ClientPrefs.data.language == 'Spanish') {
							text.text = 'DESACTIVADO';
						} else if (ClientPrefs.data.language == 'Portuguese') {
							text.text = 'DESACTIVIT';
						}
						} else {
							text.text = 'ERROR';
						}
				}

				FlxTween.cancelTweensOf(text);
				FlxTween.tween(text, {alpha: 1}, 0.3);
				FlxTween.tween(text, {x: FlxG.width - text.width - 15}, 0.3);
			} else if (text.ID != curSelected) {
				FlxTween.cancelTweensOf(text);
				FlxTween.tween(text, {alpha: 0.6}, 0.3);
				FlxTween.tween(text, {x: FlxG.width - text.width}, 0.3);
			}
		}

		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			ClientPrefs.saveSettings();
			ClientPrefs.loadPrefs();
			close();
			if (!OptionsState.onPlayState){
			MusicBeatState.updatestate("Options Menu");
			MusicBeatState.fastResetState();
			}
			#if desktop
			DiscordClient.changePresence("OPTIONS MENU", null);
			#end
		}

		#if DEMO_MODE
		if (FlxG.keys.justPressed.B) {
			close();
			FlxG.sound.play(Paths.sound('confirmMenu'));
			ClientPrefs.loadPrefs();
		}
		#end

		if(nextAccept <= 0)
		{
			var usesCheckbox = true;
			if(curOption.type != 'bool')
			{
				usesCheckbox = false;
			}

			if(usesCheckbox)
			{
				if(controls.ACCEPT)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					curOption.setValue((curOption.getValue() == true) ? false : true);
					curOption.change();
				}
			} else {
				if(controls.UI_LEFT || controls.UI_RIGHT) {
					var pressed = (controls.UI_LEFT_P || controls.UI_RIGHT_P);
					if(holdTime > 0.5 || pressed) {
						if(pressed) {
							var add:Dynamic = null;
							if(curOption.type != 'string' || curOption.type != 'String') {
								add = controls.UI_LEFT ? -curOption.changeValue : curOption.changeValue;
							}

							switch(curOption.type)
							{
								case 'int' | 'float' | 'percent' | 'Int':
									holdValue = curOption.getValue() + add;
									if(holdValue < curOption.minValue) {
										holdValue = curOption.minValue;
									} else if (holdValue > curOption.maxValue) {
										holdValue = curOption.maxValue;
									}

									switch(curOption.type)
									{
										case 'int' | 'Int':
											holdValue = Math.round(holdValue);
											curOption.setValue(holdValue);

										case 'float' | 'percent':
											holdValue = FlxMath.roundDecimal(holdValue, curOption.decimals);
											curOption.setValue(holdValue);
									}

								case 'string' | 'String':
									var num:Int = curOption.curOption; //lol
									if(controls.UI_LEFT_P) --num;
									else num++;

									if(num < 0) {
										num = curOption.options.length - 1;
									} else if(num >= curOption.options.length) {
										num = 0;
									}

									curOption.curOption = num;
									curOption.setValue(curOption.options[num]); //lol
									//trace(curOption.options[num]);
							}
							updateTextFrom(curOption);
							curOption.change();
							FlxG.sound.play(Paths.sound('scrollMenu'));
						} else if(curOption.type != 'string' || curOption.type != 'String') {
							holdValue += curOption.scrollSpeed * elapsed * (controls.UI_LEFT ? -1 : 1);
							if(holdValue < curOption.minValue) holdValue = curOption.minValue;
							else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;

							switch(curOption.type)
							{
								case 'int' | 'Int':
									curOption.setValue(Math.round(holdValue));
								
								case 'float' | 'percent':
									curOption.setValue(FlxMath.roundDecimal(holdValue, curOption.decimals));
							}
							updateTextFrom(curOption);
							curOption.change();
						}
					}

					if(curOption.type != 'string' || curOption.type != 'String') {
						holdTime += elapsed;
					}
				} else if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
					clearHold();
					ClientPrefs.saveSettings();
				}
			}

			if(controls.RESET)
			{
				var leOption:Option = optionsArray[curSelected];
				leOption.setValue(leOption.defaultValue);
				if(leOption.type != 'bool')
				{
					if(leOption.type == 'string' || leOption.type == 'String') leOption.curOption = leOption.options.indexOf(leOption.getValue());
					updateTextFrom(leOption);
				}
				leOption.change();
				FlxG.sound.play(Paths.sound('cancelMenu'));
				ClientPrefs.saveSettings();
			}
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}

		super.update(elapsed);
	}

	function updateTextFrom(option:Option) {
		var text:String = option.displayFormat;
		var val:Dynamic = option.getValue();
		if(option.type == 'percent') val *= 100;
		var def:Dynamic = option.defaultValue;
		option.text = text.replace('%v', val).replace('%d', def);
		ClientPrefs.saveSettings();
	}

	function clearHold()
	{
		if(holdTime > 0.5) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		holdTime = 0;
	}
	
	function changeSelection(change:Int = 0, ?sound:Bool = true)
	{
		curSelected += change;
		if (curSelected < 0) curSelected = optionsArray.length - 1;

		if (curSelected >= optionsArray.length) curSelected = 0;

		if (optionsArray[curSelected].description != null) {
		FlxTween.cancelTweensOf(descText);
		FlxTween.tween(descText, {alpha: 0}, 0.1, {onComplete: function(twn:FlxTween) {
			descText.text = optionsArray[curSelected].description;
			descText.screenCenter(Y);
			descText.y += 270;
			FlxTween.tween(descText, {alpha: 0.7}, 0.1, {startDelay: 0.1});
		}});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			//item.ID = bullShit - curSelected;
			bullShit++;

			if(item.ID != curSelected) {
				FlxTween.cancelTweensOf(item);
				FlxTween.tween(item, {alpha: 0.6}, 0.2);
			} else if (item.ID == curSelected) {
				FlxTween.cancelTweensOf(item);
				FlxTween.tween(item, {alpha: 1}, 0.2);
			}
		}
		for (text in grpTexts.members) {
			if(text.ID != curSelected) {
				FlxTween.cancelTweensOf(text);
				FlxTween.tween(text, {alpha: 0.6}, 0.2);
			} else if(text.ID == curSelected) {
				FlxTween.cancelTweensOf(text);
				FlxTween.tween(text, {alpha: 1}, 0.2);
			}
			if (text.ID == curSelected) {
				if (optionsArray[curSelected].type == 'bool') {
					if (optionsArray[curSelected].getValue() == true) {
						FlxTween.cancelTweensOf(text);
						text.color = FlxColor.GREEN;
						text.text = optionsArray[curSelected].getValue();
					} else if (optionsArray[curSelected].getValue() == false) {
						FlxTween.cancelTweensOf(text);
						text.color = FlxColor.RED;
						text.text = optionsArray[curSelected].getValue();
					}
				}
			}

			if (text.ID == curSelected) {
			if(optionsArray[curSelected].getValue() == true && optionsArray[curSelected].type == 'bool') {
				if (ClientPrefs.data.language == 'Inglish') {
					text.text = 'ACTIVED';
				} else if (ClientPrefs.data.language == 'Spanish') {
					text.text = 'ACTIVADO';
				} else if (ClientPrefs.data.language == 'Portuguese') {
					text.text = 'ACTIVADO';
				}
				} else if (optionsArray[curSelected].getValue() == false && optionsArray[curSelected].type == 'bool') {
				if (ClientPrefs.data.language == 'Inglish') {
					text.text = 'DESACTIVATED';
				} else if (ClientPrefs.data.language == 'Spanish') {
					text.text = 'DESACTIVADO';
				} else if (ClientPrefs.data.language == 'Portuguese') {
					text.text = 'DESACTIVIT';
				}
				} else if (optionsArray[curSelected].type == 'bool') {
					text.text = 'ERROR';
				}
			}
		}

		curOption = optionsArray[curSelected];
		if (sound) FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}