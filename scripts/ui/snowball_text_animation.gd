extends RichTextLabel

var time: float = 0.0
@onready var base_position = global_position

func _process(delta: float) -> void:
	time += delta
	var scl = 1.0 + 0.03 * sin(time)
	scale = Vector2(scl, scl)
