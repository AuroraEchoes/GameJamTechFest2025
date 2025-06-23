extends RichTextLabel

func _process(_delta: float) -> void:
	text = "Score: " + str(int(GameManager.score))
