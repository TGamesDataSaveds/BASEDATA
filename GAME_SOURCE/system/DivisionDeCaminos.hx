package system;

import states.TitleState;
import states.FlashingState;

class DivisionDeCaminos extends MusicBeatState {

    override function create() {
        Main.fpsVar.x = 10;
        Main.fpsVar.y = 7;
        if (ClientPrefs.data.primera_vez) {
            if (ClientPrefs.data.flashing) {
            MusicBeatState.switchState(new FlashingState());
            trace('!!PRIMERA VEZ!!\nTE DAREMOS LA BIENVENIDA...');
            }
        } else {
            MusicBeatState.switchState(new TitleState());
            trace('INICIANDO JUEGO...');
        }
    }
}