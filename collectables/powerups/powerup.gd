class_name Powerup
extends Node2D

@export_group("Nodes")
@export var powerup_sprite: Sprite2D

@export_group("Settings")
@export var collectable: Collectable


func _ready() -> void:
	if powerup_sprite:
		powerup_sprite.texture = collectable.texture


func _on_area_2d_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Ball:
		queue_free()
