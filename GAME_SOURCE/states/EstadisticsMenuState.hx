package states;

import flixel.FlxSubState;

import flixel.effects.FlxFlicker;
import lime.app.Application;
//

import states.PlayState;

class EstadisticsMenuState extends MusicBeatState {

    var BaseText:FlxText;

    var ESTEXT:Array<String> = ['Notas Presionadas', 'Notas Falladas', 'Muertes', 'Puntaje Total', 'COINS'];
    var ESCOLOR:Array<FlxColor> = [FlxColor.CYAN, FlxColor.RED, FlxColor.GRAY, FlxColor.YELLOW, FlxColor.ORANGE];
    var ESDATA:Array<Dynamic> = [PlayState.hitnotesong, PlayState.missNotesong, PlayState.deaths, PlayState.scoresTotal, PlayState.pointsWin];
    var ESMULTI:Array<Float> = [10, 50, 100, 150, 200];

    override function create() {
        super.create();

        MusicBeatState.updatestate("Stadistics Menu");

        var bg:FlxSprite = new FlxSprite().makeGraphic(0, 0, FlxColor.BLACK);
        add(bg);

        for (i in 0...4) {
            var estadisticText:FlxText = new FlxText(5, ESMULTI[i], FlxG.width, ESTEXT[i] + ': ' + ESDATA[i], 32);
            estadisticText.setFormat("VCR OSD Mono", 32, FlxColor.BLACK, LEFT, OUTLINE_FAST, ESCOLOR[i]);
            estadisticText.antialiasing = ClientPrefs.data.antialiasing;
            add(estadisticText);
        }

        #if desktop
        DiscordClient.changePresence("ESTADISTICS MENU", null);
        #end

    }

    override function update(elapsed:Float) {
        var back:Bool = controls.BACK;

        if (back) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
        }
         super.update(elapsed);
    }
}