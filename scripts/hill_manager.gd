extends Node3D

var player_pos: Vector3
var chunks: Array[TerrainChunk]
@export var angle: float = -30
@export var chunk_scene: PackedScene

# Z+ is fowards (down)

func _ready() -> void:
	for i in range(10):
		spawn_chunk()

func spawn_chunk() -> void:
	var chunk: TerrainChunk = chunk_scene.instantiate() as TerrainChunk
	chunk.generate()
	chunk.rotate_x(deg_to_rad(angle))
	if !chunks.is_empty():
		var prev_chunk: TerrainChunk = chunks.back()
		var z_diff = prev_chunk.terrain_size.y / 2 + chunk.terrain_size.y / 2
		var y_diff = -z_diff * tan(deg_to_rad(angle))
		var next_chunk_pos = prev_chunk.position + Vector3(0, y_diff, z_diff)
		chunk.position = next_chunk_pos
	chunks.push_back(chunk)
	add_child(chunk)

# TODO: Despawn chunks which are behind
