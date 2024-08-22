class_name SoundMenu
extends Menu

@export var music_slider: HSlider
@export var sfx_slider: HSlider
@export var return_button: Button

@export var return_menu: Menu


func _ready() -> void:
	return_button.pressed.connect(func(): menu_changed.emit(self, return_menu))
