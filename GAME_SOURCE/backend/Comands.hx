package backend;

import flixel.FlxState;
import openfl.display.Console;
import openfl.system.Capabilities;

class Comands extends MusicBeatState {
    
    public static var arm:String;

    public function new(key:String) {

        if (key != null) {
            send(key);
            
        } else {
            Console.addDebug('ERROR!! - ARGUMENT IS NULL');
            trace('ERROR!! - ARGUMENT IS NULL');
        }

        super();
    }

    function send(key:String) {

        //key.toLowerCase();

        var result:Array<String>;
        if (key != null && key != '') {
            commandsystem(key);
            
        } else {
            Console.addDebug('NOTHING SPECIFIED');
            result = ['nothing specified', 'ERROR'];
            trace('Comando no Especificado!!');
        }
    }

    function commandsystem(key:String) {

        var consoleMessenger:Array<String> = [null, ''];

        if (key.contains('!') == true) {
            commands(key);
            
        } else if (key == '!') {
            consoleMessenger = ['HELP:\n\n!ClientPrefs (variable) (valor)\n!Project.xml (titulo)\n#reset\n!changebackgroundmusic (Nombre de la musica) (volumen)\n!volume (Volumen [0.0...1.0])\n!resolution (Width/X) (Height/Y)', ''];
            Console.addDebug('HELP:\n\n!ClientPrefs (variable) (valor)\n!Project.xml (titulo)\n#reset\n!changebackgroundmusic (Nombre de la musica) (volumen)\n!volume (Volumen [0.0...1.0])\n!resolution (Width/X) (Height/Y)');
            trace('HELP:\n\n!ClientPrefs (variable) (valor)\n!Project.xml (titulo)\n#reset\n!changebackgroundmusic (Nombre de la musica) (volumen)\n!volume (Volumen [0.0...1.0])\n!resolution (Width/X) (Height/Y)');
        } else {
            Console.addDebug('ERROR IN COMMAND INTERPRETATION');
            consoleMessenger = ['ERROR IN COMMAND INTERPRETATION', 'ERROR'];
            trace('Argued for missing commands');
        }

        if (consoleMessenger[0] == 'ERROR') {
            Console.addDebug('UNEXPEXTED ERROR');
            consoleMessenger = ['unexpected error'.toUpperCase(), 'ERROR'];
            trace('Incorrect Arguments');
        }
        
    }

    function commands(arguments:String) {

        var argumentos:Array<String> = arguments.split(" ");
        argumentos[0] = argumentos[0].toLowerCase();

        for (i in 1...argumentos.length) {
            argumentos[i].replace('-', ' ');
        }

        if (argumentos[0] == '!clientprefs') { 
            Reflect.setProperty(ClientPrefs.data, argumentos[1], argumentos[2]);
            arm = 'Argumento Cambiado Resultado: ClientPrefs.data.' + argumentos[1] + ' == ' + Reflect.getProperty(ClientPrefs.data, argumentos[1]);
        } else if (argumentos[0] == '!proyect.xml') {
            Lib.application.window.title = argumentos[1];
            arm = 'Argumento de Titulo Cambiado, Nuevo Valor: ' + Lib.application.window.title;
        } else if (argumentos[0] == '#reset') {
            arm = 'Reseteando...';
            new FlxTimer().start(FlxG.random.float(1, 2.5), function(Timer:FlxTimer) FlxG.resetGame(), 1);
        } else if (argumentos[0] == '!changebackgroundmusic') {
            FlxG.sound.playMusic(Paths.music(argumentos[1]), Std.parseFloat(argumentos[2]), true);
            arm = 'Musica Cambiada, Nueva Musica: ' + argumentos[1];
        } else if (argumentos[0] == '!volume') {
            if ((Std.parseFloat(argumentos[1])) <= 1) {
            FlxG.sound.volume = Std.parseFloat(argumentos[1]);
            arm = 'Volumen General Actualizado a: ' + Std.parseFloat(argumentos[1]);
            } else {
                arm = 'VALOR DE VOLUMEN DESCONOCIDO';
            }
        } else if (argumentos[0] == '!resolution') {
            if ((Std.parseFloat((argumentos[1]))) <= Capabilities.screenResolutionX || (Std.parseFloat(argumentos[2])) <= Capabilities.screenResolutionY) {
                FlxG.resizeWindow(Std.int(Std.parseFloat((argumentos[1]))), Std.int(Std.parseFloat(argumentos[2])));
                FlxG.resizeGame(Std.int(Std.parseFloat((argumentos[1]))), Std.int(Std.parseFloat(argumentos[2])));

                arm = 'Resolucion Actualizada: ' + Std.int(Std.parseFloat((argumentos[1]))) + 'px X ' + Std.int(Std.parseFloat(argumentos[2])) + 'px';
            } else if ((Std.parseFloat((argumentos[1]))) <= (Capabilities.screenResolutionX) / 3 || (Std.parseFloat(argumentos[2])) <= (Capabilities.screenResolutionY) / 3) {
                arm = 'RESOLUCION NO SOPORTADA';
            } else {
                arm = 'ERROR DESCONOCIDO';
            }
        } else if (argumentos[0] == '!openweb') {
            //Nuevo Comando - Puede abrir links de internet solo ingresando su URL. Esto es solo inutil ya que puedes mejor hacerlo desde tu Navegador. XD
            try {
            FlxG.openURL(argumentos[1]);
            arm = 'OPEN URL: ' + argumentos[1];
            } catch(e:Dynamic) {
                arm = 'ERROR: ' + e;
            }
        } else if(argumentos[0] == '!') {
            arm = 'HELP:\n\n!ClientPrefs (variable) (valor)\n!Project.xml (titulo)\n#reset\n!changebackgroundmusic (Nombre de la musica) (volumen)\n!volume (Volumen [0.0...1.0])\n!resolution (Width/X) (Height/Y)\n!openWeb (url)';
        } else if (argumentos[0] == '!nextstate') {
            switchStateFromString(argumentos[1]);
        } else if (argumentos[0] == '!variable') {
            Reflect.setProperty(argumentos[1], argumentos[2], argumentos[3]);
            trace('ERROR VALOR/VARIABLE O EXTENSION INCORRECTOS');
            arm = "ERROR VALOR/VARIABLE O EXTENSION INCORRECTOS";
        } else {
            arm = 'COMANDO DESCONOCIDO O NO ENCONTRADO';
        }
        
        Console.addDebug(arm);

    }

    public static function switchStateFromString(stateName:String, ?fastState:Bool = false):Void {
        var stateClass:Class<Dynamic> = Type.resolveClass(stateName);
        if (stateClass != null && Type.getClassName(stateClass).indexOf("flixel.FlxState") != -1) {
            var stateInstance:FlxState = Type.createInstance(stateClass, []);
            if (fastState) {
                MusicBeatState.fastSwitchState(stateInstance);
            } else {
                MusicBeatState.switchState(stateInstance);
            }
        } else {
            trace("Class not found or not a FlxState subclass");
        }
    }
}