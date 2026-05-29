# Main class for the Deck Scene
class_name PlayingDeck
extends Area2D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var deck_generator: Node2D = $DeckGenerator
@onready var deck_health_bar: TextureProgressBar = $CanvasLayer/DeckHealthBar

@export var max_health: int
var current_health: int
var playing_deck: Deck

signal deck_defeated

# The starting function for the Deck
# This function must be called by any sprit that creates or uses PlayingDeck
func start():
	playing_deck = deck_generator.generate_scoundrel_deck()
	print(playing_deck.deck.size())
	show()
	canvas_layer.visible = true
	set_health(max_health)
	
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

func take_damage(damage: int):
	current_health -= damage
	if current_health <= 0:
		emit_signal("deck_defeated")
	set_health(current_health)

func set_health(health: int):
	current_health = health
	var tween = create_tween()
	tween.tween_property(deck_health_bar, "value", current_health, 1).set_trans(Tween.TRANS_SINE).set_delay(0)
