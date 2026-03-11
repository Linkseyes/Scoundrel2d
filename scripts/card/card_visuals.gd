extends Marker2D

## The size of the sprite in the Atlas Texture
@export var monster_sprite_size: Vector2
## The space between two sprites in the Atlas Texture
@export var monster_sprite_offset: Vector2
## The size of the sprite in the Atlas Texture
@export var items_sprite_size: Vector2
## The space between two sprites in the Atlas Texture
@export var items_sprite_offset: Vector2

func set_card_visual(card: Card):
	if card.suit == Card.Suits.HEARTS or card.suit == Card.Suits.DIAMONDS:
		$Items.visible = true
		# Calculating the starting position on the AtlasTexture for this specific Card
		var sprite_position = Vector2(0,0)
		# Calculation for which sprite to use assumes first sprite at (0, 0)
		if card.suit == Card.Suits.HEARTS: 
			var card_sprite_number = int((card.number-2)/3)
			sprite_position.x = (items_sprite_size.x + items_sprite_offset.x) * card_sprite_number
		sprite_position.y = (items_sprite_size.y + items_sprite_offset.y) * (card.suit - 1) # -1 comes from the number of Suits
		# Enabling and setting the region for the sprite
		$Items/Sprite2D.region_enabled = true
		$Items/Sprite2D.region_rect = Rect2(sprite_position, items_sprite_size)
	elif card.suit == Card.Suits.CLUBS or card.suit == Card.Suits.SPADES:
		$Monster.visible = true
		# Calculating the starting position on the AtlasTexture for this specific Card
		var sprite_position = Vector2(0,0)
		var card_sprite_number = int(card.number>5)
		# Calculation for which sprite to use assumes first sprite at (0, 0)
		sprite_position.x = monster_sprite_size.x + (monster_sprite_size.x + monster_sprite_offset.x) * (card_sprite_number + card.face)
		sprite_position.y = (monster_sprite_size.y + monster_sprite_offset.y) * (card.suit - 3) # -3 comes from the number of Suits
		# Enabling and setting the region for the sprite
		$Monster/Sprite2D.region_enabled = true
		$Monster/Sprite2D.region_rect = Rect2(sprite_position, monster_sprite_size)
	else:
		print("No Suit")

func clear_visual():
	$Items.visible = false
	$Monster.visible = false
