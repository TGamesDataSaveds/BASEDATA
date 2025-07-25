package;

import flixel.FlxSprite;
import flixel.math.FlxRandom;

class ShaderSprite extends FlxSprite
{
    public var elapsedTime:Float = 0;
    private var random:FlxRandom;
    private var currentShaderName:String = "";

    public function new(X:Float = 0, Y:Float = 0)
    {
        super(X, Y);
        random = new FlxRandom();
    }

    public function setShaderByName(name:String):Void
    {
        currentShaderName = name;
        switch(name)
        {
            case "rgbGlitch":
                this.shader = ShaderManager.getRGBGlitch();
                ShaderManager.setIntensity(cast(this.shader, BaseShader), 2.0);
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
                ShaderManager.updateTime(cast(shader, BaseShader), elapsed);
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