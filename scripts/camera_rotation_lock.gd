extends Camera3D

@onready var base_rotation: Vector3 = global_rotation
@onready var rigidbody: RigidBody3D = $"../Rigidbody"
@onready var rb_offset: Vector3 = global_position - rigidbody.global_position

func _ready() -> void:
	GameManager.game_over_event.connect(death_pan)

func _physics_process(_delta: float) -> void:
	if rigidbody != null:
		global_position = rigidbody.global_position + rb_offset

# Slow pan up
func death_pan():
	get_tree().create_tween().tween_property(self, "fov", 40, 1.0).finished.connect(func():
		get_tree().create_tween().tween_property(self, "rotation", Vector3(deg_to_rad(0), rotation.y, rotation.z), 5.0))
