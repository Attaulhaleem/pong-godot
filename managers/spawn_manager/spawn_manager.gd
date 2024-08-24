extends Node

@export_group("Nodes")
@export var spawnling: PackedScene
@export var spawn_position: Vector2

var spawned_node: Node


func _ready() -> void:
	spawned_node = spawn()


func spawn() -> Node:
	var node: Node = spawnling.instantiate()
	node.position = spawn_position
	call_deferred("add_child", node)
	return node
