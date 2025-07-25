package;

import flixel.text.FlxText;
import flixel.math.FlxRandom;

class ShaderText extends FlxText
{
    public var elapsedTime:Float = 0;
    private var random:FlxRandom;
    private var currentShaderName:String = "";

    public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?Text:String, Size:Int = 8, EmbeddedFont:Bool = true)
    {
        super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
        random = new FlxRandom();
    }

    public function setShaderByName(name:String):Void
    {
        currentShaderName = name;
        switch(name)
        {
            case "rgbGlitch":
                this.shader = ShaderManager.getRGBGlitch();
                ShaderManager.setIntensity(cast(this.shader, BaseShader), 1.0);
            case "vignette":
                this.shader = ShaderManager.getVignette();
                ShaderManager.setIntensity(cast(this.shader, BaseShader), 0.75);
                ShaderManager.setRadius(cast(this.shader, BaseShader), 0.75);
            case "concussion":
                this.shader = ShaderManager.getConcussion();
                ShaderManager.setIntensity(cast(this.shader, BaseShader), 1.0);
            case "chromaticGlitch":
                this.shader = ShaderManager.getChromaticGlitch();
                ShaderManager.setIntensity(cast(this.shader, BaseShader), 1.0);
        }
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        if (shader != null)
        {
            elapsedTime += elapsed;
            
            switch(currentShaderName)
            {
                case "rgbGlitch":
                    ShaderManager.updateTime(cast(shader, BaseShader), elapsedTime);
                    if (random.bool(5))
                    {
                        ShaderManager.setIntensity(cast(shader, BaseShader), random.float(0.5, 2.0));
                    }
                case "concussion":
                    ShaderManager.updateTime(cast(shader, BaseShader), elapsedTime);
                case "chromaticGlitch":
                    ShaderManager.updateTime(cast(shader, BaseShader), elapsedTime);
                    if (random.bool(3))
                    {
                        ShaderManager.setIntensity(cast(shader, BaseShader), random.float(0.8, 1.5));
                    }
                case "vignette":
                    // La viñeta es estática, no necesita actualización
            }
        }
    }

    override public function destroy():Void
    {
        if (shader != null)
        {
            ShaderManager.destroyShader(cast(shader, BaseShader));
            shader = null;
        }
        super.destroy();
    }
}