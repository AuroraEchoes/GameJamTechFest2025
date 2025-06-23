extends Node

signal game_over_event
signal game_restart_event

var _game_start_time: int
var player_position: Vector3
var score: float

func _ready() -> void:
	game_restart_event.connect(_reset)

func start_game():
	score = 0
	_game_start_time = Time.get_ticks_msec()

func elapsed_time_msec() -> int:
	return Time.get_ticks_msec() - _game_start_time

func pause():
	get_tree().paused = true

func unpause():
	get_tree().paused = false

func _reset():
	_game_start_time = 0
	score = 0
