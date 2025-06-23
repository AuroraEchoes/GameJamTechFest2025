extends Node3D
class_name HillManager

var chunks: Array[TerrainChunk]
var chunks_generated_count: int = 0
var scale_to_max_completion: float = 0.0
@export var angle: float = -30
@export var chunk_scene: PackedScene
@export var ui_container: CanvasLayer

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
@export var biome_chunk_length = 3
@export var biome_transition_length = 2
# biome or transition
var in_biome: bool = true
var segment_chunks_generated: int = 0
var prev_biome: Biome
var next_biome: Biome

enum Biome
{
	# Many trees, some dead trees/stumps, few rocks
	FOREST,
	# Many dead trees/stumps, some rocks, few trees
	DEAD_FOREST,
	# Many snowmen, few snow cannons, flags and fences
	SNOWMAN_HAVEN,
	# Many flags and fences, some snow cannons
	SKIING_RACE,
	# Many rocks, some flags and fences, some dead trees
	ROCKY_OUTCROPS,
	# Many trash
	TRASHYARD
}

# Z+ is fowards (down)

func _ready() -> void:
	GameManager.start_game()
	for i in range(15):
		spawn_chunk()

func _process(_delta: float) -> void:
	despawn_passed_chunks()

func despawn_passed_chunks() -> void:
	if chunks.is_empty(): return
	var oldest_chunk: TerrainChunk = chunks.front()
	var chunk_size: float = oldest_chunk.terrain_size.y
	var min_dist_to_despawn: float = chunk_size * 2
	if oldest_chunk.global_position.distance_to(GameManager.player_position) > min_dist_to_despawn:
		chunks.pop_front()
		oldest_chunk.queue_free()
		# Spawn a replacment chunk
		spawn_chunk()

func next_chunk_biome() -> Array[Biome]:
	if in_biome:
		if segment_chunks_generated >= biome_chunk_length:
			in_biome = false
			segment_chunks_generated = 1
			prev_biome = next_biome
			next_biome = range(Biome.size()).pick_random()
			return [prev_biome, next_biome]
		else:
			segment_chunks_generated += 1
			return [next_biome]
	else:
		if segment_chunks_generated >= biome_transition_length:
			in_biome = true
			segment_chunks_generated = 1
			return [next_biome]
		else:
			segment_chunks_generated += 1
			return [prev_biome, next_biome]

func spawn_chunk() -> void:
	var chunk: TerrainChunk = chunk_scene.instantiate() as TerrainChunk
	add_child(chunk)
	chunk.generate(self, next_chunk_biome())
	chunk.rotate_x(deg_to_rad(angle))
	if !chunks.is_empty():
		var prev_chunk: TerrainChunk = chunks.back()
		var z_diff = chunk.terrain_size.y * cos(deg_to_rad(angle))
		var y_diff = -z_diff * tan(deg_to_rad(angle))
		var next_chunk_pos = prev_chunk.position + Vector3(0, y_diff, z_diff)
		chunk.position = next_chunk_pos
	chunks.push_back(chunk)
	chunks_generated_count += 1
	scale_to_max_completion = float(chunks_generated_count) / float(chunks_to_scale_to_max)

# TODO: Despawn chunks which are behind
