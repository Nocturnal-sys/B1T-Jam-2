extends Node2D

@onready var grid: Node2D = $SeedGrid
@onready var score_value: Label = $MarginContainer/ScoreValue
@onready var path: PathFollow2D = $Path2D/PathFollow2D

var seed_size: int = 32
var grid_width: int = 8
var grid_height: int = 8
var grid_pos: Vector2 = Vector2(128, 64)

var current_seeds: Array = []
var selected_seed: Seed
var allowed_swaps: Array[Seed]
var swap_seed: Seed

var matched_seeds: Array[Seed]
var score = 0

var swap_tween: Tween
var selected_tween: Tween

var seed_options: Array[PackedScene] = [
	preload("res://Scenes/Seeds/cactus.tscn"),
	preload("res://Scenes/Seeds/daisy.tscn"),
	preload("res://Scenes/Seeds/grass.tscn"),
	preload("res://Scenes/Seeds/rose.tscn"), 
	preload("res://Scenes/Seeds/sun_flower.tscn"),
	preload("res://Scenes/Seeds/sweet_pea.tscn"),
	preload("res://Scenes/Seeds/tulip.tscn")
]


func _ready() -> void:
	current_seeds = create_seed_array(grid_width, grid_height)
	populate_grid(grid_width, grid_height)
	score_value.text = "00000"


func _process(_delta: float) -> void:
	path.progress_ratio += 0.01
	score_value.text = _create_score_text()


func _create_score_text() -> String:
	var string_score = str(score)
	match len(string_score):
		1:
			return "0000" + string_score
		2:
			return "000" + string_score
		3:
			return "00" + string_score
		4:
			return "0" + string_score
		_:
			return string_score


func create_seed_array(width, height) -> Array:
	var new_array: Array = []
	for i in width:
		new_array.append([])
		for j in height:
			new_array[i].append(null)
	return new_array


func populate_grid(width, height):
	for i in height:
		for j in width:
			var seed_index: int = randi_range(0, seed_options.size() - 1)
			var matching: bool = true
			while matching == true:
				matching = _check_for_initial_match(j, i, seed_index)
				if matching:
					seed_index = randi_range(0, seed_options.size() - 1)
			_add_seed(Vector2(j, i), seed_index)
	print_seed_array()


func _generate_random_seed() -> Seed:
	return seed_options[randf_range(0, seed_options.size()-1)].instantiate()


func _add_seed(pos: Vector2, seed_index: int) -> void:
	var new_seed: Seed = seed_options[seed_index].instantiate()
	grid.add_child(new_seed)
	new_seed.selected.connect(seed_selected)
	current_seeds[pos.y][pos.x] = new_seed.plant_type
	new_seed.position = Vector2(pos.x * seed_size, pos.y * seed_size)


func _check_for_initial_match(column, row, seed_index) -> bool:
	if column < 2 and row < 2:
		return false
	if _check_left(column, row, seed_index):
		return true
	else:
		return _check_up(column, row, seed_index)


func _check_left(column, row, seed_index) -> bool:
	if column < 2:
		return false
	if current_seeds[row][column - 1] != null and current_seeds[row][column - 2] != null:
		if current_seeds[row][column-1] == seed_index and current_seeds[row][column-2] == seed_index:
			return true
	return false


func _check_up(column, row, seed_index) -> bool:
	if row < 2:
		return false
	if current_seeds[row - 1][column] != null and current_seeds[row - 2][column] != null:
		if current_seeds[row - 1][column] == seed_index and current_seeds[row - 2][column] == seed_index:
			return true
	return false


func _replace_seed(plant: Seed) -> void:
	var plant_pos = plant.position
	await plant.remove_me
	grid.remove_child(plant)
	plant.queue_free()
	var new_plant = _generate_random_seed()
	new_plant.selected.connect(seed_selected)
	grid.add_child(new_plant)
	new_plant.position = plant_pos
	if is_matching(new_plant):
		for matched in matched_seeds:
			matched.germinate()


func print_seed_array():
	for i in current_seeds.size():
		print(current_seeds[i])


func seed_selected(this_seed: Seed, adjacent: Array[Seed]):
	if not selected_seed or this_seed not in allowed_swaps:
		for allowed in allowed_swaps:
			allowed.toggle_highlight()
		selected_seed = this_seed
		allowed_swaps = adjacent
		for allowed in allowed_swaps:
			allowed.toggle_highlight()
	elif this_seed == selected_seed:
		for allowed in allowed_swaps:
			allowed.toggle_highlight()
	else:
		swap_seed = this_seed
		await swap_seeds()
		selected_seed.just_swapped()
		var selected_matching = is_matching(selected_seed)
		var swap_matching = is_matching(swap_seed)
		if not selected_matching and not swap_matching:
			swap_seeds()
			swap_seed.just_swapped()
			selected_seed.just_swapped()
			swap_seed = null
		else:
			for matched in matched_seeds:
				is_matching(matched)
				matched.germinate()


func swap_seeds() -> void:
	var pos1: Vector2 = selected_seed.position
	var pos2: Vector2 = swap_seed.position
	
	for allowed in allowed_swaps:
		allowed.toggle_highlight()
	
	if swap_tween:
		swap_tween.kill()
	
	if selected_tween:
		selected_tween.kill()
	
	swap_tween = create_tween()
	swap_tween.tween_property(swap_seed, "position", pos1, 0.2)
	selected_tween = create_tween()
	selected_tween.tween_property(selected_seed, "position", pos2, 0.2)
	await selected_tween.finished
	allowed_swaps = []


func is_matching(check_seed: Seed) -> bool:
	var up_matches = get_matching_direction(check_seed, "up")
	var down_matches = get_matching_direction(check_seed, "down")
	var left_matches = get_matching_direction(check_seed, "left")
	var right_matches = get_matching_direction(check_seed, "right")
	var vertical_matches = up_matches + down_matches
	var horizontal_matches = left_matches + right_matches
	var has_matches = false
	if len(vertical_matches) > 2:
		has_matches = true
		for seed_match in vertical_matches:
			if seed_match not in matched_seeds:
				matched_seeds.append(seed_match)

	if len(horizontal_matches) > 2:
		has_matches = true
		for seed_match in horizontal_matches:
			if seed_match not in matched_seeds:
				matched_seeds.append(seed_match)

	print(matched_seeds)
	print(has_matches)
	return has_matches


func get_matching_direction(check_seed: Seed, direction: String) -> Array[Seed]:
	var matches: Array[Seed] = []
	var current = check_seed
	matches.append(current)
	current = current.get_matching(direction)
	while current != null:
		matches.append(current)
		current = current.get_matching(direction)
	if len(matches) > 1:
		return matches
	return []


func _bloom_seeds():
	for grown in matched_seeds:
		grown.bloom()


func _on_lotus_bloom() -> void:
	_bloom_seeds()
	for flower in matched_seeds:
		_replace_seed(flower)
	matched_seeds = []
