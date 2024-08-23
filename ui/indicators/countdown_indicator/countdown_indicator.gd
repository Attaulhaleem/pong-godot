class_name CountdownIndicator
extends Control

signal countdown_started
signal countdown_finished

@export var countdown_label: Label
@export var countdown_timer: Timer

var countdown: int = 3

func _ready() -> void:
	Global.mode_selected.connect(on_mode_selected)
	countdown_timer.timeout.connect(on_countdown_timer_timeout)
	countdown_timer.one_shot = true
	countdown_label.text = ""
	visible = false


func on_countdown_timer_timeout() -> void:
	countdown -= 1
	countdown_label.text = str(countdown)
	if countdown <= 0:
		countdown_label.text = ""
		countdown_finished.emit()
	else:
		countdown_timer.start()


func on_mode_selected(mode: Global.GameMode) -> void:
	countdown_label.text = str(countdown)
	set_deferred("visible", true)
	countdown_timer.start()
	countdown_started.emit()
	countdown_finished.connect(
		func(): 
			Global.game_started.emit(mode)
			set_deferred("visible", false)
	)
