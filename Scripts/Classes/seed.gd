class_name Seed
extends Area2D

const SEED_BORDER_UNSELECTED = preload("res://Assets/Sprites/seed_border_unselected.png")
const SEED_BORDER_SELECTED = preload("res://Assets/Sprites/seed_border_selected.png")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var firework: GPUParticles2D = $FireWork

@onready var button: Button = $Button
@onready var up: RayCast2D = $Up
@onready var down: RayCast2D = $Down
@onready var left: RayCast2D = $Left
@onready var right: RayCast2D = $Right
@onready var up_2: RayCast2D = $Up2
@onready var down_2: RayCast2D = $Down2
@onready var left_2: RayCast2D = $Left2
@onready var right_2: RayCast2D = $Right2

@export var color: Color
@export_enum(
	"CACTUS",
	"DAISY",
	"GRASS",
	"ROSE",
	"SUNFLOWER",
	"SWEET_PEA",
	"TULIP") var plant_type

var is_highlighted = false
var grown = false
var bloomed = false

var highlight_style: StyleBoxTexture
var normal_style: StyleBoxTexture
var adjacent: Array[Seed]

signal selected(this_seed: Seed, adjacent_seeds: Array[Seed])
signal remove_me()


func _init() -> void:
	normal_style = StyleBoxTexture.new()
	normal_style.texture = SEED_BORDER_UNSELECTED
	highlight_style = StyleBoxTexture.new()
	highlight_style.texture = SEED_BORDER_SELECTED


func _ready() -> void:
	adjacent = get_adjacent()


func just_swapped() -> void:
	adjacent = get_adjacent()
	button.add_theme_stylebox_override("normal", normal_style)


func germinate() -> void:
	if not grown:
		grown = true
		sprite.play("grow")


func bloom():
	if not bloomed:
		sprite.play("bloom")
		await get_tree().create_timer(2).timeout
		sprite.hide()
		firework.restart()


func get_adjacent() -> Array[Seed]:
	var adjacent_seeds: Array[Seed] = []
	if up.is_colliding(): adjacent_seeds.append(up.get_collider())
	if down.is_colliding(): adjacent_seeds.append(down.get_collider())
	if left.is_colliding(): adjacent_seeds.append(left.get_collider())
	if right.is_colliding(): adjacent_seeds.append(right.get_collider())
	if up_2.is_colliding(): adjacent_seeds.append(up_2.get_collider())
	if down_2.is_colliding(): adjacent_seeds.append(down_2.get_collider())
	if left_2.is_colliding(): adjacent_seeds.append(left_2.get_collider())
	if right_2.is_colliding(): adjacent_seeds.append(right_2.get_collider())
	return adjacent_seeds


func toggle_highlight() -> void:
	is_highlighted = not is_highlighted
	if is_highlighted:
		button.add_theme_stylebox_override("normal", highlight_style)
	else:
		button.add_theme_stylebox_override("normal", normal_style)


func get_matching(direction: String):
	match direction:
		"up":
			if up.is_colliding() and up.get_collider().plant_type == plant_type:
				return up.get_collider()
		"down":
			if down.is_colliding() and down.get_collider().plant_type == plant_type:
				return down.get_collider()
		"left":
			if left.is_colliding() and left.get_collider().plant_type == plant_type:
				return left.get_collider()
		"right":
			if right.is_colliding() and right.get_collider().plant_type == plant_type:
				return right.get_collider()
		_:
			print(direction + " is not one of the available directions.")
			return null
	return null


func _on_button_pressed() -> void:
	if not grown:
		selected.emit(self, get_adjacent())


func _on_fire_work_finished() -> void:
	remove_me.emit()
