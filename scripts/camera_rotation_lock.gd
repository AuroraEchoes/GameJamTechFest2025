extends Camera3D

@onready var base_rotation: Vector3 = global_rotation
@onready var rigidbody: RigidBody3D = $"../Rigidbody"
@onready var rb_offset: Vector3 = global_position - rigidbody.global_position

func _physics_process(delta: float) -> void:
	global_position = rigidbody.global_position + rb_offset
