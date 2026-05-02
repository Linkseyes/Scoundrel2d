extends Node
class_name CardVisuals

@onready var items_sprite_2d: Sprite2D = $Item
@onready var monster_sprite_2d: Sprite2D = $Monster
@onready var card: PlayingCard = $".."

## The size of the sprite in the Atlas Texture
@export var monster_sprite_size: Vector2
## The space between two sprites in the Atlas Texture
@export var monster_sprite_offset: Vector2
## The size of the sprite in the Atlas Texture
@export var items_sprite_size: Vector2
## The space between two sprites in the Atlas Texture
@export var items_sprite_offset: Vector2

func set_card_visual():
	if card.card.suit == Card.Suits.HEARTS or card.card.suit == Card.Suits.DIAMONDS:
		items_sprite_2d.visible = true
		# Calculating the starting position on the AtlasTexture for this specific Card
		var sprite_position = Vector2(0,0)
		# Calculation for which sprite to use assumes first sprite at (0, 0)
		var card_sprite_number = int((card.card.number-2)/3)
		sprite_position.x = (items_sprite_size.x + items_sprite_offset.x) * card_sprite_number
		sprite_position.y = (items_sprite_size.y + items_sprite_offset.y) * (card.card.suit - 1) # -1 comes from the number of Suits
		# Enabling and setting the region for the sprite
		items_sprite_2d.region_enabled = true
		items_sprite_2d.region_rect = Rect2(sprite_position, items_sprite_size)
	elif card.card.suit == Card.Suits.CLUBS or card.card.suit == Card.Suits.SPADES:
		monster_sprite_2d.visible = true
		# Calculating the starting position on the AtlasTexture for this specific Card
		var sprite_position = Vector2(0,0)
		var card_sprite_number = int(card.card.number>1) + int(card.card.number>5)
		# Calculation for which sprite to use assumes first sprite at (0, 0)
		sprite_position.x = monster_sprite_size.x + (monster_sprite_size.x + monster_sprite_offset.x) * (card_sprite_number + card.card.face)
		sprite_position.y = (monster_sprite_size.y + monster_sprite_offset.y) * (card.card.suit - 3) # -3 comes from the number of Suits
		# Enabling and setting the region for the sprite
		monster_sprite_2d.region_enabled = true
		monster_sprite_2d.region_rect = Rect2(sprite_position, monster_sprite_size)
	else:
		print("No Suit")

func clear_visual():
	items_sprite_2d.visible = false
	monster_sprite_2d.visible = false

func get_visual():
	if card.card.suit == Card.Suits.HEARTS or card.card.suit == Card.Suits.DIAMONDS:	
		return items_sprite_2d.region_rect
	else:
		return monster_sprite_2d.region_rect
