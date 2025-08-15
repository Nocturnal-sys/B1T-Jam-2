extends Node2D

@onready var grid: Node2D = $SeedGrid

var seed_size: int = 32
var grid_width: int = 8
var grid_height: int = 8
var grid_pos: Vector2 = Vector2(128, 64)

var current_seeds: Array = []

var seed_options: Array[PackedScene] = [
	preload("res://Scenes/Seeds/cactus.tscn"),
	preload("res://Scenes/Seeds/daisy.tscn"),
	preload("res://Scenes/Seeds/grass.tscn"),
	preload("res://Scenes/Seeds/rose.tscn")
]


func _ready() -> void:
	populate_grid(grid_width, grid_height)


func create_seed_array(width, height):
	pass


func populate_grid(width, height):
	for i in width:
		for j in height:
			var seed_index = randi_range(0, seed_options.size() - 1)
			var seed = seed_options[seed_index].instantiate()
			grid.add_child(seed)
			seed.position = Vector2(i * seed_size, j * seed_size)
	pass;


func _check_for_match(postition: Vector2) -> bool:
	return false


func _remove_seed(position: Vector2) -> void:
	pass


func _swap_seed(pos1: Vector2, pos2: Vector2) -> bool:
	return false
