# Main class for the Deck Scene
class_name PlayingDeck
extends Area2D

@onready var deck_generator: Node2D = $DeckGenerator


var playing_deck: Deck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# The starting function for the Deck
# This function must be called by any sprit that creates or uses PlayingDeck
func start(pos):
	position = pos
	playing_deck = deck_generator.generate_scoundrel_deck()
	show()

# Adds an array of cards to the bottom of the deck
func add_cards_to_deck(cards: Array[Card]):
	playing_deck.deck.append_array(cards)

## Gets the top N cards from the Deck
func get_top_n_cards(n_cards: int) -> Array[Card]:
	var top_cards: Array[Card] = []
	
	var n = 1
	var top_card = playing_deck.deck.front()
	# While loop to make sure we stop if the deck runs out of cards
	while top_card != null and n <= n_cards:
		top_cards.append(playing_deck.deck.pop_front())
		top_card = playing_deck.deck.front()
		n += 1
	
	return top_cards 
