package openfl.display;

import openfl.system.Capabilities;
import backend.Comands;
import lime.tools.Command;
import backend.Commands;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUIList;

import openfl.display.FPS;

class Console extends MusicBeatSubstate {

    var textBar:FlxUIInputText;
    var BG:FlxSprite;
    var historialText:String = "...Mas";
    public static var historialUI:FlxText;
    var historial:FlxUIList;
    var textResult:Array<String>;
    public static var errorACTUAL:String = '';

    var title:FlxText;
    var varFPS = openfl.display.FPS;

    var lolEgg:String = ':';
    var TIMERGLOBAL:String;

    var debug1:FlxText;
    var debug2:FlxText;
    var debug3:FlxText;
    var debug4:FlxText;

    override function create() {

        TIMERGLOBAL = '00' + lolEgg + '00\n00/00/0000';
        //var heightPlus:Float = FlxG.height - textBar.height - 20;

        BG = new FlxSprite(0, 0).makeGraphic(FlxG.width + 200, FlxG.height + 200, 0x8A000000);
        BG.screenCenter();
        BG.alpha = 0;
        BG.cameras = null;
        add(BG);
        FlxTween.tween(BG, {alpha: 1}, 0.5, {
            onComplete: function(twn:FlxTween) {
                textBar.visible = true;
            }
        });

        textBar = new FlxUIInputText(0, 0, FlxG.width - 10, "Ingrese Un Comando", 25);
        textBar.screenCenter(X);
        textBar.y = FlxG.height - textBar.height - 15;
        textBar.visible = false;
        //textBar.camera = null;

        historialUI = new FlxText(15, 0, FlxG.width - 5, ClientPrefs.data.consoleHistorial, 20);
        historialUI.antialiasing = ClientPrefs.data.antialiasing;
        historialUI.setFormat(Paths.font("new/BUND.otf"), 20, FlxColor.WHITE, LEFT, FlxColor.BLACK);
        historialUI.y = FlxG.height - textBar.height - 140;
        //historialUI.camera = null;

        add(historialUI);
        addDebug('\n----------\n\nUTILIZE EL "!" PARA USAR COMANDOS');
        add(textBar);

        title = new FlxText(5, 10, FlxG.width - 5, TIMERGLOBAL, 32);
        title.font = Paths.font("new/BUND.otf");
        title.antialiasing = ClientPrefs.data.antialiasing;
        add(title);

        new FlxTimer().start(1, function(Timer:FlxTimer) {
            if (lolEgg == ':') {
            lolEgg = ' ';
            } else {
                lolEgg = ':';
            }
        }, 0);

        debug1 = new FlxText(0, 10, 0, "MENU: " + MusicBeatState.stateName, 18);
        debug1.setFormat(Paths.font("new/BUND.otf"), 28, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
        debug1.antialiasing = ClientPrefs.data.antialiasing;
        add(debug1);

        debug2 = new FlxText(0, 40, 0, "DATA: " + ClientPrefs.data.Data, 18);
        debug2.setFormat(Paths.font("new/BUND.otf"), 28, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
        debug2.antialiasing = ClientPrefs.data.antialiasing;
        add(debug2);

        debug3 = new FlxText(0, 80, 0, "RESOLUTION: " + FlxG.width + 'x' + FlxG.height, 18);
        debug3.setFormat(Paths.font("new/BUND.otf"), 28, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
        debug3.antialiasing = ClientPrefs.data.antialiasing;
        add(debug3);

        debug4 = new FlxText(0, 120, 0, "CONSOLE VERSION:\n1.3(ALPHA)", 18);
        debug4.setFormat(Paths.font("new/BUND.otf"), 28, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
        debug4.antialiasing = ClientPrefs.data.antialiasing;
        add(debug4);

        super.create();
    }

    public static function addDebug(text:String) {
        ClientPrefs.data.consoleHistorial += '\n' + text;
        var linesCounter:Int = text.split("\n").length + 1;
        historialUI.text = ClientPrefs.data.consoleHistorial;
        historialUI.y -= 18 * linesCounter;
        trace('DEBUG: ' + text);
    }

    override function update(elapsed:Float) {

        if (FlxG.mouse.overlaps(textBar) && FlxG.mouse.justPressed && textBar.text == 'Ingrese Un Comando') {
            textBar.text = "";
        }

        if (FlxG.keys.justPressed.ENTER) {
            add(new Comands(textBar.text));
            addDebug(Comands.arm);
            textBar.text = "";    
        }

        if (FlxG.keys.justPressed.ESCAPE) {
            textBar.visible = false;
            FlxTween.cancelTweensOf(BG);
            FlxTween.tween(BG, {alpha: 0}, 0.5);

            varFPS.activeStatus = false;

            close();
        }

        if (lolEgg != '') {
            TIMERGLOBAL = ClientPrefs.data.Date[3] + lolEgg + ClientPrefs.data.Date[4] + lolEgg + ClientPrefs.data.Date[5] + '\n' + ClientPrefs.data.Date[0] + '/' + ClientPrefs.data.Date[1] + '/' + ClientPrefs.data.Date[2];
        } else {
            TIMERGLOBAL = ClientPrefs.data.Date[3] + ' ' + ClientPrefs.data.Date[4] + ' ' + ClientPrefs.data.Date[5] + '\n' + ClientPrefs.data.Date[0] + '/' + ClientPrefs.data.Date[1] + '/' + ClientPrefs.data.Date[2];
        }
        title.text = 'CONSOLA\n' + TIMERGLOBAL;

        debug1.x = FlxG.width - debug1.width - 5;
        debug1.text = "MENU: " + MusicBeatState.stateName;

        debug2.x = FlxG.width - debug2.width - 5;
        debug2.text = 'DATA: ' + ClientPrefs.data.Data;

        debug3.x = FlxG.width - debug3.width - 5;
        debug3.text = 'RESOLUTION: ' + Lib.application.window.width + 'x' + Lib.application.window.height + '/' + Capabilities.screenResolutionX + 'x' + Capabilities.screenResolutionY;
        if (Lib.application.window.width > Capabilities.screenResolutionX) {
            debug3.color = FlxColor.RED;
        } else if (Lib.application.window.height > Capabilities.screenResolutionY) {
            debug3.color = FlxColor.RED;
        } else if (Lib.application.window.height <= Capabilities.screenResolutionY && Lib.application.window.width <= Capabilities.screenResolutionX) {
            debug3.color  = FlxColor.WHITE;
        } else {
            debug3.color = FlxColor.GRAY;
        }

        debug4.x = FlxG.width - debug4.width - 5;
        debug4.text = "CONSOLE VERSION:\n1.3(ALPHA)";

        super.update(elapsed);
    }
}