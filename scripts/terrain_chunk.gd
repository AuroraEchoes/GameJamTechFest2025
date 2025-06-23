extends Node3D
class_name TerrainChunk

@export var obstacles: Array[TerrainObstacle]
@onready var terrain_base: MeshInstance3D = $"Terrain"
var terrain_size: Vector2

func _ready() -> void:
	terrain_size = (terrain_base.mesh as PlaneMesh).size
	generate()

func generate() -> void:
	# TODO: Should probably be some terrain density parameter
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
