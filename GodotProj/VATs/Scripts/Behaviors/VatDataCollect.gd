extends Node

@onready var MeshPrimitive : Mesh
@export var VatMat : ShaderMaterial

func _ready() -> void:
	MeshPrimitive = $MESH.mesh
	VatMat.set_shader_parameter("BoundMax",MeshPrimitive.get_aabb().end)
	VatMat.set_shader_parameter("BoundMin",MeshPrimitive.get_aabb().position)
	print(MeshPrimitive.get_aabb().end)
	print(MeshPrimitive.get_aabb().position)
	pass
