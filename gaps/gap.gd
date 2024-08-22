@tool
extends Area2D

enum GapDirection {LEFT, RIGHT}

@export var gap_direction: GapDirection = GapDirection.LEFT


func _ready() -> void:
	match gap_direction:
		GapDirection.LEFT:
			rotation_degrees = 90.0
		GapDirection.RIGHT:
			rotation_degrees = -90.0
		_:
			print_debug("Undefined direction set for Danger Zone")


func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Ball:
		body.respawn_needed.emit()
