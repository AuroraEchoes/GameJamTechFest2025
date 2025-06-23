extends MeshInstance3D

@export var decimal_loss_rate: float = 1.2
@onready var area: Area3D = $"Area3D"
var player: SnowballController = null
var time_since_last_hit: float = 0.5

func _ready() -> void:
	area.body_entered.connect(on_body_entered)
	area.body_exited.connect(on_body_exited)

func _process(delta: float) -> void:
	# HACK: Only hit the player every .5 seconds, otherwise just reduce volume
	# because im too stupid for life
	if player != null:
		time_since_last_hit += delta
		var delta_volume = decimal_loss_rate * player.get_volume() * delta
		if time_since_last_hit >= 0.25:
			player.hit(delta_volume)
			time_since_last_hit = 0.0
		else:
			player.add_volume(-delta_volume)

func on_body_entered(node: Node3D) -> void:
	if node.is_in_group("Player"):
		player = node as SnowballController

func on_body_exited(node: Node3D) -> void:
	if node.is_in_group("Player"):
		player = null
