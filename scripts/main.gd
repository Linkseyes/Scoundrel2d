# Main class for the Main Scene
extends Node

# Method to star the game
func new_game():
	# Clear old game
	get_tree().call_group("Cards", "queue_free")
	await get_tree().create_timer(0.01).timeout
	
	$HUD.update_score(0)
	$HUD.show_message("")
	
	# Starts the Deck
	$RoomManager/Deck.start($DeckPosition.position)
	# Generates a new room throught the Room Manager
	$RoomManager.generate_new_room()
	# Starts Player
	$Player.ready_player()

func game_over():
	$HUD.show_game_over()
