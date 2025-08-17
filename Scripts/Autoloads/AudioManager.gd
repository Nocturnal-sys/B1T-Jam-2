extends Node

@onready var score: AudioStreamPlayer = $Score
@onready var firework: AudioStreamPlayer = $Firework
@onready var main: AudioStreamPlayer = $Main
@onready var grow: AudioStreamPlayer = $Grow
@onready var menu: AudioStreamPlayer = $Menu
@onready var hover: AudioStreamPlayer = $Hover
@onready var select: AudioStreamPlayer = $Select
@onready var game_over: AudioStreamPlayer = $GameOver

var fade_in_tween: Tween
var fade_out_tween: Tween

var main_muted: bool
var music_muted: bool
var sfx_muted: bool


func _ready() -> void:
	play_menu_music()


func play_score():
	score.play()


func stop_score():
	score.stop()


func play_firework():
	firework.play()


func play_grow():
	if grow.playing:
		grow.volume_db = linear_to_db(1)
	grow.play()
	if fade_out_tween:
		fade_out_tween.kill()
	fade_out_tween = create_tween()
	fade_out_tween.tween_property(grow,"volume_db", linear_to_db(0.01),2.5)
	await fade_out_tween.finished
	grow.stop()
	grow.volume_db = linear_to_db(1)


func play_hover():
	hover.play()


func play_select():
	select.play()


func play_game_over():
	game_over.play()


func play_main_music():
	main.volume_db = linear_to_db(0.01)
	main.play()
	if fade_in_tween:
		fade_in_tween.kill()
	fade_in_tween = create_tween()
	fade_in_tween.tween_property(main,"volume_db",linear_to_db(0.6),1.4)


func stop_main_music():
	if fade_out_tween:
		fade_out_tween.kill()
	fade_out_tween = create_tween()
	fade_out_tween.tween_property(main, "volume_db", linear_to_db(0.01), 1)
	await fade_out_tween.finished
	main.stop()


func play_menu_music():
	menu.volume_db = linear_to_db(0.01)
	menu.play()
	if fade_in_tween:
		fade_in_tween.kill()
	fade_in_tween = create_tween()
	fade_in_tween.tween_property(menu,"volume_db", linear_to_db(0.5), 1)


func stop_menu_music():
	if fade_out_tween:
		fade_out_tween.kill()
	fade_out_tween = create_tween()
	fade_out_tween.tween_property(menu, "volume_db", linear_to_db(0.01), 1)
	await fade_out_tween.finished
	menu.stop()
