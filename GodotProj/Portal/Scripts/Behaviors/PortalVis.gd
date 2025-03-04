extends MeshInstance3D

func _update_texture(tex : ViewportTexture) -> void:
	get_surface_override_material(0).set_shader_parameter("portalTex",tex)
