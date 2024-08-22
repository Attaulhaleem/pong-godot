class_name MenuManager
extends CanvasLayer

@export var main_menu: MainMenu
@export var mode_menu: ModeMenu
@export var sound_menu: SoundMenu
@export var graphics_menu: GraphicsMenu


func _ready() -> void:
	main_menu.play_menu = mode_menu
	main_menu.sound_menu = sound_menu
	main_menu.graphics_menu = graphics_menu
	mode_menu.return_menu = main_menu
	sound_menu.return_menu = main_menu
	graphics_menu.return_menu = main_menu
	main_menu.menu_changed.connect(func(from, to): change_menu(from, to))
	mode_menu.menu_changed.connect(func(from, to): change_menu(from, to))
	sound_menu.menu_changed.connect(func(from, to): change_menu(from, to))
	graphics_menu.menu_changed.connect(func(from, to): change_menu(from, to))


func change_menu(from: Menu, to: Menu) -> void:
	if from:
		from.hide()
	if to:
		to.show()
