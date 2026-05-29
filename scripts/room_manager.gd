class_name RoomManager
extends Node

@onready var next_button: AdvanceButton = $Next
@onready var reroll_button: RerollButton = $Reroll
@onready var current_room: CurrentRoom = $CurrentRoom
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
var selected_card_pointer: int = -1

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("a_key_left_card"):
		highlight_selected_card(-1)
	elif Input.is_action_just_pressed("d_key_left_card"):
		highlight_selected_card(+1)

func start_game():
	generate_new_room()
	next_button.deactivate()
	reroll_button.activate()

func end_game():
	current_room.deactivate_room()
	next_button.deactivate()
	reroll_button.deactivate()

func generate_new_room():
	reroll_button.decrease_cooldown()
	next_button.deactivate()
	
	var n_of_cards_in_room = current_room.n_of_cards_in_room()
	current_room.organize_room()
	
	var cards: Array[Card] = deck.get_top_n_cards(room_size-n_of_cards_in_room)
	print(cards)
	
	for i in range(cards.size()):
		var new_card = card_scene.instantiate()
		new_card.card_used.connect(use_card)
		current_room.add_card_to_room(new_card)
		new_card.start(cards[i], i+1)

func use_card(card: PlayingCard):
	current_room.remove_card(card)
	
	if card.card.suit == Card.Suits.CLUBS or card.card.suit == Card.Suits.SPADES:
		emit_signal("player_took_damage", card)
		
	elif card.card.suit == Card.Suits.HEARTS:
		emit_signal("player_healed", card)
		
	elif card.card.suit == Card.Suits.DIAMONDS:
		emit_signal("player_added_armor", card)

func try_generate_new_room():
	if needs_new_room():
		generate_new_room()
		reroll_button.activate()
	elif current_room.n_of_cards_in_room() == 1:
		next_button.activate()
	else:
		reroll_button.deactivate()

func needs_new_room() -> bool:
	return current_room.n_of_cards_in_room() == 0

func refresh_room():
	var array: Array[Card] = []
	var cleaned_room = current_room.clear_room()
	for card in cleaned_room:
		array.append(card.card)
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

func discard_cards(cards: Array[PlayingCard]):
	for card in cards:
		discard_card(card)

func highlight_selected_card(increment: int):
	var selected_card = current_room.get_card_in_filled_slot(selected_card_pointer)
	if selected_card != null:
		selected_card.highlight_off()
	selected_card_pointer = clamp(selected_card_pointer + increment, 0, current_room.n_of_cards_in_room() - 1) 
	current_room.get_card_in_filled_slot(selected_card_pointer).highlight_on()
