extends Node3D
class_name TerrainChunk

@export var obstacles: Array[TerrainObstacle]
@export var min_obstacles_per_chunk: int = 5
@onready var terrain_base: MeshInstance3D = $"Terrain"
var terrain_size: Vector2

func _ready() -> void:
	terrain_size = (terrain_base.mesh as PlaneMesh).size

func generate(hill_params: HillManager) -> void:
	# (Claimed position centre, scale (leave free radius))
	var claimed_positions: Dictionary[Vector3, float] = {}
	# Don’t ask me to explain this
	# I can’t do it
	var completion = hill_params.scale_to_max_completion
	var obst_density_sample = hill_params.obstacle_density.sample(completion)
	var obst_variance_sample = hill_params.obstacle_density_variance.sample(completion)
	var obst_variance = randf_range(-obst_variance_sample, obst_variance_sample)
	var obst_density = obst_density_sample + obst_variance
	var num_obstacles = lerpf(hill_params.min_obstacles_per_chunk, hill_params.max_obstacles_per_chunk, obst_density)
	for i in range(num_obstacles):
		var scale_base_sample = hill_params.obstacle_base_scale.sample(completion)
		var scale_variance_sample = hill_params.obstacle_scale_variance.sample(completion)
		var scale_variance = randf_range(-scale_variance_sample, scale_variance_sample)
		var relative_scale = scale_base_sample + scale_variance
		var obst_scale = lerpf(hill_params.min_scale, hill_params.max_scale, relative_scale)
		var obstacle = select_obstacle()
		var spawn_pos_valid: bool = false
		var spawn_pos: Vector3
		# Dumb loop until we have a valid spawn point
		while !spawn_pos_valid:
			spawn_pos = Vector3(
				randf_range(-terrain_size.x / 2, terrain_size.x / 2),
				0,
				randf_range(-terrain_size.y / 2, terrain_size.y / 2)
			)
			spawn_pos_valid = true
			for pos in claimed_positions:
				var pos_radius = claimed_positions[pos]
				spawn_pos_valid = pos.distance_to(spawn_pos) > pos_radius and spawn_pos_valid
		var scene = obstacle.scene.instantiate() as Node3D
		scene.position = spawn_pos
		scene.scale = Vector3(obst_scale, obst_scale, obst_scale)
		add_child(scene)
		
	for i in range(10):
		var obstacle = select_obstacle()
		# TODO: check for overlapping
		var spawn_pos = Vector3(
			randf_range(-terrain_size.x / 2, terrain_size.x / 2),
			0,
			randf_range(-terrain_size.y / 2, terrain_size.y / 2)
		)
		var scene = obstacle.scene.instantiate() as Node3D
		scene.position = spawn_pos
		add_child(scene)

# Select an obstacle from the pool (each has an integer probability)
func select_obstacle() -> TerrainObstacle:
	var probability_total: int = 0
	for obstacle in obstacles:
		probability_total += obstacle.probability_weight
	var obstacle_weight = randi_range(0, max(probability_total - 1, 0))
	var obstacle_idx = 0
	while obstacle_weight > 0:
		obstacle_weight -= obstacles[obstacle_idx].probability_weight
		if obstacle_weight > 0:
			obstacle_idx += 1
	return obstacles[obstacle_idx]
