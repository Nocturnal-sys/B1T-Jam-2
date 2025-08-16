extends AnimatedSprite2D

@onready var timer: Timer = $Timer

var tick: int  = 0
var tick_time: int = 10

func _ready() -> void:
	timer.start(tick_time)


func _on_timer_timeout() -> void:
	var anim_name: String = "die_"
	tick += 1
	anim_name += str(tick)
	play(anim_name)
	if tick >= 7:
		SceneManager.game_over()
		return
	timer.start()
