extends Control

@export var instruction_panel: PanelContainer
@export var continue_panel: PanelContainer
@export var instruction_label: RichTextLabel

signal continue_tutorial

var controls: String = keyboard_icon("keyboard_a") + " / " + keyboard_icon("keyboard_arrow_left") + " and " + keyboard_icon("keyboard_d") + " / " + keyboard_icon("keyboard_arrow_right") + "to move."
var rolling: String = "As you roll, you gain speed and size"
var hitting: String = "Hitting obstacles will remove snow"
var death: String = "If you run out of snow, you will die"

func keyboard_icon(icon_name: String) -> String:
	return "[img={width=40}]res://assets/images/" + icon_name + ".png[/img]"

func _ready() -> void:
	tween_in_panels(controls)
	await continue_tutorial
	tween_out_panels()
	await get_tree().create_timer(8).timeout
	tween_in_panels(rolling)
	await continue_tutorial
	tween_out_panels()
	await get_tree().create_timer(8).timeout
	tween_in_panels(hitting)
	await continue_tutorial
	tween_out_panels()
	await get_tree().create_timer(8).timeout
	tween_in_panels(death)
	await continue_tutorial
	tween_out_panels()


func tween_in_panels(instruction: String):
	GameManager.pause()
	instruction_panel.modulate.a = 0
	continue_panel.modulate.a = 0
	instruction_label.text = instruction
	instruction_label.visible_ratio = 0
	self.create_tween().tween_property(instruction_panel, "modulate:a", 1, 1)
	get_tree().create_timer(0.5).timeout.connect(func():
		self.create_tween().tween_property(instruction_label, "visible_ratio", 1, 1)
	)
	get_tree().create_timer(2).timeout.connect(func():
		self.create_tween().tween_property(continue_panel, "modulate:a", 1, 0.5)
	)
	await get_tree().create_timer(4.0).timeout

func tween_out_panels():
	GameManager.unpause()
	self.create_tween().tween_property(instruction_panel, "modulate:a", 0, 0.25)
	self.create_tween().tween_property(continue_panel, "modulate:a", 0, 0.25)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		continue_tutorial.emit()
