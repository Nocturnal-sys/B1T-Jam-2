extends HSlider

@onready var label: Label = $Value
@onready var mute: CheckButton = $Mute

@export
var bus_name: String
var bus_index: int


func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
	mute.button_pressed = AudioServer.is_bus_mute(AudioServer.get_bus_index(bus_name))


func _process(delta: float) -> void:
	label.text = str(int(value*100))


func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(bus_index, not AudioServer.is_bus_mute(bus_index))
