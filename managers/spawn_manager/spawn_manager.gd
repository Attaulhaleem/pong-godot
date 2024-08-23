extends Node

@export var spawnling: PackedScene
@export var spawn_position: Vector2

var spawned_node: Node


func _ready() -> void:
	spawned_node = spawn()


func spawn() -> Node:
	var node: Node = spawnling.instantiate()
	node.position = spawn_position
	call_deferred("add_child", node)
	if node.has_signal("respawn_needed"):
		node.respawn_needed.connect(func(): respawn())
	return node


func respawn() -> void:
	if spawned_node:
		spawned_node.queue_free()
	spawned_node = spawn()
