extends TextureRect

@export var scroll_speed: float = 20.0

func _process(delta: float) -> void:
	var noise: FastNoiseLite = texture.noise as FastNoiseLite
	noise.offset += Vector3(1, 0.25, 0.0) * delta * scroll_speed;
