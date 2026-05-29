class_name CurrentRoom
extends Node2D

@export var card_slot_scene: PackedScene
var slots: Array[CardSlot]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(get_child_count()):
		var new_slot = card_slot_scene.instantiate()
		#new_slot.card_used.connect(use_card)
		get_child(i).add_child(new_slot)
		new_slot.start(i+1)
		new_slot.add_to_group("Slots")
		slots.append(new_slot)

func n_of_cards_in_room() -> int:
	var count = 0
	for slot in slots:
		if !slot.is_empty():
			count +=1
	return count

func add_card_to_room(new_card: PlayingCard):
	for slot in slots:
		if slot.is_empty():
			slot.set_card(new_card)
			break

# Pushes cards to the right in the room
func organize_room():
	if n_of_cards_in_room() <= 0:
		return
	var last_empty_slot = 0
	for slot in slots:
		if last_empty_slot == slot.slot_number and !slots[last_empty_slot].is_empty():
			last_empty_slot += 1
		elif !slot.is_empty():
			slots[last_empty_slot].set_card(slot.remove_card())
			last_empty_slot += 1

func clear_room() -> Array[PlayingCard]:
	var room_cards: Array[PlayingCard]
	for slot in slots:
		room_cards.append(slot.remove_card())
	return room_cards

func remove_card(card: PlayingCard):
	for slot in slots:
		if !slot.is_empty() and slot.card.equals(card):
			slot.remove_card()

func deactivate_room():
	for slot in slots:
		if !slot.is_empty():
			slot.card.deactivate_card()

func get_card_in_filled_slot(slot_number: int):
	var counter = 0
	for slot in slots:
		if counter == slot_number and !slot.is_empty():
			return slot.card
		elif slot.is_empty():
			slot_number +=1
		counter +=1
