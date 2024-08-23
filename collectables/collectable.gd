class_name Collectable
extends Node2D

@export var collectable_sprite: Sprite2D
@export var collectable_texture: CompressedTexture2D


func _ready() -> void:
	if collectable_texture:
		collectable_sprite.texture = collectable_texture
