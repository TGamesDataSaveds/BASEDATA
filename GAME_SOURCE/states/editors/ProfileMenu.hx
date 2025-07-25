/*package states.editors;

import backend.OnlineUtil;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import objects.Notification;
import tjson.TJSON as Json;
import haxe.Http;
import lime.net.HTTPRequest;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUICheckBox;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIInputText;

#if desktop
import layout.Layout;
#end

import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets;

#if desktop
import hxcpp.Builder;
#end

class ProfileMenu extends MusicBeatState {

    var status:FlxText;

    var TITLE:FlxText;

    var usernameSIZE:FlxSprite;
    var passwordSIZE:FlxSprite;

    var username:FlxUIInputText;
    var password:FlxUIInputText;

    var conditional:FlxUICheckBox;

    var login:FlxUIButton;
    var skip:FlxUIButton;

    var support:FlxUIButton;

    public var jsonOnline:String;
    public var acconts:Array<Dynamic>;

    var usernameHEIGHT:Float;

    function profilesOnline() {
        var https:Http = new Http('https://raw.githubusercontent.com/ThonnyDevYT/FNFVersion/main/Acconts.json');

        https.onData = function(data:String) {
            jsonOnline = data;
            trace('EXITO ALMACENADO');
        }
        https.onError = function(error) {
            trace('ERROR: $error');            
        }

        https.request();
    }

    override function create() {

        profilesOnline();

        if (jsonOnline != null) {
            acconts = Json.parse(jsonOnline);
        } else {
            trace('ERROR JSON ONLINE IS NULL');
        }

        TITLE = new FlxText(0, 200, FlxG.width, "LOGIN", 22);
        TITLE.antialiasing = ClientPrefs.data.antialiasing;
        TITLE.alignment = CENTER;
        TITLE.borderColor = FlxColor.BLACK;
        TITLE.color = FlxColor.WHITE;
        TITLE.font = Paths.font("new/BUND.otf");
        add(TITLE);
        if (ClientPrefs.data.language == 'Spanish') {
            TITLE.text = "INICIAR SESION";
        } else if (ClientPrefs.data.language == 'Portuguese') {
            TITLE.text = "Iniciar sessão".toUpperCase();
        }

        username = new FlxUIInputText(0, 250, Std.int(FlxG.width / 2), "USERNAME", 15, FlxColor.GRAY);
        username.screenCenter(X);
        username.alignment = LEFT;
        username.font = Paths.font("new/BUND.otf");
        username.bold = true;
        username.backgroundColor = FlxColor.BLACK;

        if (ClientPrefs.data.language == 'Spanish') {
            username.text = 'USUARIO';
        } else if (ClientPrefs.data.language == 'Portuguese') {
            username.text = 'DO UTILIZADOR';
        }
        usernameHEIGHT = username.height;
        usernameSIZE = new FlxSprite(0, 245).makeGraphic(Std.int(FlxG.width / 2) + 10, Std.int(username.height) + 10, FlxColor.WHITE);
        usernameSIZE.screenCenter(X);
        add(usernameSIZE);
        add(username);

        password = new FlxUIInputText(0, 300, Std.int(FlxG.width / 2), "PASSWORD", 15, FlxColor.WHITE);
        password.screenCenter(X);
        password.alignment = LEFT;
        password.font = Paths.font("new/BUND.otf");
        password.bold = true;
        password.backgroundColor = FlxColor.BLACK;
        password.antialiasing = ClientPrefs.data.antialiasing;
        password.focusGained = function() WindowProperty.VolumeControlls(false);
        password.focusLost = function() WindowProperty.VolumeControlls(true);
        //password.background = false;
        if (ClientPrefs.data.language == 'Spanish') {
            password.text = 'CONTRASEÑA';
        } else if (ClientPrefs.data.language == 'Portuguese') {
            password.text = 'SENHA';
        }

        passwordSIZE = new FlxSprite(0, 295).makeGraphic(Std.int(FlxG.width / 2) + 10, Std.int(password.height) + 10, FlxColor.WHITE);
        passwordSIZE.screenCenter(X);
        add(passwordSIZE);
        add(password);

        conditional = new FlxUICheckBox(220, 330, null, null, 'Always Login', 100, {
            function() {
                ClientPrefs.data.alwaysLOGIN = conditional.checked;
                ClientPrefs.saveSettings();
                ClientPrefs.loadPrefs();
            }
        });
        conditional.setSize(100, 100);
        conditional.checked = ClientPrefs.data.alwaysLOGIN;
        conditional.screenCenter(X);
        conditional.button.label.font = Paths.font("new/BUND.otf");
        conditional.button.label.bold = true;
        conditional.antialiasing = ClientPrefs.data.antialiasing;
        add(conditional);
        if (ClientPrefs.data.language == 'Spanish') {
            conditional.text = 'MANTENER SESION SIEMPRE';
        } else if (ClientPrefs.data.language == 'Portuguese') {
            conditional.text = 'Sempre faça login'.toUpperCase();
        }

        login = new FlxUIButton(0, 360, "LOGIN", onLOGIN);
        login.label.font = Paths.font("new/BUND.otf");
        login.label.bold = true;
        login.screenCenter(X);
        login.setSize(35, 35);
        login.updateHitbox();
        login.antialiasing = ClientPrefs.data.antialiasing;
        add(login);
        if (ClientPrefs.data.language == 'Spanish') {
            login.label.text = 'INICIAR SESION';
        } else if (ClientPrefs.data.language == 'Portuguese') {
            login.label.text = 'Iniciar sessão'.toUpperCase();
        }

        skip = new FlxUIButton(0, 390, "SKIP", onSkip);
        skip.screenCenter(X);
        skip.setSize(35, 35);
        skip.updateHitbox();
        skip.label.font = Paths.font("new/BUND.otf");
        skip.label.bold = true;
        skip.antialiasing = ClientPrefs.data.antialiasing;
        add(skip);
        if (ClientPrefs.data.language == 'Spanish') {
            skip.label.text = 'OMITIR';
        } else if (ClientPrefs.data.language == 'Portuguese') {
            skip.label.text = 'PULAR';
        }

        support = new FlxUIButton(FlxG.width - 20, 10, "SUPPORT", function() openSubState(new options.optionsMenu.SupportMenu()));
        support.label.font = Paths.font("new/BUND.otf");
        support.label.bold = true;
        support.antialiasing = ClientPrefs.data.antialiasing;
        add(support);

        status = new FlxText(0, 420, Std.int(FlxG.width / 2), "", 15);
        status.antialiasing = ClientPrefs.data.antialiasing;
        status.font = Paths.font("new/BUND.otf");
        status.alignment = CENTER;
        status.borderColor = FlxColor.BLACK;
        status.color = FlxColor.WHITE;
        status.alpha = 0;
        status.screenCenter(X);
        status.font = Paths.font("new/BUND.otf");
        add(status);

        new FlxTimer().start(1, function(Timer:FlxTimer) {
            if (localUsers() == false) {
                add(new Notification('Error JSON', 'NO SE ENCONTRATRON USUARIOS LOCALES ALMACENADOS, INICIE SESION PARA ACCEDER A SU CUENTA'));
            } else {
                ClientPrefs.data.Data = "USER LOADING";
                trace('SE ENCONTRARON USUARIOS LOCALES, SE CARGARAN AL INICIAR');
            }
        }, 1);

        if (ClientPrefs.data.language == 'Inglish') {
            MusicBeatState.updatestate('LOGIN MENU');
        } else if (ClientPrefs.data.language == 'Spanish') {
            MusicBeatState.updatestate('MENU DE INICIO DE SESION');
        } else if (ClientPrefs.data.language == 'Portuguese') {
            MusicBeatState.updatestate('MENU DE LOGIN');
        }

        ClientPrefs.data.Data = "WAITING FOR DATA";

        super.create();
    }

    function localUsers():Bool {

        var status:Bool = false;
        var rawJson:String = null;
        var textArray:Array<String>;

        if(OpenFlAssets.exists('./assets/data/Settings/users/' + username.text + '.txt')) {
			rawJson = Assets.getText(Paths.txt("Settings/users/" + username.text));
            textArray = rawJson.split('\n');

            username.text = username.text;
            password.text = textArray[1];

            trace('rawJson: ' + rawJson);
            status = true;
		} else {
            status = false;
            trace('NOT EXISTED: ./assets/data/Settings/users/' + username.text + '.txt');
        }

        return status;
    }

    function onLOGIN() {

        if (OnlineUtil.NetworkStatus() == true) {
        var https = new Http('https://raw.githubusercontent.com/ThonnyDevYT/USERS/main/' + username.text);
        var results:Array<String>;

        https.onData = function(data:String) {
            results = data.split('\n');

            if (password.text == results[1]) {
                ClientPrefs.data.userName = username.text;
                ClientPrefs.data.password = results[1];
                ClientPrefs.data.KeyScan = results[2];
                statusMode("Inicio de Sesion Exitoso\nBienvenido/a " + username.text, FlxColor.LIME);
                ClientPrefs.data.Data = "LOGIN USER [" + username.text + "]";
                new FlxTimer().start(2.2, function(Timer:FlxTimer) MusicBeatState.switchState(new TitleState()), 1);
                #if dektop
                File.saveContent('./assets/data/Settings/users/' + username.text + '.txt', results[0] + '\n' + results[1] + '\n' + results[2]);
                #end
            } else {
                ClientPrefs.data.userName = null;
                ClientPrefs.data.password = null;
                ClientPrefs.data.KeyScan = null;
                statusMode("ERROR DE SESION\nCONTRASEÑA INCORRECTA", FlxColor.RED);
                ClientPrefs.data.Data = "RESULT TO PASSWORD IS INCORRECT";
            }
        }
        https.onError = function(data:String) {
            trace('ERROR URL: ' + https.url);
            ClientPrefs.data.Data = "RESULT TO USERNAME NOT FOUND";
            statusMode("ERROR DE SESION\nUSUARIO NO ENCONTRADO", FlxColor.RED);

        }

        https.request();
    } else {
        trace('USUARIO NO ENCONTRADOR\nNO ESTAS CONECTADO A INTERNET');
        statusMode("!NO FUE POSIBLE CONECTARSE AL SERVIDOR!\nREVISE SU CONEXION A INTERNET", FlxColor.RED);
        ClientPrefs.data.Data = "INTERNET NOT CONECTED";
    }
        
    }

    function onSkip() {
        MusicBeatState.updatestate("TitleMenu");
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
                }
            );
    }

    function statusMode(text:String = '', ?colorText:FlxColor = FlxColor.WHITE) {
        FlxTween.cancelTweensOf(status);
        FlxTween.tween(status, {alpha: 0}, 0.01, {ease: FlxEase.linear});
        status.text = text;
        status.color = colorText;
        FlxTween.tween(status, {alpha: 1}, 0.7, {ease: FlxEase.linear});
}

    override function update(elapsed:Float) {

        if (ClientPrefs.data.language == 'Inglish') {
        if (password.text == 'PASSWOR') {
            password.passwordMode = false;
        } else if (password.text == 'PASSWORD') {
            password.passwordMode = false;
        } else {
            password.passwordMode = true;
        }
    } else if (ClientPrefs.data.language == 'Spanish') {
        if (password.text == 'CONTRASEÑ') {
            password.passwordMode = false;
        } else if (password.text == 'CONTRASEÑA') {
            password.passwordMode = false;
        } else {
            password.passwordMode = true;
        }
    } else if (ClientPrefs.data.language == 'Portuguese') {
        if (password.text == "Iniciar sessã".toUpperCase()) {
            password.passwordMode = false;
        } else if (password.text == "Iniciar sessão".toUpperCase()) {
            password.passwordMode = false;
        } else {
            password.passwordMode = true;
        }
    }

        if (ClientPrefs.data.language == 'Spanish') {
            if (username.text != 'USUARIO') {
                localUsers();
            }
        } else if (ClientPrefs.data.language == 'Portuguese') {
            if (username.text != 'DO UTILIZADOR') {
                localUsers();
            }
        } else if (ClientPrefs.data.language == 'Inglish') {
            if (username.text != 'USERNAME') {
                localUsers();
            }
        }

    support.x = FlxG.width - support.width - 5;

        super.update(elapsed);
    }
}*/

//////////////////////////////////////////////////

//Nuevo Codigo
package states.editors;

import backend.OnlineUtil;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import objects.Notification;
import tjson.TJSON as Json;
import haxe.Http;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.utils.Assets as OpenFlAssets;

class ProfileMenu extends MusicBeatState {
    private var status:FlxText;
    private var title:FlxText;
    private var username:FlxUIInputText;
    private var password:FlxUIInputText;
    private var conditional:FlxUICheckBox;
    private var login:FlxUIButton;
    private var skip:FlxUIButton;
    private var support:FlxUIButton;

    private var jsonOnline:String;
    private var accounts:Array<Dynamic>;

    override function create() {
        super.create();

        fetchOnlineProfiles();
        createUIProfile();
        checkLocalUsers();
        updateStateText();

        WindowProperty.VolumeControlls(false);

        ClientPrefs.data.Data = "WAITING FOR DATA";
    }

    private function fetchOnlineProfiles() {
        var https = new Http('https://raw.githubusercontent.com/ThonnyDevYT/FNFVersion/main/Acconts.json');
        https.onData = function(data:String) {
            jsonOnline = data;
            accounts = Json.parse(jsonOnline);
        }
        https.onError = function(error) {
            trace('ERROR: $error');
        }
        https.request();
    }

    private function createUIProfile() {
        title = createText(0, 200, FlxG.width, getLocalizedText("LOGIN", "INICIAR SESION", "Iniciar sessão".toUpperCase()), 22);
        add(title);

        username = createInputField(0, 250, "USERNAME", "USUARIO", "DO UTILIZADOR");
        password = createInputField(0, 300, "PASSWORD", "CONTRASEÑA", "SENHA");
        password.passwordMode = true;

        conditional = createCheckBox(220, 330, 'Always Login', function() {
            ClientPrefs.data.alwaysLOGIN = conditional.checked;
            ClientPrefs.saveSettings();
            ClientPrefs.loadPrefs();
        });

        login = createButton(0, 360, "LOGIN", onLOGIN);
        skip = createButton(0, 390, "SKIP", onSkip);
        support = createButton(FlxG.width - 20, 10, "SUPPORT", function() openSubState(new options.optionsMenu.SupportMenu()));

        status = createText(0, 420, Std.int(FlxG.width / 2), "", 15);
        status.alpha = 0;
    }

    private function createText(X:Float, Y:Float, Width:Float, Text:String, Size:Int):FlxText {
        var text = new FlxText(X, Y, Width, Text, Size);
        text.setFormat(Paths.font("new/BUND.otf"), Size, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        text.antialiasing = ClientPrefs.data.antialiasing;
        add(text);
        return text;
    }

    private function createInputField(X:Float, Y:Float, EnglishText:String, SpanishText:String, PortugueseText:String):FlxUIInputText {
        var input = new FlxUIInputText(X, Y, Std.int(FlxG.width / 2), getLocalizedText(EnglishText, SpanishText, PortugueseText), 15, FlxColor.WHITE, FlxColor.BLACK);
        input.setFormat(Paths.font("new/BUND.otf"), 15, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        input.screenCenter(flixel.util.FlxAxes.X);
        input.antialiasing = ClientPrefs.data.antialiasing;
        add(input);
        return input;
    }

    private function createCheckBox(X:Float, Y:Float, Text:String, Callback:Void->Void):FlxUICheckBox {
        var check = new FlxUICheckBox(X, Y, null, null, Text, 100, Callback);
        check.checked = ClientPrefs.data.alwaysLOGIN;
        check.screenCenter(flixel.util.FlxAxes.X);
        check.antialiasing = ClientPrefs.data.antialiasing;
        add(check);
        return check;
    }

    private function createButton(X:Float, Y:Float, Text:String, Callback:Void->Void):FlxUIButton {
        var button = new FlxUIButton(X, Y, Text, Callback);
        button.label.setFormat(Paths.font("new/BUND.otf"), 15, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        button.screenCenter(flixel.util.FlxAxes.X);
        button.setSize(35, 35);
        button.updateHitbox();
        button.antialiasing = ClientPrefs.data.antialiasing;
        add(button);
        return button;
    }

    private function checkLocalUsers() {
        new FlxTimer().start(1, function(Timer:FlxTimer) {
            if (!localUsers()) {
                add(new Notification('Error JSON', 'NO SE ENCONTRARON USUARIOS LOCALES ALMACENADOS, INICIE SESION PARA ACCEDER A SU CUENTA'));
            } else {
                ClientPrefs.data.Data = "USER LOADING";
                trace('SE ENCONTRARON USUARIOS LOCALES, SE CARGARAN AL INICIAR');
            }
        });
    }

    private function localUsers():Bool {
        if(OpenFlAssets.exists('./assets/data/Settings/users/${username.text}.txt')) {
            var rawJson = Paths.txt("Settings/users/" + username.text);
            var textArray = rawJson.split('\n');
            password.text = textArray[1];
            return true;
        }
        return false;
    }

    private function onLOGIN() {
        if (OnlineUtil.NetworkStatus()) {
            var https = new Http('https://raw.githubusercontent.com/ThonnyDevYT/USERS/main/${username.text}/Data.txt');
            https.onData = function(data:String) {
                var results = data.split('\n');
                if (password.text == results[1]) {
                    loginSuccess(results);
                } else {
                    loginFailure("ERROR DE SESION\nCONTRASEÑA INCORRECTA");
                }
            }
            https.onError = function(error) {
                loginFailure("ERROR DE SESION\nUSUARIO NO ENCONTRADO");
            }
            https.request();
        } else {
            loginFailure("!NO FUE POSIBLE CONECTARSE AL SERVIDOR!\nREVISE SU CONEXION A INTERNET");
        }
    }

    private function loginSuccess(results:Array<String>) {
        ClientPrefs.data.userName = username.text;
        ClientPrefs.data.password = results[1];
        ClientPrefs.data.KeyScan = results[2];
        statusMode("Inicio de Sesion Exitoso\nBienvenido/a " + username.text, FlxColor.LIME);
        ClientPrefs.data.Data = "LOGIN USER [" + username.text + "]";
        new FlxTimer().start(2.2, function(Timer:FlxTimer) MusicBeatState.switchState(new TitleState()));
        #if desktop
        File.saveContent('./assets/data/Settings/users/${username.text}.txt', results.join('\n'));
        #end
    }

    private function loginFailure(message:String) {
        ClientPrefs.data.userName = null;
        ClientPrefs.data.password = null;
        ClientPrefs.data.KeyScan = null;
        statusMode(message, FlxColor.RED);
        ClientPrefs.data.Data = "LOGIN FAILURE";
    }

    private function onSkip() {
        MusicBeatState.updatestate("TitleMenu");
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

    private function statusMode(text:String, color:FlxColor = FlxColor.WHITE) {
        FlxTween.cancelTweensOf(status);
        FlxTween.tween(status, {alpha: 0}, 0.01, {ease: FlxEase.linear});
        status.text = text;
        status.color = color;
        FlxTween.tween(status, {alpha: 1}, 0.7, {ease: FlxEase.linear});
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        updatePasswordMode();
        checkLocalUserChange();
        support.x = FlxG.width - support.width - 5;
    }

    private function updatePasswordMode() {
        var defaultText = getLocalizedText("PASSWORD", "CONTRASEÑA", "SENHA");
        password.passwordMode = (password.text != defaultText && password.text != defaultText.substr(0, defaultText.length - 1));
    }

    private function checkLocalUserChange() {
        var defaultText = getLocalizedText("USERNAME", "USUARIO", "DO UTILIZADOR");
        if (username.text != defaultText) {
            localUsers();
        }
    }

    private function getLocalizedText(english:String, spanish:String, portuguese:String):String {
        return switch(ClientPrefs.data.language) {
            case 'Spanish': spanish;
            case 'Portuguese': portuguese;
            default: english;
        }
    }

    private function updateStateText() {
        MusicBeatState.updatestate(getLocalizedText('LOGIN MENU', 'MENU DE INICIO DE SESION', 'MENU DE LOGIN'));
    }
}