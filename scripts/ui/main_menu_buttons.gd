extends Control

@export var tutorial_button: Button
@export var play_button: Button
@export var quit_button: Button
@export var tutorial_manager: PackedScene

func _ready() -> void:
	play_button.pressed.connect(play)
	quit_button.pressed.connect(func(): get_tree().quit())
	tutorial_button.pressed.connect(tutorial)

func play():
	get_parent().add_child(GameManager.hill_scene.instantiate())
	queue_free()

func tutorial():
	var hs: HillManager = GameManager.hill_scene.instantiate()
	get_parent().add_child(hs)
	hs.ui_container.add_child(tutorial_manager.instantiate())
	queue_free()
