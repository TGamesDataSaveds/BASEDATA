package states;

import backend.InputFormatter;
import flixel.input.keyboard.FlxKey;
import flixel.system.macros.FlxMacroUtil;
import flixel.input.keyboard.FlxKey;
import lime.ui.Touch;
import lime.ui.ScanCode;
import lime.ui.Gamepad;
import flixel.input.actions.FlxActionInput.FlxInputDeviceObject;
import flixel.input.actions.FlxActionInput.FlxInputDevice;
import openfl.system.Capabilities;
import lime.system.System;
import openfl.system.System;

class InfoSystem extends MusicBeatState {

    var text:FlxText;
    var loadingIcon:FlxSprite;
    var input:FlxInputDeviceObject;

    var Gamepad:Gamepad;
    var touch:Touch;

    var haxeVERSION:String = 'Haxe Compiler 4.3.2 - (C)2005-2023 Haxe Foundation';
    var limeVERSION:String = 'Lime 8.1.1';
    var openflVERSION:String = 'OpenFL 9.3.2';
    var flixelVERSION:String = 'Flixel 5.6.2';

    public static var keyName:String;

    public static var LEFT:String;

    public static var key:String = null;

    //statusNet:Bool = false;

    override function create() {
        var BG:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(BG);

        text = new FlxText(0, 0, FlxG.width, "", 20);
        text.setFormat(Paths.font("new/BUND.otf"), 20, FlxColor.WHITE, RIGHT, OUTLINE, FlxColor.BLACK);
        text.antialiasing = ClientPrefs.data.antialiasing;
        add(text);

        loadingIcon = new FlxSprite(0, 0).loadGraphic(Paths.image("icons/Menu/loadingIcon"));
        loadingIcon.antialiasing = ClientPrefs.data.antialiasing;
        loadingIcon.scrollFactor.set();
        add(loadingIcon);

        FlxTween.tween(loadingIcon, {y: FlxG.height - loadingIcon.height}, 0.1);

        if (!ClientPrefs.data.noneAnimations) {
            FlxTween.angle(loadingIcon, 0, 360, 1.5, {
                ease: FlxEase.circInOut,
                type: LOOPING
            });
        }

        #if desktop
        DiscordClient.changePresence("INFO SYSTEM MENU", null);
        #end

        for (n in 1...2) {
            var savKey:Array<Null<FlxKey>> = ClientPrefs.keyBinds.get('note_left');
            key = InputFormatter.getKeyName((savKey[n] != null) ? savKey[n] : NONE);
        }

        super.create();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);


        text.text = '-|SYSTEM INFO|-\n\nFPS: ' 
        + Lib.application.window.frameRate + '.' + FlxG.random.int(0, 99) 
        + '\ncpu Architecture: ' + Capabilities.cpuArchitecture 
        + '\nlanguage system: ' + Capabilities.language 
        + '\nsupport 64Bits: ' + Capabilities.supports64BitProcesses 
        + '\nDevice Model: ' + lime.system.System.deviceModel.replace('', 'Not Detected') 
        + '\nPlataform Name: ' + lime.system.System.platformName
        + '\nwindows Resolution: ' + FlxG.width + 'x' + FlxG.height
        + '\nwindows Antialiasing: ' + ClientPrefs.data.antialiasing
        + '\nFullScreen: ' + Lib.application.window.fullscreen
        + '\nMouse: ' + FlxG.mouse.x + 'X |' + FlxG.mouse.y + 'Y'
        +'\nKey code: [' + FlxG.keys.firstPressed() + '] | LEFT: ' + key + ' | UP: ' + CoolUtil.keyLoad(ClientPrefs.keyBinds.get('note_up').copy())
        +'\nTotalMemory: ' + openfl.system.System.totalMemory + 'bytes'
        +'\nResolution Screen: ' + Capabilities.screenResolutionX + 'x' + Capabilities.screenResolutionY
        +'\nScreen DPI:' + Capabilities.screenDPI + 'DPI'
        +'\nOS SYSTEM: ' + Capabilities.os
        +'\nPlayer Type: ' + Capabilities.playerType
        +'\nVersion Player: ' + Capabilities.version
        +'\nVersion Lime: ' + limeVERSION
        +'\nVersion OpenFL: ' + openflVERSION
        +'\nVersion Haxe: ' + haxeVERSION
        +'\nVersion Flixel: ' + flixelVERSION
        +'\nVersion Game: ' + ClientPrefs.data.endingCorruprion
        +'\nVersion Engine: ' + "TGames Services - Ending Engine[" + ClientPrefs.data.endingEngine + "] - (C)2023-" + Date.now().getFullYear() +" EndingGroup"
        +'\nIA VERSION: ' + ClientPrefs.data.gpt
        +'\nIA PROCESS: ' + FlxG.random.int(0, Std.int(ClientPrefs.data.ibl)) + '.' + FlxG.random.int(0, Std.int(CoolUtil.floorDecimal(ClientPrefs.data.ibl, 2)))
        +'\n\n\nPRESIONA BACK PARA REGRESAR\nMENU ACTUALIZADO POR SEGUNDO';

        if (controls.BACK) {
            MusicBeatState.fastSwitchState(new MainMenuState());
        }
    }
}