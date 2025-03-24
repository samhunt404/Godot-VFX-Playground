shader_type spatial;

uniform sampler2D lookup : filter_nearest;
uniform sampler2D pos : filter_nearest;
uniform sampler2D rot : filter_nearest;

uniform int currentFrame = 0;
uniform int frameRate = 30;

const int offset = 144; //hard found
void vertex()
{
	vec2 pixSize = 1.0/vec2(textureSize(lookup,0));
	float frameYOffset = float(currentFrame + offset) * pixSize.y;
	frameYOffset += float(currentFrame) * pixSize.y;
	vec3 lookupVal = textureLod(lookup,UV + vec2(0,frameYOffset),0.0).rgb;
	vec3 normSample = textureLod(rot,lookupVal.xy,0.0).rgb;
	vec3 posSample = textureLod(pos,lookupVal.xy,0.0).rgb;
	
	VERTEX = posSample * 0.01;
	NORMAL = normSample;
	
}
void fragment()
{
	ALBEDO = vec3(1.0);
}
