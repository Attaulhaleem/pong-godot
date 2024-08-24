extends Control

@export_group("Nodes")
@export var left_score_label: Label
@export var right_score_label: Label

var left_score: int = 0:
	set(new_score):
		left_score = new_score
		left_score_label.text = str(left_score)

var right_score: int = 0:
	set(new_score):
		right_score = new_score
		right_score_label.text = str(right_score)


func _ready() -> void:
	visible = false
	Global.mode_selected.connect(on_mode_selected)
	Global.goal_scored.connect(on_goal_scored)


func on_mode_selected(_mode: Global.GameMode) -> void:
	left_score = 0
	right_score = 0
	set_deferred("visible", true)


func on_goal_scored(player: Global.GamePlayer) -> void:
	match player:
		Global.GamePlayer.LEFT:
			left_score += 1
		Global.GamePlayer.RIGHT:
			right_score += 1
		_:
			print_debug("Undefined player!")
