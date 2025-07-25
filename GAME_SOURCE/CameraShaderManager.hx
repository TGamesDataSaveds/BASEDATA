package;

import flixel.FlxG;
import openfl.filters.ShaderFilter;

class CameraShaderManager
{
    public static var currentShader:BaseShader;
    private static var filter:ShaderFilter;

    public static function setShader(shaderName:String):Void
    {
        // Limpiar shader anterior si existe
        clearShader();
        
        // Crear nuevo shader basado en el nombre
        currentShader = switch(shaderName.toLowerCase())
        {
            case "rgbglitch": new RGBGlitchShader();
            case "vignette": new VignetteShader();
            case "concussion": new ConcussionShader();
            case "chromaticglitch": new ChromaticGlitchShader();
            default: null;
        }

        if (currentShader != null)
        {
            filter = new ShaderFilter(currentShader);
            FlxG.camera.setFilters([filter]);
        }
    }

    public static function clearShader():Void
    {
        if (currentShader != null)
        {
            currentShader = null;
        }
        if (FlxG.camera != null)
        {
            FlxG.camera.setFilters([]);
        }
    }

    public static function update(elapsed:Float):Void
    {
        if (currentShader != null)
        {
            currentShader.update(elapsed);
        }
    }

    public static function setIntensity(value:Float):Void
    {
        if (currentShader != null && currentShader.intensity != null)
        {
            currentShader.intensity.value = [value];
        }
    }
}