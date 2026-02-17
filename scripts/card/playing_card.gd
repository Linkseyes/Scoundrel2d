class_name PlayingCard
extends Area2D

@export var card_size: Vector2
var card: Card
var selected: bool
var room_manager: RoomManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_mouse_click") and selected:
		room_manager.use_card(self)

func start(pos: Vector2, p_card: Card, manager: RoomManager):
	position = pos
	card = p_card
	room_manager = manager
	
	var sprite_position = Vector2(0,0)

	sprite_position.x = (card_size.x + 1) * (card.number + card.face)
	sprite_position.y = (card_size.y + 1) * (card.suit -1)
	$Sprite2D.region_enabled = true
	$Sprite2D.region_rect = Rect2(sprite_position, card_size)
	
	show()

func _on_mouse_entered() -> void:
	selected = true

func _on_mouse_exited() -> void:
	selected = false
