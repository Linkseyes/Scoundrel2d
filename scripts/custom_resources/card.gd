# Resourse Class of a card 
class_name Card
extends Resource

# The Face of a card, NULL if it is a number
enum Faces {
	NULL,
	JACK,
	QUEEN,
	KING,
	JOKER
}

# The Face of a card, NULL for NULL's sake
enum Suits {
	NULL,
	HEARTS,
	DIAMONDS,
	CLUBS,
	SPADES
}

# True if the card is a number card from the Ace to a 10 
@export var is_numbered_card: bool
# True if the card is a face card: Jack, Queen, King or Joker
@export var is_face_card: bool
# The number of the card if it is a card number between a 1-10 range
@export_range(1,10) var number: int
# The Face of the card
@export var face: Faces
# The Suit of the card
@export var suit: Suits

func _init(is_num_c=false, is_face_c=false, num=0, p_face=Faces.NULL, p_suit=Suits.NULL):
	is_numbered_card = is_num_c
	is_face_card = is_face_c
	number = num
	face = p_face
	suit = p_suit

func _to_string() -> String:
	if is_numbered_card:
		return str(number) + " of " + str(Suits.keys()[suit])
	else:
		return str(Faces.keys()[face]) + " of " + str(Suits.keys()[suit])
