package states;

import notification.NotificationType;
import openfl.display.StageQuality;
import flixel.tile.FlxTile;
import states.subStates.SelectionState;
import openfl.display.Bitmap;
import flixel.FlxGame;
import states.editors.UpdatingState;
import flixel.FlxState;
import flixel.math.FlxPoint;
import openfl.events.MouseEvent;
import flixel.input.mouse.FlxMouseButton;
import openfl.ui.MouseCursor;
import flixel.ui.FlxSpriteButton;
import options.Option;
import flixel.tweens.misc.AngleTween;
import flixel.ui.FlxButton;
import backend.WeekData;
import backend.Achievements;
import openfl.utils.Timer;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import flixel.util.FlxTimer;

import haxe.Http;
#if sys
import sys.FileSystem;
import sys.io.File;
import sys.io.FileOutput;
#end

import openfl.filters.GlowFilter;

import substates.Prompt;
import flixel.FlxState;
import objects.Notification;

import flixel.input.FlxPointer;
//import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.input.mouse.FlxMouseEvent;

import flixel.FlxObject;
////
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxTween;

import flixel.input.keyboard.FlxKey;
import lime.app.Application;

import flixel.addons.ui.FlxInputText;

import flash.text.TextField;

import objects.AchievementPopup;
import objects.Notification;
import states.editors.MasterEditorMenu;
import options.OptionsState;
//import openfl.display.Internet;

#if VIDEOS_ALLOWED 
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler;
#else import vlc.MP4Handler as VideoHandler; #end
#end

import openfl.filters.BitmapFilter;
import openfl.filters.BlurFilter;
import openfl.filters.ColorMatrixFilter;
#if shaders_supported
#if (openfl >= "8.0.0")
import openfl8.*;
#else
import openfl3.*;
#end
import openfl.filters.ShaderFilter;
import openfl.Lib;
#end

class MainMenuState extends MusicBeatState
{

	//NotificationManager
	private var notificationManager:NotificationManager;

	//Filter
	var filterMap:Map<String, {filter:BitmapFilter, ?onUpdate:Void->Void}>;
	var filters:Array<BitmapFilter> = [];

	var backgroundCAM:FlxCamera;
	var buttonsCAM:FlxCamera;
	var hudCAM:FlxCamera;
	public static var vipCAM:FlxCamera;

	var bg:FlxSprite;
	var downLINE:FlxSprite;
	var upLINE:FlxSprite;
	var upLINEFIX:FlxSprite;
	//var FlxTWeen(default, null):?;

	//Buttons SPrites
	var storySprite:FlxSprite;
	var freeplaySprite:FlxSprite;
	var staticsSprite:FlxSprite;

	var settingsSprite:FlxSprite;
	var diarySprite:FlxSprite;
	var linksSprite:FlxSprite;

	//Buttons
	var storyButton:FlxButton;
	var freeplayButton:FlxButton;
	var staticsButton:FlxButton;

	var settingsButton:FlxButton;
	var diaryButton:FlxButton;
	var linksButton:FlxButton;

	//TEXT
	var descriptiondown:FlxText;
	var descriptionup:FlxText;

	//ClientPrefs
	var Spanish:Bool = ClientPrefs.data.language == 'Spanish';
	var Inglish:Bool = ClientPrefs.data.language == 'Inglish';
	var Portuguese:Bool = ClientPrefs.data.language == 'Portuguese';

	public static var selectedSomenting:Bool = false;

	var videoPath:String = 'Intro';

	var keybordMode:Bool = true;
	var mouseMode:Bool = false;

	var curSelected:Int = 0;

	var chargeTime:FlxTimer;

	var original:Float;

	var num:Int = 1;

	var low:MosaicEffect;

	var backgroundExcluid:Int = FlxG.random.int(0, 6);

	override function create()
	{
		notificationManager = NotificationManager.getInstance();
		notificationManager.initialize();
		low = new MosaicEffect();

		if (FlxG.sound.music.volume <= 0.7) {
			FlxG.sound.music.fadeIn(1, FlxG.sound.music.volume, 1);
		}
		backgroundCAM = new FlxCamera();
		buttonsCAM = new FlxCamera();
		hudCAM = new FlxCamera();
		vipCAM = new FlxCamera();

		backgroundCAM.bgColor.alpha = 0;
		buttonsCAM.bgColor.alpha = 0;
		hudCAM.bgColor.alpha = 0;
		vipCAM.bgColor.alpha = 0;

		FlxG.cameras.add(backgroundCAM, true);
		FlxG.cameras.add(buttonsCAM, false);
		FlxG.cameras.add(hudCAM, false);
		FlxG.cameras.add(vipCAM, false);

		original = backgroundCAM.x;

		bg = new FlxSprite(0, 0);
		bg.visible = false;
		bg.camera = backgroundCAM;
		add(bg);
		if (ClientPrefs.data.lowQuality) bg.shader = low.shader;

		downLINE = new FlxSprite(0, FlxG.height + 100).loadGraphic(Paths.image('mainmenu/UI/downBar'));
		downLINE.antialiasing = ClientPrefs.data.antialiasing;
		downLINE.setGraphicSize(FlxG.width, FlxG.height);
		downLINE.screenCenter(X);
		downLINE.camera = hudCAM;
		add(downLINE);
		if (ClientPrefs.data.lowQuality) downLINE.shader = low.shader;

		upLINEFIX = new FlxSprite(0, 0).makeGraphic(FlxG.width, 80, FlxColor.BLACK);
		upLINEFIX.camera = hudCAM;
		add(upLINEFIX);
		if (ClientPrefs.data.lowQuality) downLINE.shader = low.shader;

		upLINE = new FlxSprite(0, -1280).loadGraphic(Paths.image('mainmenu/UI/upBar'));
		upLINE.antialiasing = ClientPrefs.data.antialiasing;
		upLINE.setGraphicSize(FlxG.width, FlxG.height);
		upLINE.screenCenter(X);
		upLINE.camera = hudCAM;
		add(upLINE);
		if (ClientPrefs.data.lowQuality) downLINE.shader = low.shader;


		//UP

		descriptionup = new FlxText(0, 20, FlxG.width, "", 20);
		descriptionup.setFormat("", 20, FlxColor.WHITE, CENTER, OUTLINE);
		descriptionup.antialiasing = ClientPrefs.data.antialiasing;
		descriptionup.camera = vipCAM;
		descriptionup.font = Paths.font("new/BUND.otf");
		add(descriptionup);

		settingsButton = new FlxButton(-15, -110, "", function() {
			offAnim(new OptionsState());
		});
		settingsButton.loadGraphic(Paths.image('mainmenu/new/' + ClientPrefs.data.language + '/menu_Settings'));
		settingsButton.setGraphicSize(390, 100);
		settingsButton.camera = buttonsCAM;
		settingsButton.antialiasing = ClientPrefs.data.antialiasing;
		settingsButton.ID = 4;
		add(settingsButton);
		if (ClientPrefs.data.lowQuality) settingsButton.shader = low.shader;

		linksButton = new FlxButton(835, -110, "", function() {
			offAnim(new states.LinksState());
		});
		linksButton.loadGraphic(Paths.image('mainmenu/new/' + ClientPrefs.data.language + '/menu_Links'));
		linksButton.setGraphicSize(390, 100);
		linksButton.camera = buttonsCAM;
		linksButton.antialiasing = ClientPrefs.data.antialiasing;
		linksButton.ID = 6;
		add(linksButton);
		if (ClientPrefs.data.lowQuality) linksButton.shader = low.shader;

		diaryButton = new FlxButton(405, -110, "", function() {
			offAnim(new states.DiaryMenu());
		});
		diaryButton.loadGraphic(Paths.image('mainmenu/new/' + ClientPrefs.data.language + '/menu_Diary'));
		diaryButton.setGraphicSize(390, 100);
		diaryButton.camera = buttonsCAM;
		diaryButton.antialiasing = ClientPrefs.data.antialiasing;
		diaryButton.ID = 5;
		add(diaryButton);
		if (ClientPrefs.data.lowQuality) diaryButton.shader = low.shader;

		

		//visible: 65 - invisible: -110

		//DOWN

		descriptiondown = new FlxText(0, FlxG.height - 50, FlxG.width, "", 20);
		descriptiondown.setFormat("", 20, FlxColor.WHITE, CENTER, OUTLINE);
		descriptiondown.antialiasing = ClientPrefs.data.antialiasing;
		descriptiondown.camera = vipCAM;
		descriptiondown.font = Paths.font("new/BUND.otf");
		add(descriptiondown);

		storyButton = new FlxButton(-15, 760, "", function() {
			offAnim(new StoryMenuState());
		});
		storyButton.loadGraphic(Paths.image('mainmenu/new/' + ClientPrefs.data.language + '/menu_StoryMode'));
		storyButton.setGraphicSize(390, 100);
		storyButton.camera = buttonsCAM;
		storyButton.antialiasing = ClientPrefs.data.antialiasing;
		storyButton.ID = 1;
		add(storyButton);
		if (ClientPrefs.data.lowQuality) storyButton.shader = low.shader;

		freeplayButton = new FlxButton(405, 760, "", function() {
			offAnim(new FreeplayState());
		});
		freeplayButton.loadGraphic(Paths.image('mainmenu/new/' + ClientPrefs.data.language + '/menu_freeplay'));
		freeplayButton.setGraphicSize(390, 100);
		freeplayButton.camera = buttonsCAM;
		freeplayButton.antialiasing = ClientPrefs.data.antialiasing;
		freeplayButton.ID = 2;
		add(freeplayButton);
		if (ClientPrefs.data.lowQuality) freeplayButton.shader = low.shader;

		staticsButton = new FlxButton(835, 760, "", function() {
			offAnim(new states.EstadisticsMenuState());
		});
		staticsButton.loadGraphic(Paths.image('mainmenu/new/' + ClientPrefs.data.language + '/menu_Statistics'));
		staticsButton.setGraphicSize(410, 100);
		staticsButton.camera = buttonsCAM;
		staticsButton.antialiasing = ClientPrefs.data.antialiasing;
		staticsButton.ID = 3;
		add(staticsButton);
		if (ClientPrefs.data.lowQuality) staticsButton.shader = low.shader;

		FlxTween.tween(upLINE, {y: 0}, 1.5, {
			ease: FlxEase.linear,
			onComplete: function(twn:FlxTween) {
				FlxTween.tween(settingsButton, {y: 55}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(diaryButton, {y: 55}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(linksButton, {y: 55}, 0.5, {ease: FlxEase.linear}); //65
			}
		});
		FlxTween.tween(downLINE, {y: 0}, 1.5, {
			ease: FlxEase.linear,
			onComplete: function(twn:FlxTween) {
				FlxTween.tween(storyButton, {y: 555}, 0.5, {ease: FlxEase.linear}); //545
				FlxTween.tween(freeplayButton, {y: 555}, 0.5, {ease: FlxEase.linear});
				FlxTween.tween(staticsButton, {y: 555}, 0.5, {
					ease: FlxEase.linear,
					onComplete: function(twn:FlxTween) {
						bg.visible = true;
						selectedSomenting = true;
					}
				});
			}
		});

		//trace('MAINMENUSTATE CREATE');

		chargeTime = new FlxTimer();
		chargeTime.start(5, onCharge, 1);

		filterMap = [
			#if shaders_supported
			"Scanline" => {
				filter: new ShaderFilter(new Scanline()),
			}, "Grain" => {
				var shader = new Grain();
				{
					filter: new ShaderFilter(shader),
					onUpdate: function()
					{
						#if (openfl >= "8.0.0")
						shader.uTime.value = [Lib.getTimer() / 1000];
						#else
						shader.uTime = Lib.getTimer() / 1000;
						#end
					}
				}
			}
			#end
		];

		//backgroundCAM.setFilters(filters);

		//backgroundCAM.filtersEnabled = true;
		
		//filters.push(filterMap.get(filterMap.keys()));

		for (key in filterMap.keys()) {
			filterMode(filterMap.get(key).filter);
		}

		onChargeManual();

		MusicBeatState.updatestate('MainMenu');
		#if desktop
		DiscordClient.changePresence("MAINMENU", null);
		#end

		switch (ClientPrefs.data.resolutionQuality) {
			case "Low":
				Lib.current.stage.quality = StageQuality.LOW;
			case "Medium":
				Lib.current.stage.quality = StageQuality.MEDIUM;
			case "High":
				Lib.current.stage.quality = StageQuality.HIGH;
			case "Ultra":
				Lib.current.stage.quality = StageQuality.BEST;
			default:
				Lib.current.stage.quality = StageQuality.MEDIUM;
		}

		super.create();
	}

	function filterMode(filter:BitmapFilter) {
		filters.push(filter);
	}

	function changeSelection(value:Int = 0) {
		if (curSelected > 0) {
			curSelected += value;
		} else if (curSelected < 0) {
			curSelected -= value;
		}

		new FlxTimer().start(0.1, function(Timer:FlxTimer) {
			if (curSection == 1 ) {
				Lib.application.window.warpMouse(Std.int(storyButton.x), Std.int(storyButton.y));
				} else if (curSelected == 2 && keybordMode && !mouseMode) {
				Lib.application.window.warpMouse(Std.int(freeplayButton.x), Std.int(freeplayButton.y));
				} else if (curSelected == 3 && keybordMode && !mouseMode) {
				Lib.application.window.warpMouse(Std.int(staticsButton.x), Std.int(staticsButton.y));
				} else if (curSelected == 4 && keybordMode && !mouseMode) {
				Lib.application.window.warpMouse(Std.int(settingsButton.x), Std.int(settingsButton.y));
				} else if (curSelected == 5 && keybordMode && !mouseMode) {
				Lib.application.window.warpMouse(Std.int(diaryButton.x), Std.int(diaryButton.y));
				} else if (curSelected == 6 && keybordMode && !mouseMode) {
				Lib.application.window.warpMouse(Std.int(linksButton.x), Std.int(linksButton.y));
				} else {
				Lib.application.window.warpMouse(0, 0);
				}
		}, 1);
	}

	public function onCharge(Timer:FlxTimer) {
		var randomNum = FlxG.random.int(1, 6, [backgroundExcluid]);
		backgroundCAM.fade(FlxColor.BLACK, 0.5, false, function() {
			bg.loadGraphic(Paths.image('mainmenu/BG/' + randomNum));
			bg.setGraphicSize(FlxG.width + 100, FlxG.height + 100);
			bg.screenCenter();
			backgroundExcluid = randomNum;
			backgroundCAM.fade(FlxColor.BLACK, 0.5, true, function() {
				chargeTime.start(5, onCharge, 1);
			});
		});
	}
	
	function onChargeManual() {
		var randomNum = FlxG.random.int(1, 6, [backgroundExcluid]);
		backgroundCAM.fade(FlxColor.BLACK, 0.5, false, function() {
			bg.loadGraphic(Paths.image('mainmenu/BG/' + FlxG.random.int(1, 6)));
			bg.setGraphicSize(FlxG.width + 500, FlxG.height + 100);
			bg.screenCenter();
			backgroundExcluid = randomNum;
		});
	}

	function offAnim(nextState:FlxState) {
		selectedSomenting = false;
		FlxG.sound.play(Paths.sound('confirmMenu'));
		FlxTween.cancelTweensOf(linksButton);
		FlxTween.cancelTweensOf(staticsButton);
		FlxTween.cancelTweensOf(diaryButton);
		FlxTween.cancelTweensOf(settingsButton);
		FlxTween.cancelTweensOf(freeplayButton);
		FlxTween.cancelTweensOf(storyButton);
		descriptiondown.visible = false;
		descriptionup.visible = false;
		FlxTween.tween(freeplayButton, {y: 760}, 0.5, { type: PERSIST, ease: FlxEase.linear });
			FlxTween.tween(storyButton, {y: 760}, 0.5, { type: PERSIST, ease: FlxEase.linear });
			FlxTween.tween(staticsButton, {y: 760}, 0.5, { type: PERSIST, ease: FlxEase.linear });
			FlxTween.tween(diaryButton, {y: -110}, 0.5, { type: PERSIST, ease: FlxEase.linear });
			FlxTween.tween(settingsButton, {y: -110}, 0.5, { type: PERSIST, ease: FlxEase.linear });
			FlxTween.tween(linksButton, {y: -110}, 0.5, {type: PERSIST, ease: FlxEase.linear});
		FlxTween.tween(upLINE, {y: -1280}, 0.5, {
			startDelay: 0.5,
			ease: FlxEase.linear
		});
		FlxTween.tween(downLINE, {y: FlxG.height + 100}, 0.5, {
			startDelay: 0.5,
			onComplete: function(twn:FlxTween) {
				FlxTween.tween(vipCAM, {alpha: 0}, 0.5);
				FlxG.mouse.enabled = true;
				MusicBeatState.switchState(nextState);
			}, ease: FlxEase.linear
		});
	}

	override function update(elapsed:Float)
	{

		if (FlxG.keys.justPressed.C) {
			offAnim(new states.editors.ProfileMenu());
		}

		if (FlxG.keys.justPressed.B) {
			add(new objects.notifications.LastNotifications(vipCAM, "PRESIONASTE LA TECLA 'B'", FlxColor.RED, FlxColor.WHITE));
		}

		if ((FlxG.mouse.overlaps(settingsButton, buttonsCAM) || curSelected == settingsButton.ID) && selectedSomenting) {
			if (ClientPrefs.data.language == 'Spanish') {
				descriptionup.text = 'Ajusta tus Preferencias de Ajustes y accede a las optimizaciones del juego'.toUpperCase();
			} else if (ClientPrefs.data.language == 'Inglish') {
				descriptionup.text = 'Adjust your Settings Preferences and access game optimizations'.toUpperCase();
			} else if (ClientPrefs.data.language == 'Portuguese') {
				descriptionup.text = 'Ajuste suas preferências de configuração e acesse otimizações de jogo'.toUpperCase();
			}
			curSelected = 4;

		switch (ClientPrefs.data.resolutionQuality) {
			case "Low":
				Lib.current.stage.quality = StageQuality.LOW;
			case "Medium":
				Lib.current.stage.quality = StageQuality.MEDIUM;
			case "High":
				Lib.current.stage.quality = StageQuality.HIGH;
			case "Ultra":
				Lib.current.stage.quality = StageQuality.BEST;
			default:
				Lib.current.stage.quality = StageQuality.MEDIUM;
		}

			FlxTween.tween(settingsButton, {y: 65}, 1);
		} else if ((!FlxG.mouse.overlaps(settingsButton, buttonsCAM) || curSelected != settingsButton.ID) && selectedSomenting) {
			FlxTween.tween(settingsButton, {y: 55}, 1, {
				type: PERSIST
		});
	}

		if ((FlxG.mouse.overlaps(diaryButton, buttonsCAM) || curSelected == diaryButton.ID) && selectedSomenting) {
			if (Spanish) descriptionup.text = 'Explora en las notas del diario, donde vas encontrando mas notas mientras avanzas en tu aventura. Administra los logros obtenidos y guardados en tu Usuario'.toUpperCase();

			if (Inglish) descriptionup.text = 'Explore the journal notes, where you find more notes as you progress on your adventure. Manage the achievements obtained and saved in your User'.toUpperCase();

			if (Portuguese) descriptionup.text = 'Explore as notas do diário, onde você encontra mais notas à medida que avança em sua aventura. Gerencie as conquistas obtidas e salvas em seu usuário'.toUpperCase();

			curSelected = 5;
			FlxTween.tween(diaryButton, {y: 65}, 1);
		} else if ((!FlxG.mouse.overlaps(diaryButton, buttonsCAM) || curSelected != diaryButton.ID) && selectedSomenting) {
		FlxTween.tween(diaryButton, {y: 55}, 1, {
			type: PERSIST
		});
	}

		if ((FlxG.mouse.overlaps(linksButton, buttonsCAM) || curSelected == linksButton.ID) && selectedSomenting) {
			if (Spanish) descriptionup.text = 'Mira los Creditos y los links de Redes sociales de los creadores'.toUpperCase();

			if (Inglish) descriptionup.text = 'See the Credits and Social Network links of the creators'.toUpperCase();

			if (Portuguese) descriptionup.text = 'Veja os créditos e links de redes sociais dos criadores'.toUpperCase();

			curSelected = 6;

			FlxTween.tween(linksButton, {y: 65}, 1);
		} else if ((!FlxG.mouse.overlaps(linksButton, buttonsCAM) || curSelected != linksButton.ID) && selectedSomenting) {
		FlxTween.tween(linksButton, {y: 55}, 1, {
			type: PERSIST
		});
	}

		if ((FlxG.mouse.overlaps(storyButton, buttonsCAM) || curSelected == storyButton.ID) && selectedSomenting) {
			if (Spanish) descriptiondown.text = 'Disfruta de una historia interesante, acerca de un chico que su vida cambio de un dia para el otro'.toUpperCase();

			if (Inglish) descriptiondown.text = 'Enjoy an interesting story about a boy whose life changed from one day to the next'.toUpperCase();

			if (Portuguese) descriptiondown.text = 'Desfrute de uma história interessante sobre um menino cuja vida mudou de um dia para o outro'.toUpperCase();

			curSelected = 1;

			FlxTween.tween(storyButton, {y: 555}, 1);
		} else if ((!FlxG.mouse.overlaps(storyButton, buttonsCAM) || curSelected != storyButton.ID) && selectedSomenting) {
			FlxTween.tween(storyButton, {y: 565}, 1, {
			type: PERSIST
		});
	}

		if (FlxG.mouse.overlaps(freeplayButton, buttonsCAM) && selectedSomenting || curSelected == freeplayButton.ID && selectedSomenting) {
			if (Spanish) descriptiondown.text = 'Una experiencia libre, donde puede jugar cualquier nivel, sin restricciones de canciones'.toUpperCase();
			
			if (Inglish) descriptiondown.text = 'A free experience, where you can play any level, without song restrictions'.toUpperCase();

			if (Portuguese) descriptiondown.text = 'Uma experiência gratuita, onde você pode jogar qualquer nível, sem restrições de música'.toUpperCase();

			curSelected = 2;

			FlxTween.tween(freeplayButton, {y: 555}, 1);
		} else if (!FlxG.mouse.overlaps(freeplayButton, buttonsCAM) && selectedSomenting || curSelected != freeplayButton.ID && selectedSomenting) {
			FlxTween.tween(freeplayButton, {y: 565}, 1, {
			type: PERSIST
		});
	}

		if (FlxG.mouse.overlaps(staticsButton, buttonsCAM) && selectedSomenting || curSelected == staticsButton.ID && selectedSomenting) {
			if (Spanish) descriptiondown.text = 'Observa tus estadísticas de jugador o tus estadisticas de tu seccion de juego actual'.toUpperCase();

			if (Inglish) descriptiondown.text = 'View your player statistics or your current game section statistics'.toUpperCase();

			if (Portuguese) descriptiondown.text = 'Veja as estatísticas do seu jogador ou as estatísticas atuais da seção do jogo'.toUpperCase();

			curSelected = 3;

			FlxTween.tween(staticsButton, {y: 555}, 1);
		} else if (!FlxG.mouse.overlaps(staticsButton, buttonsCAM) && selectedSomenting || curSelected != staticsButton.ID && selectedSomenting) {
			FlxTween.tween(staticsButton, {y: 565}, 1, {
			type: PERSIST
		});
		}

		if (controls.UI_LEFT_P) {
			changeSelection(-1);
		} else if (controls.UI_RIGHT_P) {
			changeSelection(1);
		} else if (controls.UI_UP_P) {
			changeSelection(3);
		} else if (controls.UI_DOWN_P) {
			changeSelection(-3);
		}

		if (controls.ACCEPT) {
			if (curSelected == 1) {
				offAnim(new StoryMenuState());
			} else if (curSelected == 2) {
				offAnim(new states.FreeplayState());
			} else if (curSelected == 3) {
				offAnim(new states.EstadisticsMenuState());
			} else if (curSelected == 4) {
				offAnim(new OptionsState());
			} else if (curSelected == 5) {
				offAnim(new states.subStates.SelectionState());
			} else if (curSelected == 6) {
				offAnim(new states.LinksState());
			} else {
				offAnim(new MainMenuState());
			}
		}
		if (controls.BACK && ClientPrefs.data.loadMethor != 'STORGE') {
			//add(new Notification('OPTIMIZATIÓN', 'El Sistema a Eliminado los archivos del Titulo. Cambia esta configuracion en Ajustes', 1, vipCAM, 1.5));
			notificationManager.showNotification('Archivos Eliminados', 'No permitido el regreso por optimizacion del juego', NotificationType.ERROR, 'Los archivos del menu anterior fueron eliminados por lo que no se te puede permitir el regreso\n\nCambia esto en ajustes');
		} else if (controls.BACK && ClientPrefs.data.loadMethor == 'STORGE') {
			selectedSomenting = false;
			ClientPrefs.data.start = false;
			ClientPrefs.saveSettings();
			ClientPrefs.loadPrefs();
			offAnim(new TitleState());
		}

		if (curSelected >= 7) {
			curSelected = 1;
		} else if (curSelected <= 0) {
			curSelected = 6;
		}

		upLINEFIX.y = upLINE.y - upLINE.height / 2;

		upLINEFIX.setGraphicSize(FlxG.width, Std.int(upLINE.height));

		if (FlxG.keys.justPressed.F) offAnim(new states.InfoSystem());

		for (filter in filterMap)
			{
				if (filter.onUpdate != null)
					filter.onUpdate();
			}

		super.update(elapsed);
	}
}