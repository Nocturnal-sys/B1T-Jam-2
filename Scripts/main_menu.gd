extends CanvasLayer


func _on_play_button_pressed() -> void:
	AudioManager.play_select()
	SceneManager.start_game()


func _on_options_button_pressed() -> void:
	AudioManager.play_select()
	SceneManager.options()


func _on_rules_button_pressed() -> void:
	AudioManager.play_select()
	SceneManager.rules()


func _on_play_button_mouse_entered() -> void:
	AudioManager.play_hover()


func _on_options_button_mouse_entered() -> void:
	AudioManager.play_hover()


func _on_rules_button_mouse_entered() -> void:
	AudioManager.play_hover()
