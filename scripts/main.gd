extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_game():
	$RoomManager/Deck.start($DeckPosition.position)
	$RoomManager.generate_new_room()


func _on_button_pressed() -> void:
	pass # Replace with function body.
