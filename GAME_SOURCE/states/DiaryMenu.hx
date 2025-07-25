package states;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxSprite;

import openfl.display.BitmapData;
import openfl.filters.BlurFilter;

class DiaryMenu extends FlxState
{

    var camDiary:FlxCamera;
    var camHUD:FlxCamera;

    //Controles de movimiento
    var seguro_para_continuar:Bool = true;

    //HUD
    var numero_de_paginas_maximas_numero:Int = 10;
    public static var numero_de_pagina_actual:Int = 1;
    var numero_de_paginas_texto:TextoDesenfocado;

    //Diary
    var texto_completo_de_pagina:FlxText;

    override function create() {
        super.create();

        camDiary = new FlxCamera();
        camDiary.color.alpha = 0;
        camHUD = new FlxCamera();
        camHUD.color.alpha = 0;
        FlxG.cameras.add(camDiary);
        FlxG.cameras.add(camHUD, false);

        numero_de_paginas_texto = new TextoDesenfocado(0, 0, '', 32, 5);
        numero_de_paginas_texto.antialiasing = ClientPrefs.data.antialiasing;
        numero_de_paginas_texto.camera = camHUD;
        numero_de_paginas_texto.setFormat(Paths.font('Menus/Diario/TextDiary.ttf'), 32, FlxColor.WHITE, FlxTextAlign.LEFT);
        numero_de_paginas_texto.update(0);
        add(numero_de_paginas_texto);

        texto_completo_de_pagina = new FlxText(10, 10, FlxG.width - 20, '');
        texto_completo_de_pagina.antialiasing = ClientPrefs.data.antialiasing;
        texto_completo_de_pagina.camera = camDiary;
        texto_completo_de_pagina.font = Paths.font('TextDiary-Thin.ttf');
        texto_completo_de_pagina.alignment = FlxTextAlign.JUSTIFY;
        texto_completo_de_pagina.size = 14;
        texto_completo_de_pagina.color = FlxColor.WHITE;
        add(texto_completo_de_pagina);

        cargar_interfaz();
    }

    function cargar_interfaz() {
        camDiary.stopFade();
        camDiary.fade(FlxColor.BLACK, 0.7, false, function() {
            numero_de_paginas_texto.setTexto('PAGINA ${numero_de_pagina_actual}/${numero_de_paginas_maximas_numero}');
            texto_completo_de_pagina.text = 'FUERA DE SERVICIO
            
            SOLO TEMPORALEMNTE
            
            SI QUIERES AYUDAR
            
            ENVIANOS UNA OPINION SOBRE TUS EXPERIENCIAS';
            camDiary.fade(FlxColor.BLACK, 0.5, true, true);
        }, true);
    }

    function cambiar_de_pagina(cantidad_de_cambios:Int = 0) {
    if (seguro_para_continuar) {
        if (cantidad_de_cambios != 0) {
        seguro_para_continuar = false;
        numero_de_pagina_actual += cantidad_de_cambios;
        if (numero_de_pagina_actual > numero_de_paginas_maximas_numero) numero_de_pagina_actual = 1;
        if (numero_de_pagina_actual <= 0) numero_de_pagina_actual = numero_de_paginas_maximas_numero;
        seguro_para_continuar = true;
        } else {
            trace('Sin Dato de movimiento');
        }
        cargar_interfaz();
    } else {
        trace('Muy rapido espera que termine lo solicitado anteriormente');
    }
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D) {
            cambiar_de_pagina(1);
        } else if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A) {
            cambiar_de_pagina(-1);
        }

        if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE) {
            FlxG.cameras.fade(FlxColor.BLACK, 0.5, false, function() {
                MusicBeatState.fastSwitchState(new MainMenuState());
            });
        }
    }
}

class Paginas
{
    public static function obtener_id_por_pagina_actual(pagina_actual:Int = 1):Int
    {
        var id_numeros_texto:Dynamic = 0;
        switch (pagina_actual)
        {
            case 1:
                id_numeros_texto = "492837465019";
            case 2:
                id_numeros_texto = "283746501928";
            case 3:
                id_numeros_texto = "574839201746";
            case 4:
                id_numeros_texto = "920174836509";
            case 5:
                id_numeros_texto = "183746509283";
            case 6:
                id_numeros_texto = "657483920174";
            case 7:
                id_numeros_texto = "394857201938";
            case 8:
                id_numeros_texto = "102938475610";
            case 9:
                id_numeros_texto = "485739201847";
            case 10:
                id_numeros_texto = "293847561029";
            default:
                id_numeros_texto = "0";
        }
        trace('ID OBTENIDO: ${id_numeros_texto}');

        if (Std.parseInt(id_numeros_texto) < 0) {
            trace('VALOR NO IDENTIFICADO: ${id_numeros_texto}');
        }

        return id_numeros_texto;
    }

    public static function recargar_informacion_de_paginas()
    {
        for (i in 1...10) {
            try {
        var informacion_general:Array<String> = File.getContent('./assets/diario/paginas/${obtener_id_por_pagina_actual(i)}').split('--{CORTE DE INFORMACION}--');
            } catch(e:Dynamic) {
                trace('NO SE LOGRO ENCONTRAR EL ARCHIVO (./assets/diario/paginas/${obtener_id_por_pagina_actual(i)})');
            }
        }
    }

    public static function obtener_informacion(QUE_TIPO_DE_INFORMACION:String):String
    {
        var informacion_general:Array<String> = try {
            File.getContent('./assets/diario/paginas/${obtener_id_por_pagina_actual(DiaryMenu.numero_de_pagina_actual)}').split('--{CORTE DE INFORMACION}--');
        } catch(e:Dynamic) {
            trace('NO SE LOGRO ENCONTRAR EL ARCHIVO (./assets/diario/paginas/${obtener_id_por_pagina_actual(DiaryMenu.numero_de_pagina_actual)}');
            ["ERROR"];
        };

        var info:String = null;
        switch (QUE_TIPO_DE_INFORMACION)
        {
            case "TITULO":
                if (informacion_general[0] != null) {
                    info = informacion_general[0];
                } else {
                    info = "ERROR";
                }

            case "HISTORIA":
                if (informacion_general[1] != null) {
                    info = informacion_general[1];
                } else {
                    info = "ERROR";
                }

            case "MISION":
                if (informacion_general[2] != null) {
                    info = informacion_general[2];
                } else {
                    info = "ERROR";
                }

            default:
                info = "ERROR";
        }

        return info;
    }
}

class TextoDesenfocado extends FlxSprite {
    var _texto:FlxText;
    var _filtroDesenfoque:BlurFilter;

    public function new(x:Float, y:Float, texto:String, tamano:Int, cantidadDesenfoque:Float) {
        super(x, y);
        _texto = new FlxText(0, 0, 0, texto, tamano);
        _filtroDesenfoque = new BlurFilter(cantidadDesenfoque, cantidadDesenfoque, 3);
        actualizarGrafico();
    }

    public function setFormat(font:String, size:Int = 8, color:FlxColor = FlxColor.WHITE, ?alignment:FlxTextAlign) {
        _texto.setFormat(font, size, color, alignment);
    }

    public function setTexto(nuevoTexto:String):Void {
        _texto.text = nuevoTexto;
        actualizarGrafico();
    }

    function actualizarGrafico():Void {
        _texto.update(0); // Forzar la renderización del texto
        var bitmapOriginal = _texto.pixels;
        var bitmapDesenfocado = bitmapOriginal.clone();
        bitmapDesenfocado.applyFilter(bitmapOriginal, bitmapOriginal.rect, new openfl.geom.Point(0, 0), _filtroDesenfoque);
        this.pixels = bitmapDesenfocado;
    }
}