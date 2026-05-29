class_name CardSlot
extends Node2D

var slot_number: int
var card: PlayingCard

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card == null: return
	if Input.is_action_just_pressed(str(slot_number) + "_key") and card.in_game:
		card.play_card()

func start(number: int):
	assert(number != null)
	slot_number = number
	
func set_card(new_card: PlayingCard):
	assert(new_card != null)
	remove_card()
	card = new_card
	add_child(card)

func remove_card() -> PlayingCard:
	var temp = card
	remove_child(card)
	card = null
	return temp

func delete_card():
	if card != null:
		card.queue_free()
	card = null

func is_empty():
	return card == null
