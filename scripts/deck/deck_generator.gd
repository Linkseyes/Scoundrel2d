extends Node

# Generate a deck of cards in accordance to the rules of Scoundrel
func generate_scoundrel_deck() -> Deck:
	# Generates a full deck
	var new_deck = generate_deck(false)
	# Filters the deck
	filter_to_scoundrel_deck(new_deck)
	# Randomizes the deck
	new_deck.deck.shuffle()
	return new_deck

# Generate a full deck of cards
# Can be customized to include a x number of Joker
func generate_deck(add_jokers: bool, number_of_jokers: int = 0):
	# Create a new Deck resource
	var deck_of_cards = Deck.new()
	
	# Loops through every suit of cards in the enum Card.Suits
	for current_suit in Card.Suits:
		if Card.Suits[current_suit] != Card.Suits.NULL:
			# Loops through every number in a deck of cards for each suit
			for n in range(1,11):
				# Creates and appends numbered card
				var new_card = Card.new(true, false, n, Card.Faces.NULL, Card.Suits[current_suit])
				deck_of_cards.deck.append(new_card)
			
			# Loops through every face in a deck of cards for each suit (excludes Joker)
			for current_face in Card.Faces:
				# Creates and appends face card
				if Card.Faces[current_face] != Card.Faces.NULL and Card.Faces[current_face] != Card.Faces.JOKER:
					var new_card = Card.new(false, true, 10, Card.Faces[current_face], Card.Suits[current_suit])
					deck_of_cards.deck.append(new_card)
	
	# Adds the Jokers to the deck
	if add_jokers == true:
		# Creates the N number of Jokers
		for n in number_of_jokers:
			var new_card = Card.new()
			new_card.face = Card.Faces.JOKER;
			deck_of_cards.append(new_card)
	
	return deck_of_cards

# Filter for a scoundrel deck of cards
func filter_to_scoundrel_deck(deck_of_cards: Deck):
	deck_of_cards.deck = deck_of_cards.deck.filter(
		# Custom function to check every card
		# If returns true: card is kept in the deck, if returns false: card is discarded
		# For a scoundrel deck we want to discard all red faces and aces
		func(card: Card):
			# bool to determine if the current card is not a red face
			var is_not_red_face = card.face == Card.Faces.NULL or (card.suit != Card.Suits.HEARTS and card.suit != Card.Suits.DIAMONDS)
			# bool to determine if the current card is a red ace
			var is_red_ace = (card.suit == Card.Suits.HEARTS or card.suit == Card.Suits.DIAMONDS) and card.number == 1
			return is_not_red_face and !is_red_ace
	)
