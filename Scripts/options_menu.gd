extends CanvasLayer


func _on_menu_button_pressed() -> void:
	AudioManager.play_select()
	SceneManager.main_menu()


func _on_menu_button_mouse_entered() -> void:
	AudioManager.play_hover()


func _on_main_slider_mouse_entered() -> void:
	AudioManager.play_hover()


func _on_music_slider_mouse_entered() -> void:
	AudioManager.play_hover()


func _on_sfx_slider_mouse_entered() -> void:
	AudioManager.play_hover()
