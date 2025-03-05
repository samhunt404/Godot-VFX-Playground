shader_type spatial;
render_mode cull_disabled;

uniform sampler2D portalTex : source_color;
uniform sampler2D CRTTex : source_color;
uniform sampler2D static : source_color;

varying float depth;
void vertex()
{
	depth = length(NODE_POSITION_WORLD + vec3(0.0,1.0,0.0) - CAMERA_POSITION_WORLD) - 2.0;
	depth = clamp(depth,-2.0,1.0);
	float dist = length(VERTEX - vec3(0.0,0.0,0.01));
	//VERTEX += -NORMAL * 0.0015 * -(2.0-dist * 30.0);
}

void fragment() {
	vec3 portalCol = texture(portalTex,SCREEN_UV).rgb;
	vec3 crtCol = texture(CRTTex,UV * 10.0).rgb * texture(static,UV + vec2(0.0,TIME * -4.0)).rgb;
	float depthAlpha = clamp(0.5-depth,0.0,1.0);
	ALBEDO = mix(portalCol * crtCol,portalCol,depthAlpha);
	ROUGHNESS = 0.05;
	METALLIC = 0.1;
	EMISSION = ALBEDO * 1.0 + clamp(crtCol * depth,0.0,1.0);

}





