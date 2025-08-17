extends CanvasLayer
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var score_label: Label = $ScoreLabel


func _ready() -> void:
	animation.play("move_lotus")
	score_label.text += str(SceneManager.score)


func _on_menu_button_pressed() -> void:
	SceneManager.main_menu()
