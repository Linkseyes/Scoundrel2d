# Calls of the Button that 
class_name RerollButton
extends Button

## The manager of the room
@export var manager: RoomManager
@export var action_cooldown: int

var cooldown_counter: int = 0

func _on_pressed() -> void:
	if cooldown_counter <= 0:
		manager.refresh_room()
		cooldown_counter = action_cooldown
		disabled = true

func decrease_cooldown():
	cooldown_counter -= 1
	if cooldown_counter <= 0:
		disabled = false
