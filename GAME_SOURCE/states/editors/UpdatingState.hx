package states.editors;

import backend.OnlineUtil;
import openfl.utils.Promise;
import openfl.utils.Timer;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

import sys.io.File;
import sys.net.Host;

class UpdatingState extends MusicBeatState
{

    private var remoteImage:flixel.FlxSprite;

    var porcent:Int = 0;
    var porcentText:FlxText;
    var exitText:FlxText;

    var status:Bool = false;
    var net:Bool = true;

    var loadTimer:FlxTimer;
    var loadConexion:FlxTimer;
    var bg:FlxSprite;

    var pathVersionOnline:String;
    var baseMbs:String;

    var pathtext:String = '';

    var loadText:FlxText;

    var isPaused:Bool;
    var remainingTime:Float;

    var statusPorcent:Float;

    public function onCarga(Timer:FlxTimer) {

        if (net == true) {
            status = true;
        porcentText.text = "Iniciando Instalacion...\n\nIniciando TitleMenu...".toUpperCase();

        FlxTween.tween(bg, {alpha: 0}, FlxG.random.int(5, 8), {
            onComplete: function(twn:FlxTween) {

                porcentText.text = "Instalacion Completa Path Actualizado a la Version [" + pathVersionOnline + "]\n\nExito...".toUpperCase();
                ClientPrefs.data.start = false;
                ClientPrefs.data.pathVersion = pathVersionOnline;
                ClientPrefs.saveSettings();
                ClientPrefs.loadPrefs();

                File.saveContent("assets/system/path_" + FlxG.random.int(0, 99) + FlxG.random.int(0, 99) + ".txt", pathtext);

                trace('ClientPrefs.data.pathVersion == ' + ClientPrefs.data.pathVersion);

                if (ClientPrefs.data.music == 'Disabled') {
                    FlxG.sound.playMusic(Paths.music('none'), 0);
                } else {
                    FlxG.sound.playMusic(Paths.music(ClientPrefs.data.music), 0);
                }

                MusicBeatState.updateFPS();
    
                FlxG.sound.music.fadeIn(0.2, 0, 1, function (twn:FlxTween) {
                    #if desktop
                    DiscordClient.changePresence("TITLE MENU", null);
                    #end
                        MusicBeatState.switchState(new TitleState());
                    });
            }
        });
    }
    if (net == false) {
        #if desktop
        DiscordClient.changePresence("ERROR DOWNLOAD", null);
        #end
        porcentText.text = "Reintentando Descarga...".toUpperCase();
        loadTimer.start(FlxG.random.int(10, 40), onCarga, 1);
    }
    }

    private function pauseTimer(newStatus:Bool):Void {
        if (!newStatus && loadTimer.active == false) {
            // Reanuda el temporizador
            loadTimer.start(remainingTime, onCarga);
            isPaused = false;
            trace('TIMER REANUDADO');
        } else {
            // Pausa el temporizador
            remainingTime = loadTimer.timeLeft;
            loadTimer.cancel();
            isPaused = true;
            statusPorcent = CoolUtil.floatToInt(CoolUtil.floorDecimal(remainingTime, 2));
            trace('TIMER PAUSADO');
        }
    }

    private function checkPathText() {
        var htpss = new haxe.Http("https://raw.githubusercontent.com/ThonnyDevYT/FNFVersion/main/PathSystem");

        htpss.onData = function (data:String)
            {
                pathtext = data.split("]")[0].trim();
            }

            htpss.onError = function (error) {
                trace('error: $error');
            }

            htpss.request();
    }

    override function create() {


    isPaused = false;

    pathVersionOnline = OnlineUtil.pathOnline();
    checkPathText();

    FlxG.sound.music.fadeOut(4, 0.3);
    loadTimer = new FlxTimer();
    loadConexion = new FlxTimer();

    bg = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0x000000);
    add(bg);

    porcentText = new FlxText(0, 0, FlxG.width, "", 32);
    porcentText.setFormat(Paths.font("new/BUND.otf"), 32, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
    porcentText.screenCenter();
    porcentText.antialiasing = ClientPrefs.data.antialiasing;
    porcentText.scrollFactor.set();
    add(porcentText);

    exitText = new FlxText(0, FlxG.height - 40, FlxG.width, "", 32);
    exitText.setFormat(Paths.font("new/BUND.otf"), 32, FlxColor.BLACK, CENTER, OUTLINE, FlxColor.RED);
    exitText.antialiasing = ClientPrefs.data.antialiasing;
    exitText.screenCenter(X);
    exitText.scrollFactor.set();
    add(exitText);

    loadText = new FlxText(0, 0, FlxG.width, "...", 28);
    loadText.alignment = RIGHT;
    loadText.antialiasing = ClientPrefs.data.antialiasing;
    loadText.font = Paths.font("new/BUND.otf");
    loadText.y = FlxG.height - loadText.height;
    add(loadText);

    porcent = FlxG.random.int(0, 5);

    loadTimer = new FlxTimer().start(FlxG.random.int(10, 40), onCarga, 1);
    new FlxTimer().start(0.1, function(Timer:FlxTimer) checkInternetConnection(), 0);

    exitText.text = "Presiona Esc para Salir".toUpperCase();

    new FlxTimer().start(4, function(Timer:FlxTimer) {
        porcent = FlxG.random.int(0, 5, [porcent]);
    }, 0);

    #if desktop
    DiscordClient.changePresence("PATH DOWNLOADING MENU", null);
    #end

    statusPorcent = CoolUtil.floatToInt(CoolUtil.floorDecimal(loadTimer.progress, 2));

    }

    override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ESCAPE && net == false) {
            #if desktop
			DiscordClient.changePresence("TITLE MENU", null);
			#end
            MusicBeatState.switchState(new TitleState());
        }

        if (!isPaused && !loadTimer.finished) {
        loadText.text = CoolUtil.floatToInt(CoolUtil.floorDecimal(loadTimer.progress, 2)) + '%';
        } else if (!isPaused && !loadTimer.finished) {
        loadText.text = statusPorcent + '%';
        } else if (loadTimer.finished && !isPaused) {
        loadText.text = 'PATH: ' + OnlineUtil.pathOnline() + ' | 100%';
        }
        super.update(elapsed);
    }

    private function checkInternetConnection():Void
        {
            if (OnlineUtil.NetworkStatus() == true) {
                if (porcent == 0 && status == false) {
                    porcentText.text = "Se estan Descargando " + baseMbs +"MBs. Se instalaran en Segundo Plano...".toUpperCase();
                } else if (porcent == 1 && status == false) {
                    porcentText.text = "La Descarga a Iniciado no cierre el Juego Porfavor".toUpperCase();
                } else if (porcent == 2 && status == false) {
                    porcentText.text = "La descarga terminara en un instante estamos descargando todo lo necesario...".toUpperCase();
                } else if (porcent == 3 && status == false) {
                    porcentText.text = "Tu version " + ClientPrefs.data.endingCorruprion + " Esta Recibiendo un parche de Seguridad de " + baseMbs + "MBs".toUpperCase();
                } else if (porcent == 4 && status == false) {
                    porcentText.text = "El tiempo de Descarga depende de tu conexion a internet".toUpperCase();
                } else if (porcent == 5 && status == false) {
                    porcentText.text = "Los archivos descargados no son imagenes ni sonidos. son " + baseMbs +"MBs de archivos internos".toUpperCase();
                }

                net = true;
                exitText.visible = false;
                #if desktop
                DiscordClient.changePresence("PATH DOWNLOADING MENU", null);
                #end

                if(isPaused) {
                pauseTimer(false);
                }

            } else {
                
                if (porcent == 0 && status == false) {
                    porcentText.text = "Se estan Descargando los archivos necesarios. Se instalaran en Segundo Plano...\n\nLa Conexion a Internet se Perdio".toUpperCase();
                } else if (porcent == 1 && status == false) {
                    porcentText.text = "La Descarga a Iniciado no cierre el Juego Porfavor\n\nLa Descarga se Pauso ya que no se pudo continuar con la descarga".toUpperCase();
                } else if (porcent == 2 && status == false) {
                    porcentText.text = "La descarga terminara en un instante estamos descargando todo lo necesario...\n\nNo hemos podido utilizar la conexion a internet".toUpperCase();
                } else if (porcent == 3 && status == false) {
                    porcentText.text = "Tu version " + ClientPrefs.data.endingCorruprion + " Esta Recibiendo un parche de Seguridad\n\nIntentamos Reanudar la conexion...".toUpperCase();
                } else if (porcent == 4 && status == false) {
                    porcentText.text = "El tiempo de Descarga depende de tu conexion a internet\n\nVuelve a conectarte a Internet Porfavor".toUpperCase();
                } else if (porcent == 5 && status == false) {
                    porcentText.text = "Los archivos descargados no son imagenes ni sonidos. son archivos de sistema\n\nEl sistema no puede encontrar archivos. Esto puede ser por tu internet".toUpperCase();
                }

                net = false;
                exitText.visible = true;

                if (!isPaused) {
                pauseTimer(true);
                }
            }
        }
}