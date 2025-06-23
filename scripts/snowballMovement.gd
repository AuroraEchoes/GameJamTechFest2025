extends RigidBody3D


const SPEED = 10.0
const JUMP_VELOCITY = 4.5
var time := 0.0
var sizeNotified = false
@onready var base_size: Vector3 = scale
@export var max_size_factor: float = 3.0
@onready var mesh: MeshInstance3D = $"MeshInstance3D"
@onready var collision_shape: CollisionShape3D = $"CollisionShape3D"

func maxSizeReached() ->  void:
	print("Max Size Reached!!")


func _physics_process(delta: float) -> void:
	var input_dir := Input.get_axis("move_left", "move_right")
	if input_dir:
		apply_force(Vector3(-input_dir * SPEED, 0, 0))
		
	time += sqrt(delta) / 12
	var scaled = time
	
	if scaled >= (base_size.x * max_size_factor) and not sizeNotified:
		maxSizeReached()
		sizeNotified = true
	
	var clampedScale: Vector3 = Vector3(
		min(scaled, max_size_factor * base_size.x),
		min(scaled, max_size_factor * base_size.y),
		min(scaled, max_size_factor * base_size.z)
	)

	mesh.scale = clampedScale
	collision_shape.scale = clampedScale
