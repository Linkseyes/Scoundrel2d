class_name Deck
extends Resource

@export var deck: Array[Card]

func _init(p_deck: Array[Card] = []):
	deck = p_deck
