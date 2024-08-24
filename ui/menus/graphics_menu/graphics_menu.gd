class_name GraphicsMenu
extends Menu

@export_group("Nodes")
@export var show_net_checkbutton: CheckButton
@export var background_color_picker_button: ColorPickerButton
@export var foreground_color_picker_button: ColorPickerButton
@export var return_button: Button

@export_group("Menus")
@export var return_menu: Menu


func _ready() -> void:
	return_button.pressed.connect(func(): menu_changed.emit(self, return_menu))
