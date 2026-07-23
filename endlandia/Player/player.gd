extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25

var _camera_input_direction := Vector2.ZERO

@onready var _camera_pivot: Node3D = %Pivot

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Left Click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		


func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity

var SPEED = 8.0
var ACCELERATION = 0.6
const JUMP_VELOCITY = 10

const SLIDE_SLIP_ANGLE = 0.1745329
const NORMAL_SLIP_ANGLE = 0.7853982
var IS_CHROUCHED = false
var IS_SLIDING = false
var IS_DIVING = false
func _physics_process(delta: float) -> void:
	# Add the gravity.
	_camera_pivot.rotation.x += -_camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, -PI / 6.0, PI / 1.5)
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	_camera_input_direction = Vector2.ZERO
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (_camera_pivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if not is_on_floor():
		velocity += get_gravity() * delta * 2

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if IS_CHROUCHED: 
			velocity.y = JUMP_VELOCITY * 1.5
		else:
			velocity.y = JUMP_VELOCITY
		

# handle jumping not having as much fine grained control

	if not is_on_floor():
		ACCELERATION = 0.2
	else :
		ACCELERATION -= 0.6
#Handle slide/jump
	if Input.is_action_pressed("Sprint"):
		
		if is_on_floor():
			IS_DIVING = false
			IS_SLIDING = true
			#handle the different physics for sliding crouching ect
			if velocity.length() < 2 && is_on_floor():
				IS_CHROUCHED = true
			if IS_CHROUCHED:
				SPEED = 2
				wall_min_slide_angle = SLIDE_SLIP_ANGLE
				ACCELERATION = 0.6
			else:
				SPEED = 2
				wall_min_slide_angle = SLIDE_SLIP_ANGLE
				ACCELERATION = 0.05
		print("Sliding")
		
		
		
	else:
		IS_CHROUCHED = false
		if is_on_floor():
			IS_DIVING = false
			IS_SLIDING = false
			wall_min_slide_angle = NORMAL_SLIP_ANGLE
			SPEED = 8
			ACCELERATION = 0.6
	if Input.is_action_just_pressed("Sprint"):
		if not is_on_floor() && IS_DIVING == false:
			#dive
			IS_DIVING = true
			velocity.x = direction.x * 15
			velocity.z = direction.z * 15
			velocity.y = 3
			ACCELERATION = 0.05
			SPEED = 5
		if is_on_floor():
			velocity.x = direction.x * 6
			velocity.z = direction.z * 6
			

	
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION)
		velocity.z = move_toward(velocity.z, 0, ACCELERATION)

	move_and_slide()
