extends Area2D

@export var player: Global.GamePlayer = Global.GamePlayer.LEFT


func _ready() -> void:
	match player:
		Global.GamePlayer.LEFT:
			rotation_degrees = -90.0
		Global.GamePlayer.RIGHT:
			rotation_degrees = 90.0
		_:
			print_debug("Undefined player side!")


func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Ball and body.has_signal("respawn_needed"):
		await get_tree().create_timer(1.0).timeout
		body.respawn_needed.emit()
		Global.goal_scored.emit(player)
