extends Node
var score: int

func game_over():
	AudioManager.play_game_over()
	AudioManager.stop_main_music()
	AudioManager.play_menu_music()
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")


func start_game():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
	AudioManager.stop_menu_music()
	AudioManager.play_main_music()


func main_menu():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	AudioManager.stop_main_music()
	if not AudioManager.menu.playing:
		AudioManager.play_menu_music()


func rules():
	get_tree().change_scene_to_file("res://Scenes/rules_screen.tscn")


func options():
	pass
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")
