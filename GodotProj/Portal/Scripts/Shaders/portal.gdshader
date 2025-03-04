shader_type spatial;
render_mode unshaded, cull_disabled,depth_draw_never;

uniform sampler2D portalTex : source_color;
void vertex() 
{

}

void fragment() {
	ALBEDO = texture(portalTex,SCREEN_UV).rgb;
}





