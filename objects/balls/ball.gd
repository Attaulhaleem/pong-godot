class_name Ball
extends RigidBody2D

const INITIAL_WAIT_TIME: float = 1.0
const INITIAL_LINEAR_SPEED: Vector2 = Vector2(128.0, 0.0)
const INITIAL_ANGULAR_SPEED: float = 0.5 * TAU

@export_group("Nodes")
@export var last_hit_timer: Timer

@export_group("Movement Settings")
@export var last_hit_player: Global.GamePlayer
@export var movement_speed: float = 256.0

var reset_state = false
var movement_vector: Vector2
var starting_position: Vector2


func _ready() -> void:
	starting_position = position
	Global.mode_selected.connect(on_mode_selected)
	last_hit_timer.timeout.connect(on_last_hit_timer_timeout)
	reset(INITIAL_WAIT_TIME)


func _integrate_forces(state):
	if reset_state:
		state.transform = Transform2D(0.0, movement_vector)
		reset_state = false


func move_body(target_position: Vector2):
	movement_vector = target_position
	reset_state = true


func on_mode_selected(_mode: Global.GameMode) -> void:
	reset(float(Global.COUNTDOWN_TIME))


func on_last_hit_timer_timeout() -> void:
	reset(INITIAL_WAIT_TIME)


func _on_body_shape_entered(_body_rid: RID, body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Paddle:
		last_hit_player = body.player
		last_hit_timer.start()


func reset(freeze_time: float) -> void:
	stop_moving()
	move_body(starting_position)
	await get_tree().create_timer(freeze_time).timeout
	start_moving()


func stop_moving() -> void:
	linear_velocity = Vector2.ZERO
	angular_velocity = 0.0


func start_moving() -> void:
	var initial_direction: int = -1 if randf() < 0.5 else 1
	linear_velocity = initial_direction * INITIAL_LINEAR_SPEED
	angular_velocity = INITIAL_ANGULAR_SPEED


func on_item_picked_up(item: Item) -> void:
	Global.powerup_collected.emit(last_hit_player, item)
