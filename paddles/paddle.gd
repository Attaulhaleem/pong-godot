class_name Paddle
extends AnimatableBody2D

enum PaddlePosition {LEFT, RIGHT}

@export var paddle_position: PaddlePosition = PaddlePosition.LEFT
@export var max_speed: float = 2.0
@export var acceleration: float = 512.0
@export var deceleration_weight: float = 0.9
@export var linear_speed: Vector2 = Vector2(256.0, 0.0)
@export var ai_controller: bool = false
@export var ai_vision_distance: float = 60.0

var velocity: Vector2 = Vector2.ZERO
var starting_position: Vector2
var input_enabled: bool = false

func _ready() -> void:
	match paddle_position:
		PaddlePosition.LEFT:
			rotation_degrees = 90.0
			constant_linear_velocity = linear_speed
		PaddlePosition.RIGHT:
			rotation_degrees = -90.0
			constant_linear_velocity = -linear_speed
		_:
			print_debug("Undefined paddle position!")
	starting_position = position
	Global.game_started.connect(on_game_started)


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
		if input_enabled:
			direction = Input.get_axis("move_up", "move_down")
	# No input, stop moving
	if absf(direction) < 0.01:
		velocity.y = lerp(velocity.y, 0.0, deceleration_weight)
	# Input, move
	else:
		velocity.y += direction * acceleration * delta
		velocity.y = clamp(velocity.y, -max_speed, max_speed)
	move_and_collide(velocity)


func on_game_started(_mode: Global.GameMode) -> void:
	input_enabled = true
