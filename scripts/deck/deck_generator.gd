extends Node

func generate_scoundrel_deck() -> Deck:
	var new_deck = generate_deck(false)
	filter_to_scoundrel_deck(new_deck)
	new_deck.deck.shuffle()
	return new_deck

func generate_deck(add_jokers: bool, number_of_jokers: int = 0):
	var deck_of_cards = Deck.new()
	
	for current_suit in Card.Suits:
		if Card.Suits[current_suit] != Card.Suits.NULL:
			for n in range(1,11):
				var new_card = Card.new()
				new_card.is_numbered_card = true
				new_card.number = n
				new_card.suit = Card.Suits[current_suit]
				deck_of_cards.deck.append(new_card)
				
			for current_face in Card.Faces:
				if Card.Faces[current_face] != Card.Faces.NULL and Card.Faces[current_face] != Card.Faces.JOKER:
					var new_card = Card.new()
					new_card.is_face_card = true
					new_card.number = 10
					new_card.face = Card.Faces[current_face]
					new_card.suit = Card.Suits[current_suit]
					deck_of_cards.deck.append(new_card)
	
	if add_jokers == true:
		for n in number_of_jokers:
			var new_card = Card.new()
			new_card.face = Card.Faces.JOKER;
			deck_of_cards.append(new_card)
			
	return deck_of_cards

func filter_to_scoundrel_deck(deck_of_cards: Deck):
	deck_of_cards.deck = deck_of_cards.deck.filter(
		func(card: Card):
			var is_not_red_face = card.face == Card.Faces.NULL or (card.suit != Card.Suits.HEARTS and card.suit != Card.Suits.DIAMONDS)
			var is_red_ace = (card.suit == Card.Suits.HEARTS or card.suit == Card.Suits.DIAMONDS) and card.number == 1
			return is_not_red_face and !is_red_ace
	)
