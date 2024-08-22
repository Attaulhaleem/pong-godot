class_name ModeMenu
extends Menu

@export var ai_mode_button: Button
@export var mirror_mode_button: Button
@export var versus_mode_button: Button
@export var return_button: Button

@export var return_menu: Menu


func _ready() -> void:
	ai_mode_button.pressed.connect(func(): start_game(Global.GameMode.AI))
	mirror_mode_button.pressed.connect(func(): start_game(Global.GameMode.MIRROR))
	versus_mode_button.pressed.connect(func(): start_game(Global.GameMode.VERSUS))
	return_button.pressed.connect(func(): menu_changed.emit(self, return_menu))


func start_game(mode: Global.GameMode):
	menu_changed.emit(self, null)
	Global.game_started.emit(mode)
