extends Sprite2D


func _ready() -> void:
	set_deferred("visible", false)
	Global.mode_selected.connect(func(_mode): set_deferred("visible", true))
