class_name Lotus
extends AnimatedSprite2D

@onready var timer: Timer = $Timer

var tick: int  = 0
var tick_time: float

const DEFAULT_TICK: float = 8

signal bloom()

func _ready() -> void:
	tick_time = DEFAULT_TICK
	timer.start(tick_time)


func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	var anim_name: String = "die_"
	tick += 1
	anim_name += str(tick)
	play(anim_name, 0.5)
	if tick >= 7:
		SceneManager.game_over()
		return
	timer.start(tick_time)


func decrease_tick_time(num: float) -> void:
	if tick_time > 1:
		tick_time -= num


func reset_tick_time() -> void:
	tick_time = DEFAULT_TICK
	timer.start(tick_time)


func heal(num: int) -> void:
	timer.stop()
	var anim_name: String
	var start_frame = tick
	if num > tick:
		num = start_frame
	for i in num:
		anim_name = "die_" + str(start_frame-i)
		play_backwards(anim_name)
		await animation_finished
	tick = tick-num
	timer.start(tick_time)


func _on_texture_button_pressed() -> void:
	bloom.emit()
