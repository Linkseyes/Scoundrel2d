class_name PlayingCard
extends Area2D

# The size of the card in pixels: x for width, y for height
@export var card_size: Vector2
# The Card resourse for this card
var card: Card
# If this card is being selected by the mouse
var selected: bool
# The RoomManager that created the card (used to comunicate back)
var room_manager: RoomManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_mouse_click") and selected:
		# If the player clicked on the card, it will perform its action
		room_manager.use_card(self)

# The starting function for the Card
# This function must be called by any sprit that creates PlayingCards
func start(pos: Vector2, p_card: Card, manager: RoomManager):
	position = pos
	card = p_card
	room_manager = manager
	
	# Calculating the starting position on the AtlasTexture for this specific Card
	var sprite_position = Vector2(0,0)
	sprite_position.x = (card_size.x + 1) * (card.number + card.face)
	sprite_position.y = (card_size.y + 1) * (card.suit -1)
	# Enabling and setting the region for the sprite
	$Sprite2D.region_enabled = true
	$Sprite2D.region_rect = Rect2(sprite_position, card_size)
	
	show()

# Method called when the mouse enters the Collider2D of the card
# Linked to the _on_mouse_entered signal 
func _on_mouse_entered() -> void:
	selected = true

# Method called when the mouse exits the Collider2D of the card
# Linked to the _on_mouse_exited signal 
func _on_mouse_exited() -> void:
	selected = false
