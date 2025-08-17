extends Node
var score: int

func game_over():
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")


func start_game():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")


func main_menu():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func rules():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func options():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
