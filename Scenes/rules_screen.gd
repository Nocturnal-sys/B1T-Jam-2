extends CanvasLayer

var v : VScrollBar
@onready var scroll_container: ScrollContainer = $ScrollContainer
@onready var rules_text: RichTextLabel = $ScrollContainer/RulesText


func _ready() -> void:
	var flat_style = StyleBoxFlat.new()
	flat_style.bg_color = Color(1,1,1)
	v = rules_text.get_v_scroll_bar()
	v.add_theme_stylebox_override("grabber", flat_style)
	v.add_theme_stylebox_override("grabber_highlight", flat_style)
	v.add_theme_stylebox_override("grabber_pressed", flat_style)


func _on_menu_button_pressed() -> void:
	SceneManager.main_menu()
