class_name Paddle
extends AnimatableBody2D

enum InputControls {WASD, ARROW, BOTH}
enum InputDirection {UP, DOWN}

const INPUT_ACTIONS: Dictionary = {
	InputControls.WASD: {InputDirection.UP: "wasd_move_up", InputDirection.DOWN: "wasd_move_down"},
	InputControls.ARROW: {InputDirection.UP: "arrow_move_up", InputDirection.DOWN: "arrow_move_down"},
	InputControls.BOTH: {InputDirection.UP: "both_move_up", InputDirection.DOWN: "both_move_down"},
}

@export_group("Player Settings")
@export var player: Global.GamePlayer = Global.GamePlayer.LEFT
@export var input_controls: InputControls:
	set(new_controls):
		input_controls = new_controls
		move_up_input_action = INPUT_ACTIONS[input_controls][InputDirection.UP]
		move_down_input_action = INPUT_ACTIONS[input_controls][InputDirection.DOWN]
		assert(move_up_input_action)
		assert(move_down_input_action)

@export_group("Movement Settings")
@export var max_speed: float = 2.0
@export var acceleration: float = 512.0
@export var deceleration_weight: float = 0.9
@export var linear_speed: Vector2 = Vector2(256.0, 0.0)

@export_group("AI Settings")
@export var ai_controller: bool = false
@export var ai_vision_distance: float = 60.0

var velocity: Vector2 = Vector2.ZERO
var starting_position: Vector2

var move_up_input_action: String
var move_down_input_action: String

func _ready() -> void:
	input_controls = InputControls.WASD
	match player:
		Global.GamePlayer.LEFT:
			rotation_degrees = 90.0
			constant_linear_velocity = linear_speed
		Global.GamePlayer.RIGHT:
			rotation_degrees = -90.0
			constant_linear_velocity = -linear_speed
		_:
			print_debug("Undefined player side!")
	starting_position = position
	Global.mode_selected.connect(on_mode_selected)
	Global.game_started.connect(on_game_started)
	Global.powerup_collected.connect(on_powerup_collected)


func _physics_process(delta: float) -> void:
	var direction: float = 0.0
	if ai_controller:
		var ball: Ball = get_tree().get_first_node_in_group("Balls")
		if ball:
			var difference: Vector2 = ball.global_position - self.global_position
			# Ball is within vision
			if absf(difference.x) < ai_vision_distance:
				direction = difference.normalized().y
			# Return to center
			else:
				# This one likes staying near the edges
				direction = (position - starting_position).normalized().y
				# This one likes staying near the center
				# Bug: Jitters near center position, probably due to deceleration
				#direction = (starting_position - position).normalized().y
	else:
		direction = Input.get_axis(move_up_input_action, move_down_input_action)
	# No input, stop moving
	if absf(direction) < 0.01:
		velocity.y = lerp(velocity.y, 0.0, deceleration_weight)
	# Input, move
	else:
		velocity.y += direction * acceleration * delta
		velocity.y = clamp(velocity.y, -max_speed, max_speed)
	move_and_collide(velocity)


func on_mode_selected(_mode: Global.GameMode) -> void:
	ai_controller = false
	velocity = Vector2.ZERO
	position = starting_position
	set_physics_process(false)


func on_game_started(mode: Global.GameMode) -> void:
	set_physics_process(true)
	match player:
		Global.GamePlayer.LEFT:
			match mode:
				Global.GameMode.AI:
					ai_controller = false
					input_controls = InputControls.BOTH
				Global.GameMode.MIRROR:
					ai_controller = false
					input_controls = InputControls.BOTH
				Global.GameMode.VERSUS:
					ai_controller = false
					input_controls = InputControls.WASD
				_:
					print_debug("Undefined game mode!")
		Global.GamePlayer.RIGHT:
			match mode:
				Global.GameMode.AI:
					ai_controller = true
					input_controls = InputControls.WASD
				Global.GameMode.MIRROR:
					ai_controller = false
					input_controls = InputControls.BOTH
				Global.GameMode.VERSUS:
					ai_controller = false
					input_controls = InputControls.ARROW
				_:
					print_debug("Undefined game mode!")
		_:
			print_debug("Undefined player side!")


func on_powerup_collected(collector: Global.GamePlayer, item: Item) -> void:
	if collector != player:
		return
	if item.name == "magnet":
		print("player collected magnet")
		self.modulate = Color.RED
	else:
		print(item.name)
