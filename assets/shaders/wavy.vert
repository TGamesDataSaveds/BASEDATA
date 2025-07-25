#pragma header
attribute vec4 openfl_Position;
attribute vec2 openfl_TextureCoord;
uniform mat4 openfl_Matrix;
varying vec2 vTexCoord;

void main(void)
{
    gl_Position = openfl_Matrix * openfl_Position;
    vTexCoord = openfl_TextureCoord;
}