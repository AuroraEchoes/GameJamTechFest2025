extends Node3D
class_name TerrainChunk

@export var obstacles: Array[TerrainObstacle]
@export var min_obstacles_per_chunk: int = 5
@export var x_sides_margin: float = 1.0
@onready var terrain_base: MeshInstance3D = $"Terrain"
@export var left_wall: MeshInstance3D
@export var right_wall: MeshInstance3D
@export var texture_offset_per_chunk: Vector3 = Vector3(384, 0, 0)
var terrain_size: Vector2

func _ready() -> void:
	terrain_size = (terrain_base.mesh as PlaneMesh).size

func select_valid_obstacles(biomes: Array[HillManager.Biome]) -> Array[int]:
	# WHAT IM DOING HERE:
	# filtering for all obstacles in the valid biome set
	# incrementing through every number in the probability
	# weight space
	# creating a dict pointing to the obstacle’s index
	# in the obstacles array
	var weighted_index_list: Array[int] = []
	for ob_idx in range(len(obstacles)):
		var obstacle = obstacles[ob_idx]
		for biome in biomes:
			var obstacle_biome_weight: int = obstacle.biome_weight(biome)
			for i in range(obstacle_biome_weight):
				weighted_index_list.push_back(ob_idx)
	return weighted_index_list
	

func generate(hill_params: HillManager, biomes: Array[HillManager.Biome]) -> void:
	# just shoot me here mahyaps
	((left_wall.mesh as PlaneMesh).material as ShaderMaterial).set_shader_parameter("shader_parameter/noise:noise:offset:x", texture_offset_per_chunk * hill_params.chunks_generated_count)
	((right_wall.mesh as PlaneMesh).material as ShaderMaterial).set_shader_parameter("shader_parameter/noise:noise:offset:x", texture_offset_per_chunk * hill_params.chunks_generated_count)
	# (Claimed position centre, scale (leave free radius))
	var claimed_positions: Dictionary[Vector3, float] = {}
	# Don’t ask me to explain this
	# I can’t do it
	var completion = hill_params.scale_to_max_completion
	var obst_density_sample = hill_params.obstacle_density.sample(completion)
	var obst_variance_sample = hill_params.obstacle_density_variance.sample(completion)
	var obst_variance = randf_range(-obst_variance_sample, obst_variance_sample)
	var obst_density = obst_density_sample + obst_variance
	var num_obstacles = int(lerpf(hill_params.min_obstacles_per_chunk, hill_params.max_obstacles_per_chunk, obst_density))
	for i in range(num_obstacles):
		var scale_base_sample = hill_params.obstacle_base_scale.sample(completion)
		var scale_variance_sample = hill_params.obstacle_scale_variance.sample(completion)
		var scale_variance = randf_range(-scale_variance_sample, scale_variance_sample)
		var relative_scale = scale_base_sample + scale_variance
		var obst_scale = lerpf(hill_params.min_scale, hill_params.max_scale, relative_scale)
		var obstacle: TerrainObstacle = select_obstacle(biomes)
		var spawn_pos_valid: bool = false
		var spawn_pos: Vector3
		# Dumb loop until we have a valid spawn point
		while !spawn_pos_valid:
			spawn_pos = Vector3(
				randf_range(-terrain_size.x / 2 + x_sides_margin, terrain_size.x / 2 - x_sides_margin),
				0,
				randf_range(-terrain_size.y / 2, terrain_size.y / 2)
			)
			spawn_pos_valid = true
			for pos in claimed_positions:
				var pos_radius = claimed_positions[pos]
				spawn_pos_valid = pos.distance_to(spawn_pos) > pos_radius and spawn_pos_valid
		var scene = obstacle.scene.instantiate()
		scene.position = spawn_pos
		scene.set_base_volume(obstacle.base_volume)
		scene.rotate_y(randf_range(0, TAU))
		scene.rotate_x(-deg_to_rad(hill_params.angle) * 2.0 / 3.0)
		scene.set_uniform_scale(obst_scale)
		add_child(scene)
	
# Select an obstacle from the pool (each has an integer probability)
func select_obstacle(biomes: Array[HillManager.Biome]) -> TerrainObstacle:
	var weight_list: Array[int] = select_valid_obstacles(biomes)
	var obstacle = randi_range(0, weight_list.size() - 1)
	return obstacles[weight_list[obstacle]]
