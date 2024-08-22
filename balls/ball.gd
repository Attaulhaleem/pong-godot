class_name Ball
extends RigidBody2D

signal respawn_needed

const INITIAL_WAIT_TIME: float = 2.0
const INITIAL_LINEAR_SPEED: Vector2 = Vector2(128.0, 0.0)
const INITIAL_ANGULAR_SPEED: float = 0.5 * TAU

@export var movement_speed: float = 256.0
@export var idle_timer: Timer


func _ready() -> void:
	await get_tree().create_timer(INITIAL_WAIT_TIME).timeout
	var initial_direction: int = -1 if randf() < 0.5 else 1
	linear_velocity = initial_direction * INITIAL_LINEAR_SPEED
	angular_velocity = INITIAL_ANGULAR_SPEED
	idle_timer.timeout.connect(on_idle_timer_timeout)


func on_idle_timer_timeout() -> void:
	respawn_needed.emit()


func _on_body_shape_entered(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Paddle:
		idle_timer.start()
