class_name MainMenuButton
extends Button

@export var buttonText: Label
@export var pressed_color: Color
@export var shadow_color: Color 

var normal_color: Color
var settings: LabelSettings
var shadow_index : int

func _ready() -> void:
	settings = buttonText.label_settings
	normal_color = settings.font_color

func change_on_hover_enter():
	settings.add_stacked_shadow(-1)
	shadow_index = settings.stacked_shadow_count - 1
	settings.set_stacked_shadow_color(shadow_index, shadow_color)
	settings.set_stacked_shadow_offset(shadow_index, Vector2(5, 5))
	settings.set_stacked_shadow_outline_size(shadow_index, 8)

func change_on_hover_exit():
	settings.remove_stacked_shadow(shadow_index)

func change_on_press_down():
	settings.font_color = pressed_color

func change_on_press_up():
	settings.font_color = normal_color
