package states;

import flixel.FlxSubState;

import options.OptionsState;

class PreloadingState extends MusicBeatState
{
    public static var WarnText2:FlxText;
    public var bg:FlxSprite;
    public static var WarnTextBack:FlxText;
    public var client:Bool = ClientPrefs.data.downloadMode;
    var Press:Bool = false;


    override function create() {
        super.create();

        ClientPrefs.loadPrefs();

        if (ClientPrefs.data.Welcome == true) {
            ClientPrefs.data.start = false;
            ClientPrefs.saveSettings();
            ClientPrefs.loadPrefs();
            MusicBeatState.switchState(new TitleState());
        }

        bg = new FlxSprite().loadGraphic(Paths.image('BGMenu/TitleMenu'));
        bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.alpha = 0;
        add(bg);
        FlxTween.tween(bg, {alpha: 1}, 6);

        WarnText2 = new FlxText(0, 0, FlxG.width,
            "Welcome to Ending Corruption\n\nBefore we start we need you to configure some things.\n\nPress 'Y' to set or 'N' to Skip",32);
        WarnText2.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
        WarnText2.screenCenter();
        WarnText2.alpha = 0;
        add(WarnText2);
        FlxTween.tween(WarnText2, {alpha: 1}, 4);

        WarnTextBack = new FlxText(0, 0, FlxG.width,"Press [N] to Start Game!\n\nPreferences are loaded at startup",32);
        WarnTextBack.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
        WarnTextBack.screenCenter();
        WarnTextBack.alpha = 0;

        #if desktop
        DiscordClient.changePresence("PRELOADER MENU", null);
        #end

 
    }

    public function dowloadState() {
        if (client == true) {
            #if desktop
			DiscordClient.changePresence("TITLE MENU", null);
			#end
            MusicBeatState.updatestate("TitleMenu");
            if (ClientPrefs.data.music == 'Disabled') {
                FlxG.sound.playMusic(Paths.music('none'), 0);
            } else {
                FlxG.sound.playMusic(Paths.music(ClientPrefs.data.music));
            }

            if(Main.fpsVar != null && !ClientPrefs.data.noneAnimations) {
                FlxTween.tween(Main.fpsVar, {x: 10}, 0.2);
                FlxTween.tween(Main.fpsVar, {alpha: 1}, 0.2);
            }
            Main.fpsVar.visible = ClientPrefs.data.showFPS;

            FlxG.sound.music.fadeIn(0.2, 0, 1, function (twn:FlxTween) {
                #if desktop
                DiscordClient.changePresence("TITLE MENU", null);
                #end
                    MusicBeatState.switchState(new TitleState());
                }
            );
        }
        if (client == false) {
            #if desktop
			DiscordClient.changePresence("PATH DOWNLOADING", null);
			#end
            MusicBeatState.switchState(new states.editors.UpdatingState());
            client = true;
        }
    }

    override function update(elapsed:Float)
    {
            if (FlxG.keys.justPressed.Y) {
                ClientPrefs.data.Welcome = true;
                  ClientPrefs.saveSettings();
                  ClientPrefs.loadPrefs();
                  Press = true;
                  FlxG.sound.play(Paths.sound('confirmMenu'));
                        FlxTween.tween(WarnText2, {alpha: 0}, 4, {
                            onComplete: function (twn:FlxTween) {
                                openSubState(new options.InitialSettings());
                                add(WarnTextBack);
                                FlxTween.tween(WarnTextBack, {alpha: 1}, 6);
                            }
                        });

        }
        
            if (FlxG.keys.justPressed.N) {
            ClientPrefs.data.Welcome = true;
            ClientPrefs.saveSettings();
            ClientPrefs.loadPrefs();
            FlxG.sound.play(Paths.sound('cancelMenu'));
            FlxTween.tween(WarnTextBack, {alpha: 0}, 5);

            if (WarnText2.alpha == 1) {
            FlxTween.tween(WarnText2, {alpha: 0}, 5, {
                onComplete: function (twn:FlxTween) {
                    dowloadState();
                }
            });
        }

            FlxTween.tween(bg, {alpha: 0}, 5, {
                onComplete: function (twn:FlxTween) {
                    ClientPrefs.loadPrefs();
                    dowloadState();
                }
            });
        }
        super.update(elapsed);
    }
}