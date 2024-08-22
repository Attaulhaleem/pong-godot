extends StaticBody2D

enum WallDirection {
	TOP = 1,
	BOTTOM = -1,
}

@export var linear_speed: Vector2 = Vector2(0.0, 128.0)
@export var wall_direction: WallDirection = WallDirection.TOP


func _ready() -> void:
	constant_linear_velocity = wall_direction * linear_speed
