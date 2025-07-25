package openfl8;

import flixel.system.FlxAssets.FlxShader;

class Scanline extends FlxShader
{
	@:glFragmentSource(' 
    #pragma header
    uniform float time; 
    uniform sampler2D bitmap;

    const float scale = 2.0;
    const vec2 offset = vec2(1.0 / 512.0, 1.0 / 512.0);

    void main()
    {
        float newY = mod(openfl_TextureCoordv.y + time * 0.05, 1.0);

        vec4 center = texture2D(bitmap, vec2(openfl_TextureCoordv.x, newY));
        vec4 left = texture2D(bitmap, vec2(openfl_TextureCoordv.x - offset.x, newY));
        vec4 right = texture2D(bitmap, vec2(openfl_TextureCoordv.x + offset.x, newY));
        vec4 top = texture2D(bitmap, vec2(openfl_TextureCoordv.x, newY - offset.y));
        vec4 bottom = texture2D(bitmap, vec2(openfl_TextureCoordv.x, newY + offset.y));

        vec4 averageColor = (center + left + right + top + bottom) / 5.0;

        if (mod(floor(newY * openfl_TextureSize.y / scale), 2.0) == 0.0)
            gl_FragColor = averageColor;
        else
            gl_FragColor = center;
    }')
	
	public function new()
	{
		super();
	}
}