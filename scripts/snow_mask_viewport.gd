extends SubViewport

@export var mesh: MeshInstance3D
@onready var plane_mesh: PlaneMesh = mesh.mesh as PlaneMesh
@onready var mesh_size = plane_mesh.size
@onready var mesh_subdivisions = Vector2(plane_mesh.subdivide_width, plane_mesh.subdivide_depth)
@onready var brush: TextureRect = $"TextureRect"

func _ready() -> void:
	size = mesh_subdivisions

func _process(delta: float) -> void:
	var player_relative_pos = mesh.global_position - GameManager.player_position
	var player_relative_pos_xz = Vector2(player_relative_pos.x, player_relative_pos.z)
	# player_relative_pos_xz -= mesh_size / 2.0
	var clip_pos = player_relative_pos_xz / mesh_size
	brush.position = clip_pos * mesh_subdivisions
