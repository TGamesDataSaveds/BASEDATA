package backend;

import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSave;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

class CoolUtil
{
	public static var newValue:Int;
    public static var keyName:String;

	inline public static function quantize(f:Float, snap:Float){
		// changed so this actually works lol
		var m:Float = Math.fround(f * snap);
		trace(snap);
		return (m / snap);
	}

	inline public static function capitalize(text:String)
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	inline public static function coolTextFile(path:String):Array<String>
	{
		var daList:String = null;
		#if (sys && MODS_ALLOWED)
		var formatted:Array<String> = path.split(':'); //prevent "shared:", "preload:" and other library names on file path
		path = formatted[formatted.length-1];
		if(FileSystem.exists(path)) daList = File.getContent(path);
		#else
		if(Assets.exists(path)) daList = Assets.getText(path);
		#end
		return daList != null ? listFromString(daList) : [];
	}

	inline public static function colorFromString(color:String):FlxColor
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if(color.startsWith('0x')) color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if(colorNum == null) colorNum = FlxColor.fromString('#$color');
		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	inline public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');

		for (i in 0...daList.length)
			daList[i] = daList[i].trim();

		return daList;
	}

	public static function floorDecimal(value:Float, decimals:Int):Float
	{
		if(decimals < 1)
			return Math.floor(value);

		var tempMult:Float = 1;
		for (i in 0...decimals)
			tempMult *= 10;

		var updateValue:Float = Math.floor(value * tempMult);
		return updateValue / tempMult;
	}

	inline public static function floatToInt(value:Float):Int {
		if (value == 0.00) newValue = 0;
		if (value == 0.01) newValue = 1;
		if (value == 0.02) newValue = 2;
		if (value == 0.03) newValue = 3;
		if (value == 0.04) newValue = 4;
		if (value == 0.05) newValue = 5;
		if (value == 0.06) newValue = 6;
		if (value == 0.07) newValue = 7;
		if (value == 0.08) newValue = 8;
		if (value == 0.09) newValue = 9;

		if (value == 0.10) newValue = 10;
		if (value == 0.11) newValue = 11;
		if (value == 0.12) newValue = 12;
		if (value == 0.13) newValue = 13;
		if (value == 0.14) newValue = 14;
		if (value == 0.15) newValue = 15;
		if (value == 0.16) newValue = 16;
		if (value == 0.17) newValue = 17;
		if (value == 0.18) newValue = 18;
		if (value == 0.19) newValue = 19;

		if (value == 0.20) newValue = 20;
		if (value == 0.21) newValue = 21;
		if (value == 0.22) newValue = 22;
		if (value == 0.23) newValue = 23;
		if (value == 0.24) newValue = 24;
		if (value == 0.25) newValue = 25;
		if (value == 0.26) newValue = 26;
		if (value == 0.27) newValue = 27;
		if (value == 0.28) newValue = 28;
		if (value == 0.29) newValue = 29;

		if (value == 0.30) newValue = 30;
		if (value == 0.31) newValue = 31;
		if (value == 0.32) newValue = 32;
		if (value == 0.33) newValue = 33;
		if (value == 0.34) newValue = 34;
		if (value == 0.35) newValue = 35;
		if (value == 0.36) newValue = 36;
		if (value == 0.37) newValue = 37;
		if (value == 0.38) newValue = 38;
		if (value == 0.39) newValue = 39;

		if (value == 0.40) newValue = 40;
		if (value == 0.41) newValue = 41;
		if (value == 0.42) newValue = 42;
		if (value == 0.43) newValue = 43;
		if (value == 0.44) newValue = 44;
		if (value == 0.45) newValue = 45;
		if (value == 0.46) newValue = 46;
		if (value == 0.47) newValue = 47;
		if (value == 0.48) newValue = 48;
		if (value == 0.49) newValue = 49;

		if (value == 0.50) newValue = 50;
		if (value == 0.51) newValue = 51;
		if (value == 0.52) newValue = 52;
		if (value == 0.53) newValue = 53;
		if (value == 0.54) newValue = 54;
		if (value == 0.55) newValue = 55;
		if (value == 0.56) newValue = 56;
		if (value == 0.57) newValue = 57;
		if (value == 0.58) newValue = 58;
		if (value == 0.59) newValue = 59;

		if (value == 0.60) newValue = 60;
		if (value == 0.61) newValue = 61;
		if (value == 0.62) newValue = 62;
		if (value == 0.63) newValue = 63;
		if (value == 0.64) newValue = 64;
		if (value == 0.65) newValue = 65;
		if (value == 0.66) newValue = 66;
		if (value == 0.67) newValue = 67;
		if (value == 0.68) newValue = 68;
		if (value == 0.69) newValue = 69;

		if (value == 0.70) newValue = 70;
		if (value == 0.71) newValue = 71;
		if (value == 0.72) newValue = 72;
		if (value == 0.73) newValue = 73;
		if (value == 0.74) newValue = 74;
		if (value == 0.75) newValue = 75;
		if (value == 0.76) newValue = 76;
		if (value == 0.77) newValue = 77;
		if (value == 0.78) newValue = 78;
		if (value == 0.79) newValue = 79;

		if (value == 0.80) newValue = 80;
		if (value == 0.81) newValue = 81;
		if (value == 0.82) newValue = 82;
		if (value == 0.83) newValue = 83;
		if (value == 0.84) newValue = 84;
		if (value == 0.85) newValue = 85;
		if (value == 0.86) newValue = 86;
		if (value == 0.87) newValue = 87;
		if (value == 0.88) newValue = 88;
		if (value == 0.89) newValue = 89;

		if (value == 0.90) newValue = 90;
		if (value == 0.91) newValue = 91;
		if (value == 0.92) newValue = 92;
		if (value == 0.93) newValue = 93;
		if (value == 0.94) newValue = 94;
		if (value == 0.95) newValue = 95;
		if (value == 0.96) newValue = 96;
		if (value == 0.97) newValue = 97;
		if (value == 0.98) newValue = 98;
		if (value == 0.99) newValue = 99;

		if (value == 1) newValue = 100;

		return newValue;
	}

	inline public static function keyLoad(key:Array<FlxKey>):String {
		
        if (key == [FlxKey.A]) {
            keyName = "A";
            //ClientPrefs.keyBinds.
        }

        if (key == [FlxKey.B]) {
            keyName = "B";
        }

        if (key == [FlxKey.C]) {
            keyName = "C";
        }

        if (key == [FlxKey.D]) {
            keyName = "D";
        }

        if (key == [FlxKey.E]) {
            keyName = "E";
        }

        if (key == [FlxKey.F]) {
            keyName = "F";
        }

        if (key == [FlxKey.G]) {
            keyName = "G";
        }

        if (key == [FlxKey.H]) {
            keyName = "H";
        }

        if (key == [FlxKey.I]) {
            keyName = "I";
        }

        if (key == [FlxKey.J]) {
            keyName = "J";
        }

        if (key == [FlxKey.K]) {
            keyName = "K";
        }

        if (key == [FlxKey.L]) {
            keyName = "L";
        }

        if (key == [FlxKey.M]) {
            keyName = "M";
        }

        if (key == [FlxKey.N]) {
            keyName = "N";
        }

        if (key == [FlxKey.O]) {
            keyName = "O";
        }

        if (key == [FlxKey.P]) {
            keyName = "P";
        }

        if (key == [FlxKey.Q]) {
            keyName = "Q";
        }

        if (key == [FlxKey.R]) {
            keyName = "R";
        }

        if (key == [FlxKey.S]) {
            keyName = "S";
        }

        if (key == [FlxKey.T]) {
            keyName = "T";
        }

        if (key == [FlxKey.U]) {
            keyName = "U";
        }

        if (key == [FlxKey.V]) {
            keyName = "V";
        }

        if (key == [FlxKey.W]) {
            keyName = "W";
        }

        if (key == [FlxKey.X]) {
            keyName = "X";
        }

        if (key == [FlxKey.Y]) {
            keyName = "Y";
        }

        if (key == [FlxKey.Z]) {
            keyName = "Z";
        }

        if (key == [FlxKey.ZERO]) {
            keyName = "0";
        }

        if (key == [FlxKey.ONE]) {
            keyName = "1";
        }

        if (key == [FlxKey.TWO]) {
            keyName = "2";
        }

        if (key == [FlxKey.THREE]) {
            keyName = "3";
        }

        if (key == [FlxKey.FOUR]) {
            keyName = "4";
        }

        if (key == [FlxKey.FIVE]) {
            keyName = "5";
        }

        if (key == [FlxKey.SIX]) {
            keyName = "6";
        }

        if (key == [FlxKey.SEVEN]) {
            keyName = "7";
        }

        if (key == [FlxKey.EIGHT]) {
            keyName = "8";
        }

        if (key == [FlxKey.NINE]) {
            keyName = "9";
        }

        if (key == [FlxKey.NUMPADZERO]) {
            keyName = "Numpad 0";
        }

        if (key == [FlxKey.NUMPADONE]) {
            keyName = "Numpad 1";
        }

        if (key == [FlxKey.NUMPADTWO]) {
            keyName = "Numpad 2";
        }

        if (key == [FlxKey.NUMPADTHREE]) {
            keyName = "Numpad 3";
        }

        if (key == [FlxKey.NUMPADFOUR]) {
            keyName = "Numpad 4";
        }

        if (key == [FlxKey.NUMPADFIVE]) {
            keyName = "Numpad 5";
        }

        if (key == [FlxKey.NUMPADSIX]) {
            keyName = "Numpad 6";
        }

        if (key == [FlxKey.NUMPADSEVEN]) {
            keyName = "Numpad 7";
        }

        if (key == [FlxKey.NUMPADEIGHT]) {
            keyName = "Numpad 8";
        }

        if (key == [FlxKey.NUMPADNINE]) {
            keyName = "Numpad 9";
        }

        if (key == [FlxKey.F1]) {
            keyName = "F1";
        }

        if (key == [FlxKey.F2]) {
            keyName = "F2";
        }

        if (key == [FlxKey.F3]) {
            keyName = "F3";
        }

        if (key == [FlxKey.F4]) {
            keyName = "F4";
        }

        if (key == [FlxKey.F5]) {
            keyName = "F5";
        }

        if (key == [FlxKey.F6]) {
            keyName = "F6";
        }

        if (key == [FlxKey.F7]) {
            keyName = "F7";
        }

        if (key == [FlxKey.F8]) {
            keyName = "F8";
        }

        if (key == [FlxKey.F9]) {
            keyName = "F9";
        }

        if (key == [FlxKey.F10]) {
            keyName = "F10";
        }

        if (key == [FlxKey.F11]) {
            keyName = "F11";
        }

        if (key == [FlxKey.F12]) {
            keyName = "F12";
        }

        if (key == [FlxKey.ESCAPE]) {
            keyName = "Escape";
        }

        if (key == [FlxKey.TAB]) {
            keyName = "Tab";
        }

        if (key == [FlxKey.SHIFT]) {
            keyName = "Shift";
        }

        if (key == [FlxKey.CAPSLOCK]) {
            keyName = "Caps Lock";
        }

        if (key == [FlxKey.CONTROL]) {
            keyName = "Control";
        }

        if (key == [FlxKey.ALT]) {
            keyName = "Alt";
        }

        if (key == [FlxKey.SPACE]) {
            keyName = "Space";
        }

        if (key == [FlxKey.ENTER]) {
            keyName = "Enter";
        }

        if (key == [FlxKey.BACKSPACE]) {
            keyName = "Backspace";
        }

        if (key == [FlxKey.INSERT]) {
            keyName = "Insert";
        }

        if (key == [FlxKey.DELETE]) {
            keyName = "Delete";
        }

        if (key == [FlxKey.HOME]) {
            keyName = "Home";
        }

        if (key == [FlxKey.END]) {
            keyName = "End";
        }

        if (key == [FlxKey.PAGEUP]) {
            keyName = "Page Up";
        }

        if (key == [FlxKey.PAGEDOWN]) {
            keyName = "Page Down";
        }

        if (key == [FlxKey.LEFT]) {
            keyName = "Left";
        }

        if (key == [FlxKey.RIGHT]) {
            keyName = "Right";
        }

        if (key == [FlxKey.UP]) {
            keyName = "Up";
        }

        if (key == [FlxKey.DOWN]) {
            keyName = "Down";
        }

        if (key == [FlxKey.NUMLOCK]) {
            keyName = "Num Lock";
        }

        if (key == [FlxKey.SCROLL_LOCK]) {
            keyName = "Scroll Lock";
        }

        if (key == [FlxKey.SEMICOLON]) {
            keyName = ";";
        }

        if (key == [FlxKey.COMMA]) {
            keyName = ",";
        }

        if (key == [FlxKey.MINUS]) {
            keyName = "-";
        }

        if (key == [FlxKey.PERIOD]) {
            keyName = ".";
        }

        if (key == [FlxKey.SLASH]) {
            keyName = "/";
        }

        if (key == [FlxKey.LBRACKET]) {
            keyName = "[";
        }

        if (key == [FlxKey.BACKSLASH]) {
            keyName = "\\";
        }

        if (key == [FlxKey.RBRACKET]) {
            keyName = "]";
        }

        if (key == [FlxKey.QUOTE]) {
            keyName = "'";
        }

        return keyName;

    }
	
	inline public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];
		for(col in 0...sprite.frameWidth) {
			for(row in 0...sprite.frameHeight) {
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);
				if(colorOfThisPixel != 0) {
					if(countByColor.exists(colorOfThisPixel))
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					else if(countByColor[colorOfThisPixel] != 13520687 - (2*13520687))
						countByColor[colorOfThisPixel] = 1;
				}
			}
		}

		var maxCount = 0;
		var maxKey:Int = 0; //after the loop this will store the max color
		countByColor[FlxColor.BLACK] = 0;
		for(key in countByColor.keys()) {
			if(countByColor[key] >= maxCount) {
				maxCount = countByColor[key];
				maxKey = key;
			}
		}
		countByColor = [];
		return maxKey;
	}

	inline public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max) dumbArray.push(i);

		return dumbArray;
	}

	inline public static function browserLoad(site:String) {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	/** Quick Function to Fix Save Files for Flixel 5
		if you are making a mod, you are gonna wanna change "ShadowMario" to something else
		so Base Psych saves won't conflict with yours
		@BeastlyGabi
	**/
	inline public static function getSavePath(folder:String = 'ShadowMario'):String {
		@:privateAccess
		return #if (flixel < "5.0.0") folder #else FlxG.stage.application.meta.get('company')
			+ '/'
			+ FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
	}
}
