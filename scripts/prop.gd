extends Node3D

@onready var area: Area3D = $"Area3D"
@export var base_volume: float = 10.0
# TODO: this is bad. turn the TerrainObstacle resource into this class and only take that in TerrainChunk
# then calll a set scale and dont get it by this hacky way
@onready var volume: float = base_volume * scale.x

func _ready() -> void:
	area.body_entered.connect(on_area_entered_event)

func on_area_entered_event(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var snowball: SnowballController = body as SnowballController
		snowball.add_volume(-volume)
