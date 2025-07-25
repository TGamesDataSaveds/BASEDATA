#pragma header

uniform float time;

void main()
{
    vec2 uv = openfl_TextureCoordv;
    uv.y += sin(uv.x * 10.0 + time) * 0.1;
    gl_FragColor = flixel_texture2D(bitmap, uv);
}