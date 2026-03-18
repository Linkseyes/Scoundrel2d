# Main class for the Main Scene
extends Node

@export var player_scene: PackedScene
var current_player: Player

# Method to star the game
func new_game():
	# Clear old game
	remove_child(current_player)
	get_tree().call_group("Cards", "queue_free")
	await get_tree().create_timer(0.01).timeout
	
	$HUD.update_score(0)
	$HUD.show_message("")
	
	# Starts new game
	# Starts the Deck
	$RoomManager/Deck.start($DeckPosition.position)
	# Generates a new room throught the Room Manager
	$RoomManager.generate_new_room()
	# Starts Player
	current_player = player_scene.instantiate()
	current_player.ready_player($PlayerPosition.position)
	add_child(current_player)
	

func game_over():
	$HUD.show_game_over()
