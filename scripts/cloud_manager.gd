extends Node3D

@export var clouds: Array[PackedScene]
@export var base_cloud_move_speed: float = 5.0
@export var cloud_move_speed_variance: float = 4.0
@export var cloud_lifespan: float = 5
@export var start_area_size: Vector2 = Vector2(50, 25)

func _ready() -> void:
	while true:
		var cloud: Node3D = clouds.pick_random().instantiate()
		get_parent().get_parent().add_child(cloud)
		var initial_offset = Vector2(randf_range(0, start_area_size.x), randf_range(0, start_area_size.y)) - start_area_size / 2
		cloud.global_position = global_position + Vector3(0, initial_offset.y, initial_offset.x)
		var speed = base_cloud_move_speed + randf_range(-cloud_move_speed_variance, cloud_move_speed_variance)
		get_tree().create_tween().tween_property(cloud, "position:z", speed * cloud_lifespan, cloud_lifespan).finished.connect(func():
			cloud.queue_free()
		)
		await get_tree().create_timer(cloud_lifespan * 2 / 3).timeout
