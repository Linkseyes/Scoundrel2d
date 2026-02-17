class_name PlayingDeck
extends Area2D

var playing_deck: Deck

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start(pos):
	position = pos
	playing_deck = $DeckGenerator.generate_scoundrel_deck()
	show()

func add_cards_to_deck(cards: Array[Card]):
	playing_deck.deck.append_array(cards)

func get_top_n_cards(n_cards: int) -> Array[Card]:
	var top_cards: Array[Card] = []
	
	var n = 1
	var top_card = playing_deck.deck.front()
	while top_card != null and n <= n_cards:
		top_cards.append(playing_deck.deck.pop_front())
		top_card = playing_deck.deck.front()
		n += 1
	
	return top_cards 
