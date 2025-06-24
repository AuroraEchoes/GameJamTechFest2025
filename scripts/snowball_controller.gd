extends RigidBody3D
class_name SnowballController

const SPEED = 20.0
const JUMP_VELOCITY = 4.5
var time := 0.0
var sizeNotified = false
var target_radius: float
var curr_radius: float
@onready var base_size: Vector3 = scale
@export var max_size_factor: float = 3.0
@export var min_volume: float = 0.1
@export var max_volume: float = 50.0
@export var size_change_speed: float = 0.25
var collision_particles: PackedScene = preload("res://scenes/SnowballDamageParticles.tscn")
@onready var mesh: MeshInstance3D = $"MeshInstance3D"
@onready var collision_shape: CollisionShape3D = $"CollisionShape3D"

func hit(volume: float) -> void:
	var particles = collision_particles.instantiate()
	particles.linear_velocity_additional = -linear_velocity * 50
	get_parent().add_child(particles)
	particles.global_position = global_position
	if get_volume() - volume < min_volume:
		GameManager.game_over_event.emit()
		queue_free()
	add_volume(-volume)

# v = (4/3) pi r^3
# 3v / 4 pi = r^3
# cuberoot(3v / 4pi) = r
func add_volume(volume: float) -> void:
	var curr_volume = get_volume()
	var new_volume: float = clampf(curr_volume + volume, min_volume, max_volume)
	var new_radius = pow((3.0 * new_volume) / (4.0 * PI), 1.0 / 3.0)
	target_radius = new_radius
	# TODO: tweak this
	mass = new_volume

func get_volume() -> float:
	var volume: float = (4.0 / 3.0) * PI * pow(target_radius, 3)
	return volume

# In m3/s
func snow_accumulation_rate(velocity: float):
	return 0.25 * log(velocity);

func calculate_score(delta: float):
	GameManager.score += delta * get_volume() * linear_velocity.z

func _process(delta: float) -> void:
	calculate_score(delta)

func _physics_process(delta: float) -> void:
	var input_dir: float = Input.get_axis("move_left", "move_right")
	if input_dir:
		apply_force(Vector3(-input_dir * SPEED * get_volume(), 0, 0))
	
	var delta_snow: float = snow_accumulation_rate(linear_velocity.length()) * delta
	add_volume(delta_snow)

	constant_force += Vector3.DOWN * delta * 0.5

	var new_radius = move_toward(curr_radius, target_radius, size_change_speed)
	var mesh_scale = new_radius / (mesh.mesh as SphereMesh).radius
	var col_shape_scale = new_radius / (collision_shape.shape as SphereShape3D).radius
	mesh.scale = Vector3(mesh_scale, mesh_scale, mesh_scale)
	collision_shape.scale = Vector3(col_shape_scale, col_shape_scale, col_shape_scale)
	curr_radius = new_radius
	GameManager.player_position = global_position
