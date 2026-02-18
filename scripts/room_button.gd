# Calls of the Button that 
class_name RoomButton
extends Button

# The manager of the room
@export var manager: RoomManager
# Refresents if the player has completed the current Room
var room_completed: bool
# Refresents if the player can refresh the room
var can_refresh: bool

# The acts that this button can do
enum Action {
	REFRESH_ROOM,
	NEXT_ROOM
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_completed = false
	can_refresh = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !room_completed and !can_refresh:
		disabled = true 
	else:
		disabled = false

func _on_pressed() -> void:
	if room_completed:
		set_button_as(Action.NEXT_ROOM)
		manager.generate_new_room()
	elif can_refresh:
		manager.refresh_room()

# Changes the action of the button when pressed
func set_button_as(action: Action):
	if action == Action.REFRESH_ROOM:
		room_completed = false
		can_refresh = true
		text = "Refresh"
	elif action == Action.NEXT_ROOM:
		room_completed = true
		can_refresh = false
		text = "Next"

func disable():
	room_completed = false
	can_refresh = false
