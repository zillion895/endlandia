extends CharacterBody3D

@export_group("Follower")
@export_group("Idler")

@export var target_path: NodePath
@export var speed: float = 8.0
@export var min_distance: float = 6.0
@export var smooth_factor: float = 0.02

var target: Node3D	

func _ready() -> void:
	%Follower.visible = false
	%Idler.visible = true
	if target_path:
		target = get_node(target_path)
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Follow"):
		%Idler.visible = false
		%Follower.visible = true
	elif event.is_action_pressed("Idle"):
		%Idler.visible = true
		%Follower.visible = false
		

func _physics_process(delta: float) -> void:
	if %Follower.visible:
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
