extends CharacterBody3D

@export var target_path: NodePath
@export var speed: float = 200.0
@export var min_distance: float = 60.0
@export var smooth_factor: float = 5.0

var target: Node3D

func _ready() -> void:
	if target_path:
		target = get_node(target_path)

func _physics_process(delta: float) -> void:
	if not target:
		return
		
	var distance = global_position.distance_to(target.global_position)
	
	if distance > min_distance:
		var direction = global_position.direction_to(target.global_position)
		var target_velocity = direction * speed
		velocity = velocity.lerp(target_velocity, smooth_factor)

	else:
		velocity = velocity.lerp(Vector3.ZERO, smooth_factor)
	move_and_slide()
