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
	
	

var init := false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(not init and paired != null):
		paired.portalVis._update_texture(viewport.get_texture())
		init = true
	
	var cam := get_viewport().get_camera_3d()
	#null check for when viewport isn't initialized
	if(cam == null):
		return
	#check if far enough away to not update the texture to save some performance\
	if(position.distance_to(cam.position) > 10.0 && paired.position.distance_to(cam.position) > 10.0):
		return
	var rotDiff := PI-(paired.global_rotation.y - global_rotation.y)
	camControl.transform = paired.transform.inverse().rotated(Vector3.UP,rotDiff) * cam.global_transform 
	#camControl.global_position = to_global(paired.to_local(cam.global_position));
	#camControl.global_rotation = (global_rotation - paired.global_rotation) + cam.global_rotation

func _teleport_obj(other : Node3D):
	if(not collisionEnabled):
		return
	if(other is CharacterBody3D or other is RigidBody3D):
		paired.portalVis.visible = false
		paired.collisionEnabled = false
		
		other.global_position = paired.camControl.global_position
		other.global_rotation.y = paired.camControl.global_rotation.y
		other.position -= get_viewport().get_camera_3d().position
		
		

func _reset_teleport(other : Node3D):
	if(other is CharacterBody3D or other is RigidBody3D):
		portalVis.visible = true
		collisionEnabled = true
