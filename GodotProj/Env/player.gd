extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

#@export var camOverride : Camera3D
@export var sensitivity : float
@export var verticalLim : float
@onready var mainCamera : Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	mainCamera = $Camera3D
	#if(camOverride != null):
		#mainCamera = camOverride

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		rotate_y(-event.relative.x * 0.01 * sensitivity)
		
		mainCamera.rotate_x(-event.relative.y * 0.01 * sensitivity);
		mainCamera.rotation_degrees.x = clamp(mainCamera.rotation_degrees.x,-verticalLim * 0.5, verticalLim * 0.5)
