class_name RoomManager
extends Node

@onready var button: RoomButton = $Button
@onready var current_room: Node = $CurrentRoom
@onready var card_positions: Node = $CardPositions
@onready var deck: PlayingDeck = $Deck
@onready var discard_pile: Node = $DiscardPile
@onready var discard_pile_pos: Marker2D = $DiscardPile/DiscardPilePosition


signal player_took_damage(card: PlayingCard)
signal player_healed(card: PlayingCard)
signal player_added_armor(card: PlayingCard)

@export var room_size: int
@export var card_scene: PackedScene
# The top card of the discard pile
var current_discard: PlayingCard
var refresh_counter: int 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.disable()
	refresh_counter = 0

func generate_new_room():
	if refresh_counter <= 0:
		button.set_button_as(RoomButton.Action.REFRESH_ROOM)
	else: button.disable()
	var spaw_points = card_positions.get_children()
	
	var n_old_cards = 0
	if current_room.get_child_count() > 0:
		for card in current_room.get_children():
			card.position = spaw_points.get(n_old_cards).position
			n_old_cards += 1
	
	var cards: Array[Card] = deck.get_top_n_cards(room_size-n_old_cards)
	print(cards)
	
	for i in range(cards.size()):
		var new_card = card_scene.instantiate()
		current_room.add_child(new_card)
		new_card.start(spaw_points.get(n_old_cards + i).position, cards.get(i), self)
		new_card.add_to_group("Cards")
	
	refresh_counter -= 1
	print(deck.playing_deck.deck.size())

func use_card(card: PlayingCard):
	button.disable()
	current_room.remove_child(card)
	
	if card.card.suit == Card.Suits.CLUBS or card.card.suit == Card.Suits.SPADES:
		emit_signal("player_took_damage", card)
		
	elif card.card.suit == Card.Suits.HEARTS:
		emit_signal("player_healed", card)
		
	elif card.card.suit == Card.Suits.DIAMONDS:
		emit_signal("player_added_armor", card)
	
	if needs_new_room():
		generate_new_room()
	elif current_room.get_child_count() == 1:
		button.set_button_as(RoomButton.Action.NEXT_ROOM) 

func needs_new_room() -> bool:
	return current_room.get_child_count() == 0 

func refresh_room():
	refresh_counter = 1
	button.disable()
	var array: Array[Card] = []
	for card in current_room.get_children():
		array.append(card.card)
		current_room.remove_child(card)
	deck.add_cards_to_deck(array)
	generate_new_room()

# Method that moves a card to the discard pile
# Since, acording to the rules of the game, the players doesn't need to check the
# discarding pile, this method deletes the old card and replaces it with the new one
# The card in the discard pile is a child of Player so it can be rendered
func discard_card(card: PlayingCard):
	# Return if the card is null
	if card == null: return
	# Removes the current card in the discard pile
	discard_pile.remove_child(current_discard)
	# Adds the new card and moves it to position
	discard_pile.add_child(card)
	current_discard = card
	card.position = discard_pile_pos.position
	card.scale = Vector2(2,2)
