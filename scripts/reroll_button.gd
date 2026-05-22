# Calls of the Button that 
class_name RerollButton
extends Button

## The manager of the room
@export var action_cooldown: int

var cooldown_counter: int = 0
var active: bool

signal reroll_button_pressed

func _ready() -> void:
	active = true

func _on_pressed() -> void:
	if cooldown_counter <= 0 and active:
		emit_signal("reroll_button_pressed")
		cooldown_counter = action_cooldown
		disabled = true

func decrease_cooldown():
	cooldown_counter -= 1
	if cooldown_counter <= 0:
		disabled = false

func activate():
	active = true

func deactivate():
	active = false
