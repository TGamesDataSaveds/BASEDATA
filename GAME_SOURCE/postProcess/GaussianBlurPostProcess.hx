package postProcess;

import openfl.filters.BlurFilter;
import flixel.effects.postprocess.PostProcess;
import openfl.geom.Point;

class GaussianBlurPostProcess extends PostProcess
{
    // Parámetros del efecto de desenfoque gaussiano
    var directionX:Float;
    var directionY:Float;
    var strength:Float;

    public function new(strength:Float = 1.0, directionX:Float = 1.0, directionY:Float = 1.0)
    {

        this.strength = strength;
        this.directionX = directionX;
        this.directionY = directionY;

        super(null);
    }

    public function apply()
    {
        // Aplicar el desenfoque gaussiano aquí
        // Puedes implementar el desenfoque utilizando un shader, una biblioteca de gráficos o cualquier otra técnica que prefieras

        // Aquí se proporciona un ejemplo de cómo aplicar un desenfoque de caja simple
        FlxG.camera.buffer.applyFilter(FlxG.camera.buffer, FlxG.camera.buffer.rect, new Point(), new BlurFilter(strength * directionX, strength * directionY, 3));
    }
}