package states.inicio;

import openfl.display.FPS;
import flixel.graphics.FlxGraphic;
import openfl.filesystem.File;
import flixel.system.debug.Window;
import flixel.ui.FlxBar;
import backend.OnlineUtil;
import flixel.system.FlxAssets;
import flixel.system.scaleModes.RatioScaleMode;
import openfl.utils.ByteArray;
import flash.display.BitmapData;
import openfl.Assets;
import states.PreloadingState;
import states.DiaryMenu;

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.net.URLRequest;
import openfl.net.URLLoader;
import openfl.utils.ByteArray;
import openfl.events.Event;
import haxe.io.Bytes;

import flixel.input.keyboard.FlxKey;

import haxe.format.JsonPrinter;

#if sys
import sys.FileSystem;
#end

import states.TESTER;
import system.LoadingState;

class StartingState extends MusicBeatState 
{
    //UI
    var BG:FlxSprite;
    var titleGame:FlxText;
    var statusMode:FlxText;
    var infoPause:FlxText;
    //var loadingIcon:FlxSprite;
    var assetsLOADER:String = '';
    var pausaMODE:Bool = false;

    //Timer
    var MultiTimer:FlxTimer;
    public static var complete:FlxTimer;

    //NUM
    var Progress:String;
    var newValue:Int;
    var value:Float = 0;

    var random:Float;
    var IAcomplete:Bool = false;

    var chash:String = null;

    var alphaMAX:Float = 0.8;

    var inputStatus:Bool = false;

    //Internet Ajust
    
    public static var updateVersion:String = '';
	public static var updateVersionEC:String = '';
	public static var editorverification:String = 'disabled';
	public static var editorpermiss:String = '';
	public static var releasevideolink:String = '';
	public static var pathVersionOnline:String = '';
	public static var pathVersionOnlineM:Bool = false;

    var loadLost:Bool = false;

    public static var UpdateEC:Bool = false;
    var internet:Bool = true;
    public static var editorresult:Bool;

    var fileTotal:Int = 100;
    var fileError:Int = 0;
    var fileSucess:Int = 0;

    function onInitial() {
        trace('REDIRIGIENDO---');
        IAcomplete = true;
        value = 0;
        if (ClientPrefs.data.language == 'Spanish') {
            statusMode.text = '${fileSucess}/${fileTotal} FUERON COMPLETADOS - ${fileError} ERRORES';
        } else if (ClientPrefs.data.language == 'Inglish') {
            statusMode.text = '${fileSucess}/${fileTotal} WERE COMPLETED - ${fileError} MISTAKES';
        } else if (ClientPrefs.data.language == 'Portuguese') {
            statusMode.text = '${fileSucess}/${fileTotal} FORAM CONCLUÍDOS - ${fileError} ERROS';
        }

        if (ClientPrefs.data.Welcome == false) {
            MusicBeatState.updatestate("Preloading Menu");
            #if desktop
			DiscordClient.changePresence("PRELOADER MENU", null);
			#end
            MusicBeatState.switchState(new PreloadingState());
        }

        if (ClientPrefs.data.Welcome == true && pathVersionOnlineM == false) {
            ClientPrefs.data.start = false;
            ClientPrefs.saveSettings();
            ClientPrefs.loadPrefs();

            MusicBeatState.switchState(new states.editors.ProfileMenu());
        } else if(pathVersionOnlineM == true) {
				MusicBeatState.switchState(new states.editors.UpdatingState());
				pathVersionOnlineM = false;
			} else {
                trace('ERROR TO LOAD');
            }
    }

    public static function web() {

        MusicBeatState.updatestate('URLS LOADERS');


        if (!ClientPrefs.data.noneNet) {
		trace('OBTENIENDO DATOS EL ULTIMO VIDEO SUBIDO');
		var htss = new haxe.Http("https://raw.githubusercontent.com/ThonnyDevYT/FNFVersion/main/Link_video.txt");
        htss.onData = function (data:String)
			{
				releasevideolink = data.split("*")[0].trim();
				trace("SE OBTUVO UN VALOR DE TIPO 'string': [" + releasevideolink + "]");
			}
			htss.onError = function (error) {
				trace('SUCEDIO UN ERROR FATAL: $error');
				trace('ERROR AL QUERER CARGAR EK ULTIMO VIDEO PUBLICADO, SE UTILIZARA EL URL ALMACENADO');
				releasevideolink = "https://www.youtube.com/watch?v=M67O8wIE-2U";
			}
            htss.request();

        /////////////////////////////////////
		trace('OBTENIENDO DATOS DEL ULTIMO PARCHE');
        pathVersionOnline = OnlineUtil.pathOnline();
        trace("SE OBTUVO UN VALOR DE TIPO 'VERSION': [" + pathVersionOnline + "]");

        if (pathVersionOnline != ClientPrefs.data.pathVersion) {
            pathVersionOnlineM = true;
            trace('SE ESTABLECIO QUE ESTE PATH DEBE SER DESCARGADO E INSTALADO');
        }
        if (pathVersionOnline == null) {
            pathVersionOnlineM = false;
            trace('EL PATH NO DEBE SER DESCARGADO O INSTALADO EN EL JUEGO');
        }

        ////////////////////////////////
		trace('OBTENIENDO DATOS DE LOS PERMISOS DE ADMINISTRADOR PUBLICOS');
		var htsp = new haxe.Http("https://raw.githubusercontent.com/ThonnyDevYT/FNFVersion/main/Editor-Permiss.txt");
			htsp.onData = function (data:String)
				{
					editorpermiss = data.split("!")[0].trim();
					var curVerificator:String = editorverification.trim();
					trace('SE OBTUVO UN VALOR DE TIPO "bool": [' + editorpermiss + "]");
					if (editorpermiss != curVerificator) {
						trace('EL VALOR ESTA RESULTANDO SER ACTIVADO');
						editorresult = true;
                        trace('SE HABILITARON LOS EDITORES');
					}
					if (editorpermiss == curVerificator) {
						trace('EL VALOR ESTA RESULTANDO SER DESACTIVADO');
						editorresult = false;
                        trace('SE BLOQUEO LOS EDITORES');
					}
				}
			htsp.onError = function (error) {
                trace('SE DETUVO LA OPERACION DE URL PARA LA DIRECCION: [' + htsp.url + ']');
				trace('SUCEDIO UN ERROR FATA: $error');
				trace('SE BLOQUEARAN LOS PERMISOS A LOS EDITORES POR SEGURIDAD...');
				editorresult = false;
                trace('SE BLOQUEO LOS EDITORES');
			}
            htsp.request();

        ///////////////////////////////////
		trace('OBTENIENDO DATOS DE LA ULTIMA VERSION LANZADA');
        updateVersionEC = OnlineUtil.versionOnline();
        var curVersionEC:String = ClientPrefs.data.tempName[1];
        trace('SE OBTUVO LA VERSION ACTUAL DE TU JUEGO');
        trace('LA VERSION ACTUAL DEL SERVIDOR ES: ' + updateVersionEC + ', \nLA VERSION ACTUAL DE TU JUEGO ES: ' + curVersionEC);
        if(updateVersionEC != curVersionEC) {
                trace('LAS VERSIONES NO COINCIDEN [REQUIERE ACTUALIZACION]');
                UpdateEC = true;
                trace('TU VERSION A SIDO ESTABLECIDA EN DESACTUALIZADA');
        } else {
            trace('LAS VERSIONES COINCIDEN [NO REQUIERE ACTUALIZACION]');
            UpdateEC = false;
            trace('TU VERSION SERA MANTENIDA EN ACTUALIZADA');
        }
        ///////////////////////////////////////
        } else {
            editorresult = false;
            trace('SE BLOQUEO LOS EDITORES');
            releasevideolink = "https://www.youtube.com/watch?v=M67O8wIE-2U";
            trace('ERROR AL QUERER CARGAR EK ULTIMO VIDEO PUBLICADO, SE UTILIZARA EL URL ALMACENADO');
            trace('LAS CARGAS DE DATOS ONLINE SE A DESABILITADO POR BLOQUEO DEL SERVICIO "NETWORK"');
        }
	}

    function exitMode() {
        IAcomplete = true;
        if (ClientPrefs.data.language == 'Spanish') {
            statusMode.text = '${fileSucess}/${fileTotal} FUERON COMPLETADOS - ${fileError} ERRORES';
        } else if (ClientPrefs.data.language == 'Inglish') {
            statusMode.text = '${fileSucess}/${fileTotal} WERE COMPLETED - ${fileError} MISTAKES';
        } else if (ClientPrefs.data.language == 'Portuguese') {
            statusMode.text = '${fileSucess}/${fileTotal} FORAM CONCLUÍDOS - ${fileError} ERROS';
        }

        new FlxTimer().start(1, function(Timer:FlxTimer) {
            if (ClientPrefs.data.Welcome == false) {
                MusicBeatState.updatestate("Preloading Menu");
                MusicBeatState.switchState(new PreloadingState());
            } else if (ClientPrefs.data.Welcome == true) {
                ClientPrefs.data.start = false;
                ClientPrefs.saveSettings();
                ClientPrefs.loadPrefs();
    
                MusicBeatState.updatestate("TitleMenu");
                try {
                if (ClientPrefs.data.music == 'Disabled') {
                    FlxG.sound.playMusic(Paths.music('none'), 0);
                } else {
                    FlxG.sound.playMusic(Paths.music(ClientPrefs.data.music), 0);
                }
            } catch (e) {
                trace("ERROR: " + e);
            }
    
                MusicBeatState.updateFPS();
    
                FlxG.sound.music.fadeIn(0.01, 0, 1, function (twn:FlxTween) {
                        MusicBeatState.switchState(new TitleState());
                    }
                );
               
            }
        }, 1);

    }

    function onMode() {
        if (!IAcomplete) {
        ClientPrefs.data.Data = "LOADING ASSET";

        if (ClientPrefs.data.language == 'Inglish') {
            statusMode.text = assetsLOADER + ' - LOADING [' + value + '%]';
        } else if (ClientPrefs.data.language == 'Spanish') {
            statusMode.text = assetsLOADER + ' - CARGANDO [' + value + '%]';
        } else {
            statusMode.text = assetsLOADER + ' - LOADING [' + value + '%]';
        }
    }
    }

    override function create():Void {

        WindowProperty.VolumeControlls(true);

        ClientPrefs.loadPrefs();
        if (ClientPrefs.data.Welcome == true && !ClientPrefs.data.noneNet) {
            internet = OnlineUtil.NetworkStatus();

            if (internet == true) {
                trace('OBTENIENDO DATOS...');
                web();
            } else {
                trace('!!NO SE ENCONTRARON DATOS!!');
            }

            ClientPrefs.data.Data = "CARGANDO DATOS... [VERIFICANDO INTERNET]";
        }

        MusicBeatState.updatestate('PRELOADING MENU');
    
        FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 30;
		FlxG.keys.preventDefaultKeys = [TAB];

        ClientPrefs.loadPrefs();

        try {
        FlxG.sound.playMusic(Paths.music('none'), 1, true);
        } catch (e) {
            trace("ERROR: " + e);
        }

        BG = new FlxSprite(0, 0).makeGraphic(FlxG.width + 100, FlxG.height + 200, FlxColor.BLACK);
        BG.screenCenter();
        add(BG);

        infoPause = new FlxText(0, 0, FlxG.width / 2, "", 15);
        infoPause.setFormat(Paths.font('new/BUND.otf'), 15, FlxColor.WHITE, LEFT, OUTLINE, FlxColor.BLACK);
        //infoPause.setShaderByName('rgbGlitch');
        add(infoPause);
        textPause(0);

        statusMode = new FlxText(0, 0, FlxG.width, "", 32);
        statusMode.setFormat(Paths.font("new/BUND.otf"), 32, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
        statusMode.antialiasing = ClientPrefs.data.antialiasing;
        statusMode.alpha = 0.2;
        //statusMode.setShaderByName('rgbGlitch');
        add(statusMode);
        FlxTween.tween(statusMode, {x: FlxG.width - statusMode.width - 5, y: FlxG.height - 45}, 0.1);
        new FlxTimer().start(0.1, function(Timer:FlxTimer) {
            onMode();
        }, 0);

        //FlxTween.tween(Main.fpsVar, {x: 10, y: 7}, 1);

        //CameraShaderManager.setShader('rgbGlitch');

        if (ClientPrefs.data.cacheSaveKbs == 0) {
       if (ClientPrefs.data.startLoad) {
            preloadingAssets();
        } else {
            divisionCargaCompleta();
        }
    } else {
        divisionCargaCompleta();
    }

        super.create();
    }

    //Esta funcion solo hara la verificacion para cargar y aumentar el porcentaje
    //El valor "position" es el valor en tiempo de carga se recomienda poner como si fuera el orden de carga
    //El valor "path" es el nombre del archivo o direccion en subcarpetas [Edita las carpetas de destino en "source/backend/Paths"]
    //El valor "type" es un array que establecera el tipo de archivo ingresar un valor de los siguientes:
    //images, sound, music, video
    //y usa esta arquitectura: [images] Debe ser individual el valor
    function upPorcent(position:Float, path:String, type:Array<String>) {
        trace('LLAMADO DE PRECARGA....[${position}][${path}][${type[0]}]');

        //Este es el sistema de precarga y se trata de cargar los archivos de forma manual
        //Estaran invisibles y seran cargados por tiempo
        //Esto no tendra que ver con nada de tu sistema, eso si estoy haciendo un sistema que detecte los componentes del sistema
        //Si el sistema es mas rapido se reduce mas el tiempo de carga

        if (type[0] == "sound") {
                new FlxTimer().start(position + (position), function(Timer:FlxTimer) {
                    statusMode.alpha = 0.2;
                    FlxTween.cancelTweensOf(statusMode);
                    FlxTween.tween(statusMode, {alpha: alphaMAX}, 0.5, {ease: FlxEase.circInOut, type: PINGPONG});
                    var sound = new FlxSound().loadEmbedded(Paths.sound(path));
                    sound.volume = 0; //Baja el volumen al minimo para que no se escuche pero si se cargue (Esto es solo por cualquier cosa)
                    if (sound != null) {
                        assetsLOADER = '${path} [SONIDO]';
                        trace(type[0] + " cargado correctamente");
                        fileSucess += 1;
                        value += 1;
                        floatingText('CARGADO EXITOSAMENTE', FlxColor.GREEN);
                    } else {
                        fileError += 1;
                        assetsLOADER = '${path} [SONIDO]';
                        trace("No se pudo cargar el " + type[0]);
                        floatingText('ERROR AL INTENTAR CARGAR', FlxColor.RED);
                    }                   
                }, 1);
        }

        if (type[0] == "images") {
            trace('PRECARGA DE TIPO [IMAGEN]....');
            new FlxTimer().start(position + (position), function(Timer:FlxTimer) {
                statusMode.alpha = 0.2;
                FlxTween.cancelTweensOf(statusMode);
                FlxTween.tween(statusMode, {alpha: alphaMAX}, 0.8, {ease: FlxEase.circInOut, type: PINGPONG});
                var image:FlxSprite = new FlxSprite().loadGraphic(Paths.image(path)); //Creara un sprite que no se añadira pero si se cargara, luego se hara una comprobacion y listo
                if (image.graphic != null) { //Verificara si hay un grafico en el sprite
                    assetsLOADER = '${path} [IMAGEN]';
                    trace(type[0] + " cargado correctamente");
                    fileSucess += 1;
                    value += 1;
                    floatingText('CARGADO EXITOSAMENTE', FlxColor.GREEN);
                } else {
                    fileError += 1;
                    assetsLOADER = '${path} [IMAGEN]';
                    trace("No se pudo cargar el " + type[0]);
                    floatingText('ERROR AL INTENTAR CARGAR', FlxColor.RED);
                }                    
            }, 1);
    }

    if (type[0] == "video") {
        new FlxTimer().start(position + (position), function(Timer:FlxTimer) {
            statusMode.alpha = 0.2;
            FlxTween.cancelTweensOf(statusMode);
            FlxTween.tween(statusMode, {alpha: alphaMAX}, 0.2, {ease: FlxEase.circInOut, type: PINGPONG});
            var video = Assets.getMovieClip(path);
            if (video != null) {
                assetsLOADER = '${path} [VIDEO]';
                trace(type[0] + " cargado correctamente");
                fileSucess += 1;
                value += 1;
                floatingText('CARGADO EXITOSAMENTE', FlxColor.GREEN);
            } else {
                fileError += 1;
                assetsLOADER = '${path} [VIDEO]';
                trace("No se pudo cargar el " + type[0]);
                floatingText('ERROR AL INTENTAR CARGAR', FlxColor.RED);
            }                    
        }, 1);
    }

     if (type[0] == "music") {
        new FlxTimer().start(position + (position), function(Timer:FlxTimer) {
            statusMode.alpha = 0.2;
            FlxTween.cancelTweensOf(statusMode);
            FlxTween.tween(statusMode, {alpha: alphaMAX}, 0.3, {ease: FlxEase.circInOut, type: PINGPONG});
            var music = new FlxSound();
            trace('/assets/music/${path}');
            if (FileSystem.exists('/assets/music/${path}')) {
            music.loadEmbedded(Paths.music(path));
            music.volume = 0;
            if (music != null) {
                assetsLOADER = '${path} [MUSICA]';
                trace(type[0] + " cargado correctamente");
                fileSucess += 1;
                value += 1;
                floatingText('CARGADO EXITOSAMENTE', FlxColor.GREEN);
            } else {
                fileError += 1;
                assetsLOADER = '${path} [MUSICA]';
                trace("No se pudo cargar el " + type[0]);
                floatingText('ERROR AL INTENTAR CARGAR', FlxColor.RED);
            }    
        } else {
            fileError += 1;
            assetsLOADER = '${path} [MUSICA]';
            trace("No se pudo cargar el " + type[0] + ' __ PATH: [' + 'assets/music/${path}' + ']');
            value += 1;
            floatingText('ERROR AL INTENTAR CARGAR', FlxColor.RED);
        }                
        }, 1);
    }

    if (type[0] == "character") {
        new FlxTimer().start(position + (position), function(Timer:FlxTimer) {
            statusMode.alpha = 0.2;
            FlxTween.cancelTweensOf(statusMode);
            FlxTween.tween(statusMode, {alpha: alphaMAX}, 0.1, {ease: FlxEase.circInOut, type: PINGPONG});
            var characterPath:String = 'assets/shared/images/characters/${path}.png';
            var image = new FlxSprite().loadGraphic(characterPath);
            image.visible = false;
            if (image.graphic != null) { //Verificara si hay un grafico en el sprite
                assetsLOADER = '${path} [Character]';
                trace(type[0] + " cargado correctamente");
                fileSucess += 1;
                value += 1;
                floatingText('CARGADO EXITOSAMENTE', FlxColor.GREEN);
            } else {
                fileError += 1;
                assetsLOADER = '${path} [Chararcter]';
                trace("No se pudo cargar el " + type[0]);
                floatingText('ERROR AL INTENTAR CARGAR', FlxColor.RED);
            }  
        }, 1);
    }

    if (type[0] == "Others") {
        new FlxTimer().start(position + (position), function(Timer:FlxTimer) {
            statusMode.alpha = 0.2;
            FlxTween.cancelTweensOf(statusMode);
            FlxTween.tween(statusMode, {alpha: alphaMAX}, 0.05, {ease: FlxEase.circInOut, type: PINGPONG});
            var characterPath:String = 'assets/shared/images/${path}.png';
            var image = new FlxSprite().loadGraphic(characterPath);
            image.visible = false;
            if (image.graphic != null) { //Verificara si hay un grafico en el sprite
                assetsLOADER = '${path} [Others]';
                trace(type[0] + " cargado correctamente");
                fileSucess += 1;
                value += 1;
                floatingText('CARGADO EXITOSAMENTE', FlxColor.GREEN);
            } else {
                fileError += 1;
                assetsLOADER = '${path} [Others]';
                trace("No se pudo cargar el " + type[0]);
                floatingText('ERROR AL INTENTAR CARGAR', FlxColor.RED);
            }  
        }, 1);
    }
    }

    function floatingText(text:String = '', color:FlxColor = FlxColor.GREEN) {
        var textFloating:FlxText = new FlxText(0, statusMode.y, FlxG.width, text, 28);
        textFloating.setFormat(Paths.font('new/BUND.otf'), 28, color, RIGHT);
        textFloating.antialiasing = ClientPrefs.data.antialiasing;
        textFloating.alpha = 1;
        add(textFloating);

        FlxTween.tween(textFloating, {alpha: 0, y: statusMode.y - 60}, 0.7, {onComplete: function(twn:FlxTween) {
            textFloating.destroy();
        }});
    }

    function preloadingAssets() {
        ClientPrefs.data.Data = "CARGANDO 'ASSETS'";
        inputStatus = true;

        //Esta es la carga manual
        //Mas lenta pero mucho mas efectiva y se ejecutara si la carga rapida no se puede ejecutar
        //Esto le dara un tiempo de carga entre archivo de 30 segundos cada uno
        //Se cargaran y seran invisibles, esta idea es [CamelyGamer]
        upPorcent(1, "alphabet_playstation", ["images"]);
        upPorcent(2, "alphabet", ["images"]);
        upPorcent(3, "alphabetOld", ["images"]);
        upPorcent(4, "box", ["images"]);
        upPorcent(5, "campaign_menu_UI_assets", ["images"]);
        upPorcent(6, "chart_quant", ["images"]);
        upPorcent(7, "checkboxanim", ["images"]);
        upPorcent(8, "controllertype", ["images"]);
        upPorcent(9, "corruption-logo-Back", ["images"]);
        upPorcent(10, "corruption-logo-shadow", ["images"]);
        upPorcent(11, "corruption-logo", ["images"]);
        upPorcent(12, "EndingCorruption-logo", ["images"]);
        upPorcent(13, "menuDesat", ["images"]);
        upPorcent(14, "newgrounds_logo", ["images"]);
        upPorcent(15, "NOTE_evil", ["images"]);
        upPorcent(16, "notification_box", ["images"]);
        upPorcent(17, "notification_compact", ["images"]);
        upPorcent(18, "num0", ["images"]);
        upPorcent(19, "num1", ["images"]);
        upPorcent(20, "num2", ["images"]);
        upPorcent(21, "num3", ["images"]);
        upPorcent(22, "num4", ["images"]);
        upPorcent(23, "num5", ["images"]);
        upPorcent(24, "num6", ["images"]);
        upPorcent(25, "num7", ["images"]);
        upPorcent(26, "num8", ["images"]);
        upPorcent(27, "num9", ["images"]);
        upPorcent(28, "Peligro_BG", ["images"]);
        upPorcent(29, "phantom_fear_logo", ["images"]);
        upPorcent(30, "Vineta", ["images"]);

        //No me gusta ver todo apichado haci que separo estos pero siguen siendo imagenes
        //Este acuerdate que se cargan dependiendo del idioma
        //no elimines las direcciones que estan en "$" ya que son las subcarpetas
        //Solo si cambia la ubicacion cambia las sub carpetas de los archivos
        upPorcent(31, 'mainmenu/new/${ClientPrefs.data.language}/' + "menu_Diary", ["images"]);
        upPorcent(32, 'mainmenu/new/${ClientPrefs.data.language}/' + "menu_freeplay", ["images"]);
        upPorcent(33, 'mainmenu/new/${ClientPrefs.data.language}/' + "menu_Links", ["images"]);
        upPorcent(34, 'mainmenu/new/${ClientPrefs.data.language}/' + "menu_Settings", ["images"]);
        upPorcent(35, 'mainmenu/new/${ClientPrefs.data.language}/' + "menu_Statistics", ["images"]);
        upPorcent(36, 'mainmenu/new/${ClientPrefs.data.language}/' + "menu_StoryMode", ["images"]);
        upPorcent(37, 'mainmenu/UI/' + "downBar", ["images"]);
        upPorcent(38, 'mainmenu/UI/' + "upBar", ["images"]);

        //Aqui va un cargador de los archivos que estan en "mainmenu/BG/" intenta comprimir todo sin que sea uno por uno
        for (i in 1...6) {
        upPorcent(39 + i - 1, 'mainmenu/BG/' + i, ["images"]); //NOSE COMO HACER PARA QUE ESTO NO DIERA ERROR PERO HACI QUEDO
        } //Shadow mira esto creo que ya lo mejore porque tendriamos que ver que dice thonny

        //Este es la carga de los sonidos
        upPorcent(44, "cancelMenu", ["sound"]);
        upPorcent(45, "click", ["sound"]);
        upPorcent(46, "confirmMenu", ["sound"]);
        upPorcent(47, "key", ["sound"]);
        upPorcent(48, "notificacion-1", ["sound"]);
        upPorcent(49, "scrollMenu", ["sound"]);
        //Omiti los archivos como "introGo-pixel" porque nisiquiera se utilizan deberian ser borrados para ahorrar espacio

        //Esta es la carga de las musica [NO IGNORAR NINGUNA (SOLO LA VACIA YA QUE ESA ESTA CARGADA SIEMPRE)]
        upPorcent(50, "freakyMenu", ["music"]);
        upPorcent(51, "Hall", ["music"]);
        upPorcent(52, "Hallucination", ["music"]);
        upPorcent(53, "MenuTetrik", ["music"]);
        upPorcent(54, "offsetSong", ["music"]);
        upPorcent(55, "SelectedMusic", ["music"]);
        upPorcent(56, "StateHorror2", ["music"]);
        upPorcent(57, "TerminalMusic", ["music"]);
        upPorcent(58, "Night Of Terror", ["music"]); //Modificacion(18/12/2024): Modificacion al nombre de la cancion, falta añadir el audio
        
        //Esta es la carga de los archivos de los characters

        //BOYFRIEND
        upPorcent(59, "BOYFRIEND", ["character"]);
        upPorcent(60, "BOYFRIEND_DEAD", ["character"]);

        upPorcent(61, "BF/Corruption/" + "bf_corruption_10", ["character"]); //10
        upPorcent(62, "BF/Corruption/" + "bf_corruption_30", ["character"]); //30
        upPorcent(63, "BF/Corruption/" + "bf_corruption_50", ["character"]); //50
        upPorcent(64, "BF/Corruption/" + "bf_corruption_70", ["character"]); //70
        upPorcent(65, "BF/Corruption/" + "bf_corruption_90", ["character"]); //90

        //Others
        upPorcent(66, "BF/Others/" + "bf-GUN-v2", ["character"]);
        upPorcent(67, "BF/Others/" + "bf-mad", ["character"]);
        upPorcent(68, "BF/Others/" + "BF-normalV1", ["character"]);
        upPorcent(69, "BF/Others/" + "BF1", ["character"]);
        upPorcent(70, "BF/Others/" + "BF2", ["character"]);
        upPorcent(71, "BF/Others/" + "BF3", ["character"]);
        upPorcent(72, "BF/Others/" + "bfsit", ["character"]);

        //DADDY DEREST
        upPorcent(73, "Stage/" + "dad-defeat", ["character"]);
        upPorcent(74, "Stage/" + "dad-full", ["character"]);
        upPorcent(75, "Stage/" + "dad-one", ["character"]);
        upPorcent(76, "Stage/" + "dad-three", ["character"]);
        upPorcent(77, "Stage/" + "dad-two", ["character"]);

        //MOMMY
        upPorcent(78, "Mom-day-1", ["character"]);
        upPorcent(79, "Mom-day-2", ["character"]);
        upPorcent(80, "Mom-day-3", ["character"]);
        upPorcent(81, "Mom-day-4", ["character"]);
        upPorcent(82, "Mom-Memory", ["character"]);
        upPorcent(83, "Stage/mommy/" + "mom-full", ["character"]);

        //PICO
        upPorcent(84, "Pico_FNF_assetss-memory", ["character"]);
        upPorcent(85, "Pico_FNF_assetss", ["character"]);
        upPorcent(86, "Pico-day-2", ["character"]);
        upPorcent(87, "Pico-day-3", ["character"]);
        upPorcent(88, "Pico-day-4", ["character"]);
        upPorcent(89, "Pico-day-5", ["character"]);
        upPorcent(90, "Pico-day-Deluxe", ["character"]);

        //SPOOKYS
        upPorcent(91, "spooky1", ["character"]);
        upPorcent(92, "spooky2", ["character"]);
        upPorcent(93, "spooky3", ["character"]);
        upPorcent(94, "spooky4", ["character"]);
        upPorcent(95, "spooky5", ["character"]);
        upPorcent(96, "Stage/spookys/" + "spooky-full", ["character"]);

        //EvilGame
        upPorcent(97, "EvilGame/" + "BoyfriendOrigin", ["character"]);
        upPorcent(98, "EvilGame/" + "None", ["character"]);
        upPorcent(99, "EvilGame/" + "pico_illusion", ["character"]);

        upPorcent(100, "noteSkins/NOTE_assets", ["Others"]);
        
}

    function textPause(textS:Int) {
        if (textS == 0) {
        if (ClientPrefs.data.language == 'Spanish') {
            infoPause.text = "PRESIONE 'TAB' PARA SALTAR LA CARGA MANUAL";
        } else if (ClientPrefs.data.language == 'Inglish') {
            infoPause.text = "PRESS 'TAB' TO SKIP MANUAL LOAD";
        } else {
            infoPause.text = "PRESSIONE 'TAB' PARA PULAR O CARREGAMENTO MANUAL";
        }
        alphaMAX = 0.8;
    } else if (textS == 1) {
        if (ClientPrefs.data.language == 'Spanish') {
            infoPause.text = "¿ESTAS SEGURO DE SALTAR LA CARGA MANUAL?\n'ENTER': CONFIRMAR\n'ESCAPE(ESC): CANCELAR'";
        } else if (ClientPrefs.data.language == 'Inglish') {
            infoPause.text = "ARE YOU SURE YOU WANT TO SKIP MANUAL LOAD?\n'ENTER': CONFIRM\n'ESCAPE(ESC): CANCEL'";
        } else {
            infoPause.text = "TEM CERTEZA QUE DESEJA PULAR O CARREGAMENTO MANUAL?\n'ENTER': CONFIRMAR\n'ESCAPE(ESC): CANCELAR'";
        }
        alphaMAX = 0.3;
    } else if (textS == 2) {
        if (ClientPrefs.data.language == 'Spanish') {
            infoPause.text = "SE A CANCELADO LA CARGA MANUAL";
        } else if (ClientPrefs.data.language == 'Inglish') {
            infoPause.text = "MANUAL LOAD HAS BEEN CANCELLED";
        } else {
            infoPause.text = "O CARREGAMENTO MANUAL FOI CANCELADO";
        }
        alphaMAX = 0.5;
    } else if (textS == 3) {
        if (ClientPrefs.data.language == 'Spanish') {
            infoPause.text = "INPUT DE CANCELACION DESACTIVADO";
        } else if (ClientPrefs.data.language == 'Inglish') {
            infoPause.text = "CANCELLATION INPUT DISABLED";
        } else {
            infoPause.text = "ENTRADA DE CANCELAMENTO DESATIVADA";
        }
        alphaMAX = 0.5;
    }
    }

    public function divisionCargaCompleta() {
        inputStatus = false;
        textPause(3);
        statusMode.text = 'CARGA RAPIDA COMPLETA - ${ClientPrefs.data.cacheSaveKbs}kbs CARGADOS - CARGANDO JUEGO...';
        MusicBeatState.switchState(new system.DivisionDeCaminos());
    }

    private function clearShader():Void
        {
            //CameraShaderManager.clearShader();
        }

    override public function destroy():Void
        {
            // Limpiar shaders antes de destruir el estado
            if (statusMode != null)
            {
                statusMode.destroy();
                statusMode = null;
            }

            if (infoPause != null) {
                infoPause.destroy();
                infoPause = null;
            }
    
            //CameraShaderManager.clearShader();
            //ShaderManager.destroyAllShaders();
            super.destroy();
        }

    override public function update(elapsed:Float):Void {

        //CameraShaderManager.update(elapsed);

        if (value == 100) {
            value = 0;
            divisionCargaCompleta();
        }

        if (inputStatus) {
        if (!pausaMODE && FlxG.keys.justPressed.TAB && value != 0) {
            pausaMODE = true;
            textPause(1);
        }

        if (pausaMODE) {
            if (FlxG.keys.justPressed.ENTER) {
                FlxTimer.globalManager.clear();
                textPause(2);
                pausaMODE = false;
                value = 100;
            } else if (FlxG.keys.justPressed.ESCAPE) {
                textPause(0);
                pausaMODE = false;
            }
        }
    }

        super.update(elapsed);
    }
}

/*/////////////////////////////////////////////////////////

//codigo nuevo
package states.inicio;

import flixel.ui.FlxButton;
import flixel.FlxSubState;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.ui.FlxUIPopup;
import openfl.Assets;
import haxe.Http;

class StartingState extends FlxState
{

    public static var updateVersion:String = '';
	public static var updateVersionEC:String = '';
	public static var editorverification:String = 'disabled';
	public static var editorpermiss:String = '';
	public static var releasevideolink:String = '';
	public static var pathVersionOnline:String = '';
	public static var pathVersionOnlineM:Bool = false;
    public static var editorresult:Bool;
    public static var UpdateEC:Bool = false;

    private var bg:FlxSprite;
    private var statusText:FlxText;
    private var progressBar:FlxSprite;
    private var progressText:FlxText;

    private var totalAssets:Int = 100;
    private var loadedAssets:Int = 0;
    private var errorAssets:Int = 0;

    private var isLoading:Bool = true;

    override public function create():Void
    {
        super.create();

        FlxG.mouse.visible = false;

        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(bg);

        statusText = new FlxText(0, FlxG.height - 40, FlxG.width, "Cargando...");
        statusText.setFormat(null, 16, FlxColor.WHITE, CENTER);
        add(statusText);

        progressBar = new FlxSprite(0, FlxG.height - 20).makeGraphic(FlxG.width, 20, FlxColor.WHITE);
        progressBar.scale.x = 0;
        add(progressBar);

        progressText = new FlxText(0, FlxG.height - 60, FlxG.width, "0%");
        progressText.setFormat(null, 24, FlxColor.WHITE, CENTER);
        add(progressText);

        //MusicBeatState.updatestate('URLS LOADERS');


        if (!ClientPrefs.data.noneNet) {
		trace('OBTENIENDO DATOS EL ULTIMO VIDEO SUBIDO');
		var htss = new haxe.Http("https://raw.githubusercontent.com/ThonnyDevYT/FNFVersion/main/Link_video.txt");
        htss.onData = function (data:String)
			{
				releasevideolink = data.split("*")[0].trim();
				trace("SE OBTUVO UN VALOR DE TIPO 'string': [" + releasevideolink + "]");
			}
			htss.onError = function (error) {
				trace('SUCEDIO UN ERROR FATAL: $error');
				trace('ERROR AL QUERER CARGAR EK ULTIMO VIDEO PUBLICADO, SE UTILIZARA EL URL ALMACENADO');
				releasevideolink = "https://www.youtube.com/watch?v=M67O8wIE-2U";
			}
            htss.request();

        /////////////////////////////////////
		trace('OBTENIENDO DATOS DEL ULTIMO PARCHE');
        pathVersionOnline = OnlineUtil.pathOnline();
        trace("SE OBTUVO UN VALOR DE TIPO 'VERSION': [" + pathVersionOnline + "]");

        if (pathVersionOnline != ClientPrefs.data.pathVersion) {
            pathVersionOnlineM = true;
            trace('SE ESTABLECIO QUE ESTE PATH DEBE SER DESCARGADO E INSTALADO');
        }
        if (pathVersionOnline == null) {
            pathVersionOnlineM = false;
            trace('EL PATH NO DEBE SER DESCARGADO O INSTALADO EN EL JUEGO');
        }

        ////////////////////////////////
		trace('OBTENIENDO DATOS DE LOS PERMISOS DE ADMINISTRADOR PUBLICOS');
		var htsp = new haxe.Http("https://raw.githubusercontent.com/ThonnyDevYT/FNFVersion/main/Editor-Permiss.txt");
			htsp.onData = function (data:String)
				{
					editorpermiss = data.split("!")[0].trim();
					var curVerificator:String = editorverification.trim();
					trace('SE OBTUVO UN VALOR DE TIPO "bool": [' + editorpermiss + "]");
					if (editorpermiss != curVerificator) {
						trace('EL VALOR ESTA RESULTANDO SER ACTIVADO');
						editorresult = true;
                        trace('SE HABILITARON LOS EDITORES');
					}
					if (editorpermiss == curVerificator) {
						trace('EL VALOR ESTA RESULTANDO SER DESACTIVADO');
						editorresult = false;
                        trace('SE BLOQUEO LOS EDITORES');
					}
				}
			htsp.onError = function (error) {
                trace('SE DETUVO LA OPERACION DE URL PARA LA DIRECCION: [' + htsp.url + ']');
				trace('SUCEDIO UN ERROR FATA: $error');
				trace('SE BLOQUEARAN LOS PERMISOS A LOS EDITORES POR SEGURIDAD...');
				editorresult = false;
                trace('SE BLOQUEO LOS EDITORES');
			}
            htsp.request();

        ///////////////////////////////////
		trace('OBTENIENDO DATOS DE LA ULTIMA VERSION LANZADA');
        updateVersionEC = OnlineUtil.versionOnline();
        var curVersionEC:String = ClientPrefs.data.tempName[1];
        trace('SE OBTUVO LA VERSION ACTUAL DE TU JUEGO');
        trace('LA VERSION ACTUAL DEL SERVIDOR ES: ' + updateVersionEC + ', \nLA VERSION ACTUAL DE TU JUEGO ES: ' + curVersionEC);
        if(updateVersionEC != curVersionEC) {
                trace('LAS VERSIONES NO COINCIDEN [REQUIERE ACTUALIZACION]');
                UpdateEC = true;
                trace('TU VERSION A SIDO ESTABLECIDA EN DESACTUALIZADA');
        } else {
            trace('LAS VERSIONES COINCIDEN [NO REQUIERE ACTUALIZACION]');
            UpdateEC = false;
            trace('TU VERSION SERA MANTENIDA EN ACTUALIZADA');
        }
        ///////////////////////////////////////
        } else {
            editorresult = false;
            trace('SE BLOQUEO LOS EDITORES');
            releasevideolink = "https://www.youtube.com/watch?v=M67O8wIE-2U";
            trace('ERROR AL QUERER CARGAR EK ULTIMO VIDEO PUBLICADO, SE UTILIZARA EL URL ALMACENADO');
            trace('LAS CARGAS DE DATOS ONLINE SE A DESABILITADO POR BLOQUEO DEL SERVICIO "NETWORK"');
        }

        startLoading();
    }

    private function startLoading():Void
    {
        new FlxTimer().start(0.05, function(timer:FlxTimer) {
            if (isLoading) {
                loadNextAsset();
            }
        }, 0);
    }

    private function loadNextAsset():Void
    {
        if (loadedAssets < totalAssets) {
            var assetName:String = "asset_" + loadedAssets;
            loadAsset(assetName);
        } else {
            finishLoading();
        }
    }

    private function loadAsset(assetName:String):Void
    {
        new FlxTimer().start(0.1, function(timer:FlxTimer) {
            if (FlxG.random.bool(90)) {
                loadedAssets++;
                updateProgress();
            } else {
                errorAssets++;
                trace("Error al cargar: " + assetName);
            }
        });
    }

    private function updateProgress():Void
    {
        var progress:Float = loadedAssets / totalAssets;
        FlxTween.tween(progressBar.scale, {x: progress}, 0.2, {ease: FlxEase.quadOut});
        progressText.text = Std.int(progress * 100) + "%";
        statusText.text = 'Cargando... (${loadedAssets}/${totalAssets})';
    }

    private function finishLoading():Void
    {
        isLoading = false;
        statusText.text = 'Carga completada. Errores: ${errorAssets}';
        new FlxTimer().start(2, function(timer:FlxTimer) {
            FlxG.switchState(new TitleState());
        });
    }


    private function showSkipPopup():Void
    {
        isLoading = false; // Pausa la carga
        openSubState(new SkipLoadingPopup(onPopupSelection));
    }

    private function onPopupSelection(skip:Bool):Void
    {
        if (skip) {
            finishLoading();
        } else {
            isLoading = true; // Reanuda la carga
        }
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.TAB && isLoading) {
            showSkipPopup();
        }
    }

    override public function destroy():Void
    {
        super.destroy();
    }
}

class SkipLoadingPopup extends FlxSubState
{
    private var callback:Bool->Void;

    public function new(callback:Bool->Void)
    {
        super();
        this.callback = callback;
    }

    override public function create():Void
    {
        super.create();

        var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0x80000000);
        add(bg);

        var popupBg = new FlxSprite(0, 0).makeGraphic(300, 200, FlxColor.WHITE);
        popupBg.screenCenter();
        add(popupBg);

        var titleText = new FlxText(0, popupBg.y + 20, FlxG.width, "¿Saltar carga?");
        titleText.setFormat(null, 20, FlxColor.BLACK, CENTER);
        add(titleText);

        var messageText = new FlxText(popupBg.x + 10, titleText.y + 40, 280, "¿Estás seguro de que quieres saltar la carga?\nEsto podría afectar el rendimiento del juego.");
        messageText.setFormat(null, 16, FlxColor.BLACK, CENTER);
        add(messageText);

        var yesButton = new FlxButton(popupBg.x + 50, popupBg.y + 150, "Sí", function() {
            close();
            callback(true);
        });
        add(yesButton);

        var noButton = new FlxButton(popupBg.x + 170, popupBg.y + 150, "No", function() {
            close();
            callback(false);
        });
        add(noButton);

        FlxTween.tween(bg, {alpha: 1}, 0.3, {ease: FlxEase.quartOut});
        FlxTween.tween(popupBg, {y: popupBg.y - 20}, 0.3, {ease: FlxEase.backOut});
    }
}*/
