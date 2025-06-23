extends Node3D
class_name HillManager

var player_pos: Vector3
var chunks: Array[TerrainChunk]
var chunks_generated_count: int = 0
var scale_to_max_completion: float = 0.0
@export var angle: float = -30
@export var chunk_scene: PackedScene

@export_category("Difficulty Scaling")
@export var min_obstacles_per_chunk: int = 5
@export var max_obstacles_per_chunk: int = 20
@export var min_scale: float = 0.6
@export var max_scale: float = 4.0
@export var chunks_to_scale_to_max: int = 15
@export var obstacle_base_scale: Curve
@export var obstacle_scale_variance: Curve
@export var obstacle_density: Curve
@export var obstacle_density_variance: Curve

# Z+ is fowards (down)

func _ready() -> void:
	for i in range(10):
		spawn_chunk()

func spawn_chunk() -> void:
	var chunk: TerrainChunk = chunk_scene.instantiate() as TerrainChunk
	add_child(chunk)
	chunk.generate(self)
	chunk.rotate_x(deg_to_rad(angle))
	if !chunks.is_empty():
		var prev_chunk: TerrainChunk = chunks.back()
		var z_diff = prev_chunk.terrain_size.y / 2
		var y_diff = -z_diff * tan(deg_to_rad(angle))
		var next_chunk_pos = prev_chunk.position + Vector3(0, y_diff, z_diff)
		chunk.position = next_chunk_pos
	chunks.push_back(chunk)
	chunks_generated_count += 1
	scale_to_max_completion = float(chunks_generated_count) / float(chunks_to_scale_to_max)

# TODO: Despawn chunks which are behind
