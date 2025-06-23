extends CPUParticles3D

var linear_velocity_additional: Vector3

func _ready() -> void:
	emitting = true
	direction += linear_velocity_additional
	get_tree().create_timer(lifetime + 0.1).timeout.connect(func(): queue_free())
