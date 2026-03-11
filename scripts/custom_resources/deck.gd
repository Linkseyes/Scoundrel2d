# Resourse Class of a deck of cards 
class_name Deck
extends Resource

## The array of cards
@export var deck: Array[Card]

func _init(p_deck: Array[Card] = []):
	deck = p_deck
