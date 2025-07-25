package;

import flixel.system.FlxAssets.FlxShader;
import openfl.display.ShaderParameter;
import flixel.FlxG;

class BaseShader extends FlxShader 
{
    public var time:ShaderParameter<Float>;
    public var intensity:ShaderParameter<Float>;
    public var radius:ShaderParameter<Float>;

    public function new()
    {
        super();
        time = new ShaderParameter<Float>();
        intensity = new ShaderParameter<Float>();
        radius = new ShaderParameter<Float>();
    }

    public function update(elapsed:Float):Void 
    {
        if (time != null && time.value != null) 
        {
            time.value[0] += elapsed;
        }
    }
}

class RGBGlitchShader extends BaseShader
{
    @:glFragmentSource('
        #pragma header

        uniform float time;
        uniform float intensity;
        
        void main()
        {
            vec2 uv = openfl_TextureCoordv;
            float glitchAmount = intensity * (0.5 + 0.5 * sin(time));
            float shift = glitchAmount * 0.01;
            
            vec4 color1 = flixel_texture2D(bitmap, vec2(uv.x + shift, uv.y));
            vec4 color2 = flixel_texture2D(bitmap, vec2(uv.x, uv.y));
            vec4 color3 = flixel_texture2D(bitmap, vec2(uv.x - shift, uv.y));
            
            gl_FragColor = vec4(color1.r, color2.g, color3.b, color2.a);
        }
    ')
    
    public function new()
    {
        super();
        time.value = [0.0];
        intensity.value = [1.0];
    }
}

class VignetteShader extends BaseShader
{
    @:glFragmentSource('
        #pragma header

        uniform float intensity;
        uniform float radius;
        
        void main()
        {
            vec2 uv = openfl_TextureCoordv;
            vec2 center = vec2(0.5, 0.5);
            float dist = distance(uv, center);
            float vignette = smoothstep(radius, radius - 0.2, dist);
            
            vec4 color = flixel_texture2D(bitmap, uv);
            color.rgb *= mix(1.0 - intensity, 1.0, vignette);
            
            gl_FragColor = color;
        }
    ')
    
    public function new()
    {
        super();
        intensity.value = [0.75];
        radius.value = [0.75];
    }
}

class ConcussionShader extends BaseShader
{
    @:glFragmentSource('
        #pragma header

        uniform float time;
        uniform float intensity;
        
        void main()
        {
            vec2 uv = openfl_TextureCoordv;
            float shake = intensity * 0.01 * sin(time * 20.0);
            
            vec2 center = vec2(0.5, 0.5);
            vec2 dir = uv - center;
            float dist = length(dir);
            
            vec2 offset = normalize(dir) * sin(dist * 8.0 - time * 3.0) * intensity * 0.01;
            vec2 newUV = uv + offset + vec2(shake);
            
            gl_FragColor = flixel_texture2D(bitmap, newUV);
        }
    ')
    
    public function new()
    {
        super();
        time.value = [0.0];
        intensity.value = [1.0];
    }
}

class ChromaticGlitchShader extends BaseShader
{
    @:glFragmentSource('
        #pragma header

        uniform float time;
        uniform float intensity;
        
        float random(vec2 st)
        {
            return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
        }
        
        void main()
        {
            vec2 uv = openfl_TextureCoordv;
            vec4 color = flixel_texture2D(bitmap, uv);
            
            float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
            color.rgb = vec3(gray);
            
            float lineNoise = random(vec2(floor(uv.y * 90.0), time));
            float glitchLine = step(0.96, lineNoise);
            
            float rOffset = random(vec2(time * 1.1, 1.0)) * 0.03 * intensity * glitchLine;
            float gOffset = random(vec2(time * 1.2, 2.0)) * 0.03 * intensity * glitchLine;
            float bOffset = random(vec2(time * 1.3, 3.0)) * 0.03 * intensity * glitchLine;
            
            vec4 rColor = flixel_texture2D(bitmap, vec2(uv.x + rOffset, uv.y));
            vec4 gColor = flixel_texture2D(bitmap, vec2(uv.x + gOffset, uv.y));
            vec4 bColor = flixel_texture2D(bitmap, vec2(uv.x + bOffset, uv.y));
            
            gl_FragColor = vec4(rColor.r, gColor.g, bColor.b, color.a);
            gray = dot(gl_FragColor.rgb, vec3(0.299, 0.587, 0.114));
            gl_FragColor.rgb = vec3(gray);
        }
    ')
    
    public function new()
    {
        super();
        time.value = [0.0];
        intensity.value = [1.0];
    }
}

class ShaderManager
{
    private static var _rgbGlitch:RGBGlitchShader;
    private static var _vignette:VignetteShader;
    private static var _concussion:ConcussionShader;
    private static var _chromaticGlitch:ChromaticGlitchShader;

    public static function getRGBGlitch():BaseShader
    {
        if (_rgbGlitch == null)
        {
            _rgbGlitch = new RGBGlitchShader();
            // Los uniforms ya están inicializados por el constructor
        }
            return _rgbGlitch;
    }

    public static function getVignette():BaseShader
    {
        if (_vignette == null) _vignette = new VignetteShader();
        return _vignette;
    }

    public static function getConcussion():BaseShader
    {
        if (_concussion == null) _concussion = new ConcussionShader();
        return _concussion;
    }

    public static function getChromaticGlitch():BaseShader
    {
        if (_chromaticGlitch == null) _chromaticGlitch = new ChromaticGlitchShader();
        return _chromaticGlitch;
    }

    public static function updateTime(shader:BaseShader, elapsed:Float):Void
        {
            if (shader != null)
            {
                shader.update(elapsed);
            }
        }
    
        public static function setIntensity(shader:BaseShader, intensity:Float):Void
        {
            if (shader != null && shader.data != null && shader.data.intensity != null)
            {
                shader.data.intensity.value = [intensity];
            }
        }
    
        public static function setRadius(shader:BaseShader, radius:Float):Void
        {
            if (shader != null && shader.data != null && shader.data.radius != null)
            {
                shader.data.radius.value = [radius];
            }
        }

    public static function destroyShader(shader:BaseShader):Void
    {
        if (shader != null)
        {
            shader.data = null;
        }
    }

    public static function destroyAllShaders():Void
    {
        if (_rgbGlitch != null) destroyShader(_rgbGlitch);
        if (_vignette != null) destroyShader(_vignette);
        if (_concussion != null) destroyShader(_concussion);
        if (_chromaticGlitch != null) destroyShader(_chromaticGlitch);
        
        _rgbGlitch = null;
        _vignette = null;
        _concussion = null;
        _chromaticGlitch = null;
    }
}