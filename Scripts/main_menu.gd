extends CanvasLayer


func _on_play_button_pressed() -> void:
	SceneManager.start_game()


func _on_options_button_pressed() -> void:
	SceneManager.options()


func _on_rules_button_pressed() -> void:
	SceneManager.rules()
