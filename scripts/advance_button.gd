# Calls of the Button that 
class_name AdvanceButton
extends Button

## The manager of the room
@export var manager: RoomManager

func _on_pressed() -> void:
	manager.generate_new_room()
