class_name Portal
extends Node3D

@export var paired : Portal

@onready var camControl : RemoteTransform3D
@onready var portalVis : MeshInstance3D
@onready var viewport : SubViewport

var collisionEnabled = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camControl = $CamController
	portalVis = $PortalAsset/Plane
	viewport = $Renderer
	
	viewport.size = get_tree().get_root().size
	portalVis._update_texture(viewport.get_texture())
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#null check for when viewport isn't initialized
	if(get_viewport().get_camera_3d() == null):
		return
	var rotDiff = (rotation.y - PI) - paired.rotation.y
	camControl.transform = paired.global_transform.inverse().rotated(Vector3.UP,rotDiff) * get_viewport().get_camera_3d().global_transform 
	

func _teleport_obj(other : Node3D):
	if(not collisionEnabled):
		return
	if(other is CharacterBody3D or other is RigidBody3D):
		paired.collisionEnabled = false
		other.global_position = paired.camControl.global_position
		other.global_position.y -= 1.5 #offset for player height

func _reset_teleport(other : Node3D):
	if(other is CharacterBody3D or other is RigidBody3D):
		collisionEnabled = true
