extends Node3D
class_name Obstacle

@onready var area: Area3D = $"Area3D"
var base_volume: float = 10.0
# TODO: this is bad. turn the TerrainObstacle resource into this class and only take that in TerrainChunk
# then calll a set scale and dont get it by this hacky way
@onready var volume: float = base_volume

func _ready() -> void:
	area.body_entered.connect(on_area_entered_event)

func set_base_volume(base_vol: float):
	base_volume = base_vol

func set_uniform_scale(uniform_scale: float) -> void:
	volume = base_volume * uniform_scale
	scale = Vector3(uniform_scale, uniform_scale, uniform_scale)

func on_area_entered_event(body: Node3D) -> void:
	if body.is_in_group("Player"):
		# Damage reduction at the start of the game, to prevent frustrating early deaths
		var elapsed_seconds: float = GameManager.elapsed_time_msec() / 1000.0;
		var damage_modifier = 1.0
		if elapsed_seconds < 15:
			damage_modifier = 0.1 + (0.06 * elapsed_seconds)
		var snowball: SnowballController = body as SnowballController
		snowball.hit(damage_modifier * volume * pow(snowball.linear_velocity.length(), 1.4) * 0.03)
		var reverse_factor = 0.1 * snowball.linear_velocity.length()
		snowball.apply_impulse(volume * reverse_factor * -snowball.linear_velocity)
		queue_free()
