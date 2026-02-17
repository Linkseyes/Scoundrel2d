class_name RoomManager
extends Node

@export var room_size: int
@export var card_scene: PackedScene
@export var player: Player
var refresh_counter: int 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Button.disable()
	refresh_counter = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate_new_room():
	if refresh_counter <= 0:
		$Button.set_button_as(RoomButton.Action.REFRESH_ROOM)
	else: $Button.disable()
	var spaw_points = $CardSpawnPoints.get_children()
	
	var n_old_cards = 0
	if $CurrentRoom.get_child_count() > 0:
		for card in $CurrentRoom.get_children():
			card.position = spaw_points.get(n_old_cards).position
			n_old_cards += 1
	
	var cards: Array[Card] = $Deck.get_top_n_cards(room_size-n_old_cards)
	print(cards)
	
	for i in range(cards.size()):
		var new_card = card_scene.instantiate()
		new_card.start(spaw_points.get(n_old_cards + i).position, cards.get(i), self)
		$CurrentRoom.add_child(new_card)
	
	refresh_counter -= 1

func use_card(card: PlayingCard):
	$Button.disable()
	$CurrentRoom.remove_child(card)
	
	if card.card.suit == Card.Suits.CLUBS or card.card.suit == Card.Suits.SPADES:
		player.take_damage(card)
		
	elif card.card.suit == Card.Suits.HEARTS:
		player.heal(card)
		
	elif card.card.suit == Card.Suits.DIAMONDS:
		player.add_new_armor(card)
	
	if needs_new_room():
		generate_new_room()
	elif $CurrentRoom.get_child_count() == 1:
		$Button.set_button_as(RoomButton.Action.NEXT_ROOM) 

func needs_new_room() -> bool:
	return $CurrentRoom.get_child_count() == 0 

func refresh_room():
	refresh_counter = 1
	$Button.disable()
	var old_cards = $CurrentRoom.get_children()
	var array: Array[Card] = []
	for card in old_cards:
		array.append(card)
		$CurrentRoom.remove_child(card)
	$Deck.add_cards_to_deck(array)
	generate_new_room()
