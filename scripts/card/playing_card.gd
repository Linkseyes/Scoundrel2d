class_name PlayingCard
extends Area2D

@onready var card_visuals: CardVisuals = $CardVisuals
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var highlight: AnimatedSprite2D = $Highlight

## The size of the card in pixels: x for width, y for height
@export var card_size: Vector2
# The Card resourse for this card
var card: Card
# If this card is being selected by the mouse
var selected: bool
# If the card in in the game or in the discard pile
var in_game: bool

signal card_used(card: PlayingCard)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_tree.get("parameters/playback").travel("highlight")
	selected = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !in_game:
		return
	
	if Input.is_action_just_pressed("select_card") and selected:
		play_card()

func play_card():
	# If the player clicked on the card, it will perform its action
	highlight.visible = false
	in_game = false
	card_visuals.clear_visual()
	emit_signal("card_used", self)

# The starting function for the Card
# This function must be called by any sprit that creates PlayingCards
func start(p_card: Card, p_position_in_room: int):
	card = p_card
	in_game = true
	
	set_card_sprite()
	card_visuals.set_card_visual()
	
	show()

func set_card_sprite():
	# Calculating the starting position on the AtlasTexture for this specific Card
	var sprite_position = Vector2(0,0)
	sprite_position.x = (card_size.x + 1) * (card.number + card.face)
	sprite_position.y = (card_size.y + 1) * (card.suit -1)
	# Enabling and setting the region for the sprite
	sprite_2d.region_enabled = true
	sprite_2d.region_rect = Rect2(sprite_position, card_size)

func get_numerical_value():
	# Corrects the damage made by the Ace card (does 1 because of number but should do 14)
	if card.number == 1:
		return 14
	else:
		return card.number + card.face

# Method called when the mouse enters the Collider2D of the card
# Linked to the _on_mouse_entered signal 
func _on_mouse_entered() -> void:
	if in_game:
		highlight.visible = true
	selected = true

# Method called when the mouse exits the Collider2D of the card
# Linked to the _on_mouse_exited signal 
func _on_mouse_exited() -> void:
	highlight.visible = false
	selected = false

func deactivate_card():
	in_game = false

func highlight_on():
	highlight.visible = true
	selected = true

func highlight_off():
	highlight.visible = false
	selected = false

func equals(other) -> bool:
	if other == null or other is not PlayingCard:
		return false
	return card.number == other.card.number and card.face == other.card.face and card.suit == other.card.suit
	
