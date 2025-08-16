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
	preload("res://Scenes/Seeds/rose.tscn"), 
	#sunflower goes here
	preload("res://Scenes/Seeds/sweet_pea.tscn"),
	preload("res://Scenes/Seeds/tulip.tscn")
]


func _ready() -> void:
	current_seeds = create_seed_array(grid_width, grid_height)
	populate_grid(grid_width, grid_height)


func create_seed_array(width, height) -> Array:
	var new_array: Array = []
	for i in width:
		new_array.append([])
		for j in height:
			new_array[i].append(null)
	return new_array


func populate_grid(width, height):
	for i in width:
		for j in height:
			var seed_index = randi_range(0, seed_options.size() - 1)
			if _check_for_match(Vector2(i,j), seed_index):
				continue
			else:
				_add_seed(Vector2(i, j), seed_index)
	print(current_seeds)


func _add_seed(position: Vector2, seed_index: int) -> void:
	var seed: Seed = seed_options[seed_index].instantiate()
	grid.add_child(seed)
	current_seeds[position.x][position.y] = seed.plant_type
	seed.position = Vector2(position.x * seed_size, position.y * seed_size)


func _check_for_match(position: Vector2, seed_index) -> bool:
	return false


func _remove_seed(position: Vector2) -> void:
	pass


func _swap_seed(pos1: Vector2, pos2: Vector2) -> bool:
	return false
