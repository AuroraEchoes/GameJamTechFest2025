extends Control

var time: float = 0.0
@onready var base_position = global_position

func _process(delta: float) -> void:
	time += delta
	var scl = 1.0 + 0.04 * sin(time * 1.1)
	scale = Vector2(scl, scl)
