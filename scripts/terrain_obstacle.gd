extends Resource
class_name TerrainObstacle

@export var probability_weight: int = 3
@export var base_volume: float = 1.0
@export var scene: PackedScene
# Many trees, some dead trees/stumps, few rocks
@export var forest_probability: int
# Many dead trees/stumps, some rocks, few trees
@export var dead_forest_probability: int
# Many snowmen, few snow cannons, flags and fences
@export var snowman_haven_probability: int
# Many flags and fences, some snow cannons
@export var skiing_race_probability: int
# Many rocks, some flags and fences, some dead trees
@export var rocky_outcrops_probability: int
# Many trash
@export var trashyard_probability: int

func biome_weight(biome: HillManager.Biome):
	match biome:
		HillManager.Biome.FOREST:
			return forest_probability
		HillManager.Biome.DEAD_FOREST:
			return dead_forest_probability
		HillManager.Biome.SNOWMAN_HAVEN:
			return snowman_haven_probability
		HillManager.Biome.SKIING_RACE:
			return skiing_race_probability
		HillManager.Biome.ROCKY_OUTCROPS:
			return rocky_outcrops_probability
		HillManager.Biome.TRASHYARD:
			return trashyard_probability
