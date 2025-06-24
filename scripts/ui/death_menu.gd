extends Control

@export var again_button: Button
@export var main_menu_button: Button

func _ready() -> void:
	modulate.a = 0
	get_tree().create_tween().tween_property(self, "modulate:a", 1, 1.0)
	again_button.pressed.connect(again)
	main_menu_button.pressed.connect(main_menu)

func scene_root() -> Node:
	return get_parent().get_parent()

# the insanity is getting to me
func again():
	var scn_root = scene_root()
	scn_root.get_parent().add_child(GameManager.hill_scene.instantiate())
	scn_root.queue_free()
	GameManager.game_restart_event.emit()

func main_menu():
	var scn_root = scene_root()
	scn_root.get_parent().add_child(GameManager.main_menu_scene.instantiate())
	scn_root.queue_free()
