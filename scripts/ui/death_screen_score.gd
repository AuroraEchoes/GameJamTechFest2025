extends Label

func _ready() -> void:
	text = "Score: " + str(int(GameManager.score))
