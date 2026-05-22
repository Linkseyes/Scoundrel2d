# Main class for the Main Scene
extends Node

@onready var hud: CanvasLayer = $Start
@onready var deck: PlayingDeck = $RoomManager/Deck
@onready var room_manager: RoomManager = $RoomManager
@onready var player: Player = $Player
@onready var deck_position: Marker2D = $DeckPosition

# Method to star the game
func new_game():
	# Clear old game
	get_tree().call_group("Cards", "queue_free")
	await get_tree().create_timer(0.01).timeout
	
	hud.show_message("")
	
	# Starts the Deck
	deck.start()
	# Starts Player
	player.ready_player()
	# Generates a new room throught the Room Manager
	room_manager.start_game()
	

func on_game_lost():
	#get_tree().call_group("Cards", "deactivate_card")
	room_manager.end_game()
	hud.show_game_loss()

func on_game_won():
	room_manager.end_game()
	hud.show_game_won()
