# Main class for the Main Scene
extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Method to star the game
func new_game():
	# Starts the Deck
	$RoomManager/Deck.start($DeckPosition.position)
	# Generates a new room throught the Room Manager
	$RoomManager.generate_new_room()
