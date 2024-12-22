#if defined(VERTEX)

attribute vec4 VertexCoord;
attribute vec4 COLOR;
attribute vec4 TexCoord;
varying vec4 COL0;
varying vec4 TEX0;

vec4 _oPosition1; 
uniform mat4 MVPMatrix;
uniform int FrameDirection;
uniform int FrameCount;
uniform vec2 OutputSize;
uniform vec2 TextureSize;
uniform vec2 InputSize;

void main()
{
    vec4 _oColor;
    vec2 _otexCoord;
    gl_Position = VertexCoord.x * MVPMatrix[0] + VertexCoord.y * MVPMatrix[1] + VertexCoord.z * MVPMatrix[2] + VertexCoord.w * MVPMatrix[3];
    _oPosition1 = gl_Position;
    _oColor = COLOR;
    _otexCoord = TexCoord.xy;
    COL0 = COLOR;
    TEX0.xy = TexCoord.xy;
}

#elif defined(FRAGMENT)

#define BRIGHTNESS 0.5

struct output_dummy {
    vec4 _color;
};

uniform int FrameDirection;
uniform int FrameCount;
uniform vec2 OutputSize;
uniform vec2 TextureSize;
uniform vec2 InputSize;
uniform sampler2D Texture;
varying vec4 TEX0;
//standard texture sample looks like this: texture2D(Texture, TEX0.xy);

void main()
{
	vec4 myColor = texture2D(Texture, TEX0.xy);
	mat4 neighbours = mat4(
		texture2D(Texture, vec2(TEX0.x+1./TextureSize.x, TEX0.y)),
		texture2D(Texture, vec2(TEX0.x-1./TextureSize.x, TEX0.y)),
		texture2D(Texture, vec2(TEX0.x, TEX0.y+1./TextureSize.y)),
		texture2D(Texture, vec2(TEX0.x, TEX0.y-1./TextureSize.y))
	);	
	mat4 zero = mat4(
		0.,0.,0.,0.,
		0.,0.,0.,0.,
		0.,0.,0.,0.,
		0.,0.,0.,0.
	);
	
    if(length(myColor) == 0. && neighbours != zero){
    	
    	myColor = ((neighbours[0] + neighbours[1] + neighbours[2] + neighbours[3]) / 4.) * BRIGHTNESS;
    	
    } else if (length(myColor) != 0. && neighbours == zero) {
    	
    	myColor = myColor * BRIGHTNESS;
    	
    }
    gl_FragColor = myColor;
    return;
} 
#endif
