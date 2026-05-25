class_name RoomManager
extends Node

@onready var next_button: AdvanceButton = $Next
@onready var reroll_button: RerollButton = $Reroll
@onready var current_room: Node = $CurrentRoom
@onready var card_positions: Node = $CardPositions
@onready var deck: PlayingDeck = $Deck
@onready var discard_pile: Node = $DiscardPile
@onready var discard_pile_pos: Marker2D = $DiscardPile/DiscardPilePosition
@onready var player: Player = $"../Player"


signal player_took_damage(card: PlayingCard)
signal player_healed(card: PlayingCard)
signal player_added_armor(card: PlayingCard)

@export var room_size: int
@export var card_scene: PackedScene
# The top card of the discard pile
var current_discard: PlayingCard 
var selected_card_pointer: int = -1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("a_key_left_card"):
		highlight_selected_card(-1)
	elif Input.is_action_just_pressed("d_key_left_card"):
		highlight_selected_card(+1)
	elif Input.is_action_just_pressed("1_key"):
		try_use_card(1)
	elif Input.is_action_just_pressed("2_key"):
		try_use_card(2)
	elif Input.is_action_just_pressed("3_key"):
		try_use_card(3)
	elif Input.is_action_just_pressed("4_key"):
		try_use_card(4)

func start_game():
	generate_new_room()
	next_button.deactivate()
	reroll_button.activate()

func end_game():
	for card in current_room.get_children():
		card.deactivate_card()
	next_button.deactivate()
	reroll_button.deactivate()

func generate_new_room():
	reroll_button.decrease_cooldown()
	next_button.deactivate()
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
		new_card.card_used.connect(use_card)
		current_room.add_child(new_card)
		new_card.start(spaw_points.get(n_old_cards + i).position, cards.get(i), i+1)
		new_card.add_to_group("Cards")
	
	print(deck.playing_deck.deck.size())

func use_card(card: PlayingCard):
	current_room.remove_child(card)
	
	if card.card.suit == Card.Suits.CLUBS or card.card.suit == Card.Suits.SPADES:
		emit_signal("player_took_damage", card)
		
	elif card.card.suit == Card.Suits.HEARTS:
		emit_signal("player_healed", card)
		
	elif card.card.suit == Card.Suits.DIAMONDS:
		emit_signal("player_added_armor", card)
	
	if player.current_health <= 0:
		return
	
	if needs_new_room():
		generate_new_room()
		reroll_button.activate()
	elif current_room.get_child_count() == 1:
		next_button.activate()
	else:
		reroll_button.deactivate()

func needs_new_room() -> bool:
	return current_room.get_child_count() == 0 

func refresh_room():
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

func highlight_selected_card(increment: int):
	var selected_card = current_room.get_child(selected_card_pointer)
	if selected_card != null:
		selected_card.highlight_off()
	selected_card_pointer = clamp(selected_card_pointer + increment, 0, current_room.get_child_count() - 1) 
	current_room.get_child(selected_card_pointer).highlight_on()

func try_use_card(card_number: int):
	for card in current_room.get_children():
		if card.position_in_room == card_number:
			card.play_card()
