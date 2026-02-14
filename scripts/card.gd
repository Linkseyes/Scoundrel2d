class_name Card
extends Resource

@export var value: int
@export var role: String
@export var sprite: Image

func _init(p_value = 0, p_role = "", p_sprite = null):
	value = p_value
	role = p_role
	sprite = p_sprite
