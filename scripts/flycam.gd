extends Camera3D

@export var move_speed: float = 5

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		position.z += delta * move_speed
	if Input.is_action_pressed("ui_down"):
		position.z -= delta * move_speed
	if Input.is_action_pressed("ui_left"):
		position.x += delta * move_speed
	if Input.is_action_pressed("ui_right"):
		position.x -= delta * move_speed
