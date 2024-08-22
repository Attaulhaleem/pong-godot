class_name MainMenu
extends Menu

@export var play_button: Button
@export var sound_button: Button
@export var graphics_button: Button
@export var quit_button: Button

@export var play_menu: Menu
@export var sound_menu: Menu
@export var graphics_menu: Menu


func _ready() -> void:
	play_button.pressed.connect(func(): menu_changed.emit(self, play_menu))
	sound_button.pressed.connect(func(): menu_changed.emit(self, sound_menu))
	graphics_button.pressed.connect(func(): menu_changed.emit(self, graphics_menu))
	quit_button.pressed.connect(func(): get_tree().quit())
