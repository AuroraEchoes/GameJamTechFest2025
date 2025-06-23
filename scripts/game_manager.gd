extends Node

var _game_start_time: int

func start_game():
	_game_start_time = Time.get_ticks_msec()

func elapsed_time_msec() -> int:
	return Time.get_ticks_msec() - _game_start_time
