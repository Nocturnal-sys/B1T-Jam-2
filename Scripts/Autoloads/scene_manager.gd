extends Node
const GAME_OVER = preload("res://Scenes/game_over.tscn")
var score: int

func game_over():
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
