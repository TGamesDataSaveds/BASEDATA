package backend;

import openfl.utils.ByteArray;
import openfl.display.BitmapData;
import haxe.io.Bytes;
import haxe.Http;
#if desktop
import ufront.mail.EmailAddress;
import ufront.mail.Email;
#end

class OnlineUtil {

    inline public static function textOnline(textName:String, extend:String = 'json'):String {
        var datatext:String = null;

        var https = new Http('https://raw.githubusercontent.com/ThonnyDevYT/FNFVersion/main/assets/data/' + textName + '.' + extend);

        https.onData = function(data:String) {
            datatext = data;
            trace('DATA LOAD\n' + data);
        }
        https.onError = function(e) {
            datatext = null;
            trace('error: $e');
        }

        https.request();

        return datatext;
    }

    inline public static function pathSoundOnline(soundName:String):String {
        var datasound:String = 'https://raw.githubusercontent.com/ThonnyDevYT//FNFVersion/main/assets/songs/' + soundName + '.ogg';

        //https://github.com/ThonnyDevYT/FNFVersion/blob/main/assets/data/Dusk/Dusk.json

        return datasound;
    }

    inline public static function versionOnline():String {

        var versionOnline:String = null;

        var https = new Http('https://raw.githubusercontent.com/ThonnyDevYT/FNFVersion/main/Ending_Corruption/CHAPTER%201%20-%20DARK%20ROAD/LastVersion.txt');

        https.onData = function(data:String) {
            versionOnline = data;
            trace('RETURN VERSION ONLINE: ' + versionOnline);
        }
        https.onError = function(e) {
            versionOnline = null;
            trace('!!ERROR NOT FOUND VERSION!! ERROR[' + e + ']');
        }

        https.request();

        return versionOnline;
    }

    inline public static function pathOnline():String {

        var pathOnline:String = null;

        var https = new Http('https://raw.githubusercontent.com/ThonnyDevYT/FNFVersion/main/Ending_Corruption/CHAPTER%201%20-%20DARK%20ROAD/pathVersion.txt');

        https.onData = function(data:String) {
            pathOnline = data;
            trace('PATH ONLINE: [' + data + ']');
        }

        https.onError = function(e) {
            trace('EROR LOAD PATH ONLINE');
        }

        https.request();

        return pathOnline;
    }

    inline public static function planUsers(user:String, plan:String):Bool {

        var dataReturn:Bool = false;

        var https = new Http('https://raw.githubusercontent.com/ThonnyDevYT/USERS/main/' + user + '/Plans/' + plan);

        https.onData = function(data:String) {
            if (data == 'true') {
                dataReturn = true;
            } else if (data == 'false') {
                dataReturn = false;
            }

            trace('DATA IN LOAD | DATA: ' + dataReturn);
        }
        
        https.onError = function(e) {
            trace('ERROR LOAD USER PLANS DATA : [' + e + ']');
        }

        https.request();

        return dataReturn;
    }

    inline public static function NetworkStatus():Bool {
        var status:Bool = false;

        var https = new Http('https://www.google.com');

        https.onData = function(data:String) {
            status = true;
            trace('CONNECTED TO INTERNET');
        }

        https.onError = function(e) {
            trace('INTERNET IS DISCONECTED OR ERROR LOAD: (' + https.url + ') - ERROR: [' + e + ']');
        }

        https.request();

        return status;
    }

    inline public static function coinsUser(user:String):Int {
        var coinsReturn:Int = 0;

        var https = new Http('https://raw.githubusercontent.com/ThonnyDevYT/USERS/main/' + user + '/Coins.txt');

        https.onData = function(data:String) {
            coinsReturn = Std.parseInt(data);
            trace('COINS RETURN: ' + coinsReturn);
        }

        https.onError = function(e) {
            trace('ERROR LOAD COINS TEXT IN USER ERROR: [' + e + ']');
        }

        https.request();

        return coinsReturn;
    }

    inline public static function imageProfile(user:String, type:String, extend:String = 'png'):BitmapData {

        var imageReturn:BitmapData = null;

        var https = new Http('https://raw.githubusercontent.com/ThonnyDevYT/USERS/main/' + user + '/IMAGES/' + type + '.' + extend.toLowerCase());

        https.onBytes = function(data:Bytes) {
            imageReturn = bytesforBitMapData(data);
            trace('IMAGE PROFILE IS LOAD');
        }

        https.onError = function(e) {
            trace('ERROR LOAD IMAGE PROFILE ERROR: [' + e + ']');
        }

        https.request();

        return imageReturn;
    }

    inline public static function imageOnline(path:String, extend:String = 'png'):BitmapData {

        var imageReturn:BitmapData = null;

        var https = new Http('https://raw.githubusercontent.com/ThonnyDevYT/FNFVersion/main/Ending_Corruption/CHAPTER%201%20-%20DARK%20ROAD/' + path + '.' + extend.toLowerCase());

        https.onBytes = function(data:Bytes) {
            imageReturn = bytesforBitMapData(data);
            trace('IMAGE IS LOAD');
        }

        https.onError = function(e) {
            trace('ERROR LOAD IMAGE ERROR: [' + e + ']');
        }

        https.request();

        return imageReturn;
    }

    private static function bytesforBitMapData(bytes:Bytes):BitmapData {
        // Convertir los bytes a un ByteArray
        var byteArray:ByteArray = ByteArray.fromBytes(bytes);

        // Crear un BitmapData a partir del ByteArray
        var bitmapData:BitmapData = BitmapData.fromBytes(byteArray);

        return bitmapData;
   }
}