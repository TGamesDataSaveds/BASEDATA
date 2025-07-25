package system;

class WindowProperty {

    public static function VolumeControlls(active:Bool = true) {
        if (active == true) {
            WindowsHX.togleVolume("reset");
        } else {
            WindowsHX.togleVolume("clear");
        }
    }
    public static function WindowMouseLOCK() {
        WindowsHX.windowMouseLOCKED(true);
    }
    public static function WindowMouseUNLOCK() {
        WindowsHX.windowMouseLOCKED(false);
    }
}

class WindowsHX {
    public static function windowMouseLOCKED(lock:Bool = false) {
        trace('SE EJCUTO UN VALOR A "game.application.window.mouselock"...');
        if (lock) {
            Lib.application.window.mouseLock = true;
        } else {
            Lib.application.window.mouseLock = false;
        }
        trace('SE ESTABLECIO UN VALOR DE TIPO "bool" A "game.application.mouselock" EN "' + lock + '"');
    }

    public static function togleVolume(space:String) {
        trace('SE EJCUTO UNA FUNCION A "game.application.window.sound" [ESPERANDO RESPUESTA]...');
        space.toLowerCase();
        if (space == "clear") {
            trace('VALOR DE TIPO "SPACE" FUE ESTABLECIDO EN ".clear", EJECUTANDO CAMBIOS...');
            FlxG.sound.muteKeys = [];
            trace('"FlxG.sound.muteKeys" A SIDO ESTABLECIDO EN: [NULL]');
            FlxG.sound.volumeUpKeys = [];
            trace('"FlxG.soundUpKeys" A SIDO ESTABLECIDO EN: [NULL]');
            FlxG.sound.volumeDownKeys = [];
            trace('"FlxG.sound.volumeDownKeys" A SIDO ESTABLECIDO EN: [NULL]');
            trace('LOS CAMBIOS DE TIPO ".clear" FUERON APLICADOR, CERRANDO FUNCION...');
            trace('!FUNCION CERRADA CON EXITO!');
        } else if (space == "reset") {
            trace('VALOR DE TIPO "SPACE" FUE ESTABLECIDO EN ".reset" EJECUTANDO CAMBIOS...');
            FlxG.sound.muteKeys = [ZERO, NUMPADZERO];
            trace('"FlxG.sound.muteKeys" A SIDO ESTABLECIDO EN: [ZERO, NUMPADZERO]');
            FlxG.sound.volumeUpKeys = [PLUS, NUMPADPLUS];
            trace('"FlxG.soundUpKeys" A SIDO ESTABLECIDO EN: [PLUS, NUMPADPLUS]');
            FlxG.sound.volumeDownKeys = [MINUS, NUMPADMINUS];
            trace('"FlxG.sound.volumeDownKeys" A SIDO ESTABLECIDO EN: [MINUS, NUMPADMINUS]');
            trace('LOS CAMBIOS DE TIPO ".reset" FUERON APLICADOR, CERRANDO FUNCION...');
            trace('!FUNCION CERRADA CON EXITO!');
        } else {
            trace('INFORMCACION DE TIPO "SPACE" ES INVALIDO');
            trace('LA INFORMACION DE TIPO "SPACE" FUE ESTABLECIDA EN ".' + space + '", CERRANDO FUNCION');
        }
    }
}