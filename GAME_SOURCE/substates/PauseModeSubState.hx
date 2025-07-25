package substates;

import options.OptionsState;
import flixel.FlxState;
import backend.WeekData;
import backend.Highscore;
import backend.Song;

//

import flixel.util.FlxStringUtil;

import states.StoryMenuState;
import states.FreeplayState;
import flixel.FlxObject;
import options.OptionsState;

import objects.Notification;

class PauseModeSubState extends MusicBeatSubstate
{
    var grpMenuShit:FlxTypedGroup<FlxText>;
    var menuItems:Array<String> = ['Resume', 'Restart Song', 'Change Difficulty', 'Options', 'Exit to menu'];
    var diffChoices = [];
    var curSelected:Int = 0;

    var optionChoices = [];

    var ready:Bool = false;

    var missingText:FlxText;

    var overlay:FlxSprite;

    var missingTextBG:FlxSprite;

    var skipTimeText:FlxText;
    var skipTimeTracker:Alphabet;
    var curTime:Float = Math.max(0, Conductor.songPosition);

    var pauseMusic:FlxSound;

    var item:FlxText;

    public static var songName:String = '';

    public function new(x:Float, y:Float)
    {
        super();
        
        for (i in 0...Difficulty.list.length) {
            var diff:String = Difficulty.getString(i);
            diffChoices.push(diff);
        }

        if (ClientPrefs.data.language == "Inglish") {
        for (i in 0...OptionsState.options.length) {
            var options:String = OptionsState.options[i];
            optionChoices.push(options);
        }
        } else if (ClientPrefs.data.language == "Spanish") {
        for (i in 0...OptionsState.optionsSpanish.length) {
            var options:String = OptionsState.optionsSpanish[i];
            optionChoices.push(options);
        }
        } else {
        for (i in 0...OptionsState.optionsOther.length) { 
            var options:String = OptionsState.optionsOther[i];
            optionChoices.push(options);
        }
        }

            diffChoices.push('BACK');

            pauseMusic = new FlxSound();
            if (songName != null) {
                pauseMusic.loadEmbedded(Paths.music(songName), true, true);
            } else {
                pauseMusic.loadEmbedded(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)), true, true);
            }
            pauseMusic.volume = 0;
            pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

            FlxG.sound.list.add(pauseMusic);

            var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
            bg.alpha = 0;
            bg.scrollFactor.set();
            add(bg);

            var box:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('pausemenu/BoxPause'));
            box.scrollFactor.set();
            box.antialiasing = ClientPrefs.data.antialiasing;
            box.width -= 30;
            box.height -= 30;
            box.alpha = 0;
            box.screenCenter();
            add(box);

            var levelInfo:FlxText = new FlxText(20,15, 0, 'Notas Presionas: ' + PlayState.hitnotesong + ' | ' + PlayState.SONG.song + ' | ' + Difficulty.getString().toUpperCase(), 32);
            levelInfo.scrollFactor.set();
            levelInfo.setFormat(Paths.font("new/BUND.otf"), 32);
            levelInfo.updateHitbox();
            levelInfo.antialiasing = ClientPrefs.data.antialiasing;
            add(levelInfo);

            levelInfo.alpha = 0;

            levelInfo.x = FlxG.width - (levelInfo.width + 20);

            FlxTween.tween(bg, {alpha: 0.6}, 0.3, {ease: FlxEase.linear});
            FlxTween.tween(box, {alpha: 1}, 0.4, {
                ease: FlxEase.linear,
                onComplete: function (twn:FlxTween) {
                    ready = true;
                }
            });

            FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.linear, startDelay: 0.3});

            grpMenuShit = new FlxTypedGroup<FlxText>();
            add(grpMenuShit);

            missingTextBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
            missingTextBG.alpha = 0.6;
            missingTextBG.visible = false;
            add(missingTextBG);

            regenMenu();
            cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
        }

        function openSelectedSubstate(label:String) {
            switch(label) {
                case 'Graphics':
                    openSubState(new options.GraphicsSettingsSubState());
                case 'Visuals UI':
                    openSubState(new options.VisualsUISubState());
                case 'UI Custom':
                    openSubState(new options.optionsMenu.UICustom());
                case 'Optimizations':
                    openSubState(new options.OptimizationsSubState());
                case 'Gameplay':
                    openSubState(new options.GameplaySettingsSubState());
                case 'Debug Config':
                    openSubState(new options.InitialSettings());
                case 'Adjust':
                    MusicBeatState.switchState(new options.NoteOffsetState());
                case 'All Options':
                    openSubState(new options.AllOptions());
                case 'AI SETTINGS':
                    openSubState(new options.optionsMenu.IASettings());
                }
        }
    
        function openSpanish(label:String) {
            switch(label) {
                case 'GRAFICOS':
                    openSubState(new options.GraphicsSettingsSubState());
                case 'EFECTOS VISUALES':
                    openSubState(new options.VisualsUISubState());
                case 'PERSONALIZACION DE UI':
                    openSubState(new options.optionsMenu.UICustom());
                case 'OPTIMIZACIONES':
                    openSubState(new options.OptimizationsSubState());
                case 'GAMEPLAY':
                    openSubState(new options.GameplaySettingsSubState());
                case 'Debug Config':
                    openSubState(new options.InitialSettings());
                case 'AJUSTAR':
                    MusicBeatState.switchState(new options.NoteOffsetState());
                case 'TODAS LAS OPCIONES':
                    openSubState(new options.AllOptions());
                case 'AJUSTES DE IA':
                    openSubState(new options.optionsMenu.IASettings());
                }
        }
    
        function openOther(label:String) {
            switch(label) {
                case 'GRAFICOS':
                    openSubState(new options.GraphicsSettingsSubState());
                case 'EFEITOS VISUAIS':
                    openSubState(new options.VisualsUISubState());
                case 'PERSONALIZAÇÃO DA IU':
                    openSubState(new options.optionsMenu.UICustom());
                case 'OTIMIZAÇÕES':
                    openSubState(new options.OptimizationsSubState());
                case 'JOGO':
                    openSubState(new options.GameplaySettingsSubState());
                case 'Debug Config':
                    openSubState(new options.InitialSettings());
                case 'AJUSTAR':
                    MusicBeatState.switchState(new options.NoteOffsetState());
                case 'TODAS AS OPÇÕES':
                    openSubState(new options.AllOptions());
                case 'CONFIGURAÇÕES DE IA':
                    openSubState(new options.optionsMenu.IASettings());
                }
        }

        var holdTime:Float = 0;
        var cantUnpause:Float = 0.1;
        override function update(elapsed:Float)
            {
                cantUnpause -= elapsed;
                if (pauseMusic.volume < 0.5)
                    pauseMusic.volume +=  0.01 * elapsed;

                if (controls.UI_UP_P)
                    {
                        changeSelection(-1);
                    }
                if (controls.UI_DOWN_P)
                    {
                        changeSelection(1);
                    }
                
                var daSelected:String = menuItems[curSelected];

                if (ready == true) {
                if (controls.ACCEPT && (cantUnpause <= 0 || !controls.controllerMode))
                {

                    if (menuItems == diffChoices)
                        {
                            try{
                                if(menuItems.length - 1 != curSelected && diffChoices.contains(daSelected)) {
            
                                    var name:String = PlayState.SONG.song;
                                    var poop = Highscore.formatSong(name, curSelected);
                                    PlayState.SONG = Song.loadFromJson(poop, name);
                                    PlayState.storyDifficulty = curSelected;
                                    MusicBeatState.resetState();
                                    FlxG.sound.music.volume = 0;
                                    PlayState.changedDifficulty = true;
                                    PlayState.chartingMode = false;
                                    return;
                                }					
                            }catch(e:Dynamic){
                                trace('ERROR! $e');
            
                                var errorStr:String = e.toString();
                                if(errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(27, errorStr.length-1); //Missing chart
                                missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
                                missingText.screenCenter(Y);
                                missingText.visible = true;
                                missingTextBG.visible = true;
                                FlxG.sound.play(Paths.sound('cancelMenu'));
                                return;
                            }
                            regenMenu();
                        } else if (menuItems == optionChoices) {
                            try {
                                if (menuItems.length - 1 != curSelected && optionChoices.contains(daSelected)) {
                                    if (ClientPrefs.data.language == 'Inglish') {
                                        openSelectedSubstate(optionChoices[curSelected]);
                                        } else if (ClientPrefs.data.language == 'Spanish') {
                                            openSpanish(optionChoices[curSelected]);
                                        } else {
                                            openOther(optionChoices[curSelected]);
                                        }
                                        return;
                                }

                            } catch(e:Dynamic) {
                                trace('ERROR! $e');

                                FlxG.sound.play(Paths.sound('cancelMenu'));
                                return;
                            }
                        }

                switch (daSelected)
                {
                    case "Resume":
                        close();
                    case 'Change Difficulty':
                        menuItems = diffChoices;
                        regenMenu();
                    case "Restart Song":
                        restartSong();
                    case 'Options':
                        menuItems = optionChoices;
                        regenMenu();
                    case "Exit to menu":
                        #if desktop DiscordClient.resetClientID(); #end
                        PlayState.deathCounter = 0;
                        PlayState.seenCutscene = false;
                        PlayState.statusGame = false;
    
                        Mods.loadTopMod();
                        if(PlayState.isStoryMode) {
                            MusicBeatState.switchState(new StoryMenuState());
                        } else {
                            MusicBeatState.switchState(new FreeplayState());
                        }
                        PlayState.cancelMusicFadeTween();
                        PlayState.changedDifficulty = false;
                        PlayState.chartingMode = false;
                        FlxG.camera.followLerp = 0;
                }
            }
        }
        }

            public static function restartSong(noTrans:Bool = false)
                {
                    PlayState.instance.paused = true; // For lua
                    FlxG.sound.music.volume = 0;
                    PlayState.instance.vocals.volume = 0;
                    MusicBeatState.resetState();
                }

                        override function destroy()
                            {
                                pauseMusic.destroy();

                                super.destroy();
                            }

                        function changeSelection(change:Int = 0):Void
                            {
                                curSelected += change;

                                FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
                        
                                if (curSelected < 0)
                                    curSelected = menuItems.length - 1;
                                if (curSelected >= menuItems.length)
                                    curSelected = 0;
                        
                                var bullShit:Int = 0;
                        
                                for (item in grpMenuShit.members)
                                {
                                    item.ID = bullShit - curSelected;
                                    bullShit++;
                        
                                    FlxTween.cancelTweensOf(item);
                                    FlxTween.tween(item, {alpha: 0.4}, 0.2, {ease: FlxEase.linear});
                                    FlxTween.tween(item, {"scale.x": 1}, 0.3, {ease: FlxEase.linear});
                        
                                    if (item.ID == 0)
                                    {
                                        FlxTween.cancelTweensOf(item);
                                        FlxTween.tween(item, {alpha: 1}, 0.4, {ease: FlxEase.linear});
                                        FlxTween.tween(item, {"scale.x": 1.1}, 0.5, {ease: FlxEase.linear});
                                        item.screenCenter(X);
                                    }
                        
                                }
                            }

            function regenMenu():Void {
                for (i in 0...grpMenuShit.members.length) {
                    var obj = grpMenuShit.members[0];
                    obj.kill();
                    grpMenuShit.remove(obj, true);
                    obj.destroy();
                }

                var offset:Float = 108 - (Math.max(menuItems.length, 4) - 4) * 80;
                for (i in 0...menuItems.length) {
                    item = new FlxText(220, i * 60 + 200, menuItems[i], true);
                    item.setFormat(Paths.font("new/BUND.otf"), 44);
                    item.antialiasing = ClientPrefs.data.antialiasing;
                    item.ID = i;
                    item.alpha = 0;
                    item.screenCenter(X);
                    grpMenuShit.add(item);
                }
                curSelected = 0;
                changeSelection();
            }
}