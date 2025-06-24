extends Node3D

@export var camera: Camera3D

func _process(_delta: float) -> void:
	global_position = camera.global_position
