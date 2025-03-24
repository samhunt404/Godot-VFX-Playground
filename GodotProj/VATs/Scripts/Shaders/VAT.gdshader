shader_type spatial;

uniform vec3 BoundMax;
uniform vec3 BoundMin;

uniform sampler2D lookup : filter_nearest, source_color;
uniform sampler2D pos : filter_nearest, source_color;
uniform sampler2D rot : filter_nearest, source_color;

uniform float gameTimeFirstFrame = 0;
uniform int frameRate = 30;

void vertex()
{
	//a lot of bounds preprocessors
	vec3 adjBoundMax = round(BoundMax * 10000.0)/10000.0;
	vec3 adjBoundMin = round(BoundMin * 10000.0)/10000.0;
	//maxbounds process
	//NOTE: unsure if Y is correct (unreal coordinate system is different)
	float compare = round(100.0 * (adjBoundMax.y - floor(adjBoundMax.y)));
	float compA = mod(compare,10.0);
	float compB = mod(compare,25.0);
	float resultMax = 0.0;
	if(compA >= 0.05 && compB > 0.05)
	{
		float absVal = abs(mod(compare,50.0) - 25.0);
		resultMax = (25.0-absVal) - floor((25.0-absVal)/10.0);
	}
	resultMax = round(resultMax) * 100.0;
	
	//minbounds process
	//NOTE: unsure if XYZ -> XYZ is correct
	float minX = round(ceil(adjBoundMin.x) - adjBoundMin.x * 100.0);
	float minY = 1.0-(ceil(adjBoundMin.y) - adjBoundMin.y); //active pixel ratio x (maybe)
	float minZ = 1.0-(ceil(adjBoundMin.z) - adjBoundMin.z); //active pixel ratio y (maybe)
	
	float animationUVRowCount = (minX + resultMax);
	float animationFrameCount = round(float(textureSize(lookup,0).y) * minZ)/animationUVRowCount;
	
	vec2 thisFrameUV = vec2(float(frameRate)/(animationFrameCount - 0.01));
	thisFrameUV.x = UV.x * minY;
	float timeAdj = TIME - gameTimeFirstFrame;
	
	thisFrameUV.y *= timeAdj;
	
	thisFrameUV.y = mod(floor(fract(thisFrameUV.y) * animationFrameCount),animationFrameCount);
	thisFrameUV.y *= 1.0/animationFrameCount;
	
	thisFrameUV.y = thisFrameUV.y + UV.y * minZ;
	
	
	
	vec3 lookupTexRead = texture(lookup,thisFrameUV).rgb;
}
void fragment()
{
	ALBEDO = vec3(1.0);
}
