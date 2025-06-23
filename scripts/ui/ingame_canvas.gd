extends CanvasLayer

@export var end_screen: PackedScene

func _ready() -> void:
	GameManager.game_over_event.connect(spawn_end_screen)

func spawn_end_screen():
	add_child(end_screen.instantiate())
