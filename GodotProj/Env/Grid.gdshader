shader_type spatial;

uniform vec3 base : source_color;
uniform vec3 gridCol : source_color;
const float scale = 50.0;
const float gridFact = 0.45;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 xzCoord = UV;
	
	float xGrid = round(fract(xzCoord.x * scale) - gridFact);
	float yGrid = round(fract(xzCoord.y * scale) - gridFact);
	
	
	float normMask = (INV_VIEW_MATRIX * vec4(NORMAL,0.0)).y;
	float grid = clamp((xGrid + yGrid) * normMask,0.0,1.0);
	
	ALBEDO = mix(base,gridCol,grid);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
