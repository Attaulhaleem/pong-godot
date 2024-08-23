class_name Ball
extends RigidBody2D

signal respawn_needed

const INITIAL_WAIT_TIME: float = 1.0
const INITIAL_LINEAR_SPEED: Vector2 = Vector2(128.0, 0.0)
const INITIAL_ANGULAR_SPEED: float = 0.5 * TAU

@export var movement_speed: float = 256.0
# for when ball becomes too slow and gets stuck
@export var idle_timer: Timer

var reset_state = false
var movement_vector: Vector2
var starting_position: Vector2


func _ready() -> void:
	starting_position = position
	Global.mode_selected.connect(on_mode_selected)
	idle_timer.timeout.connect(on_idle_timer_timeout)
	await get_tree().create_timer(INITIAL_WAIT_TIME).timeout
	start_moving()


func _integrate_forces(state):
	if reset_state:
		state.transform = Transform2D(0.0, movement_vector)
		reset_state = false


func move_body(target_position: Vector2):
	movement_vector = target_position
	reset_state = true


func on_mode_selected(_mode: Global.GameMode) -> void:
	stop_moving()
	move_body(starting_position)
	await get_tree().create_timer(3.0).timeout
	start_moving()


func on_idle_timer_timeout() -> void:
	respawn_needed.emit()


func _on_body_shape_entered(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Paddle:
		idle_timer.start()


func stop_moving() -> void:
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0


func start_moving() -> void:
	var initial_direction: int = -1 if randf() < 0.5 else 1
	linear_velocity = initial_direction * INITIAL_LINEAR_SPEED
	angular_velocity = INITIAL_ANGULAR_SPEED
