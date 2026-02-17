class_name Player
extends Node

@export var max_health: int
@export var health_label: Label
var current_armor: PlayingCard
var current_health: int
var last_defended: int
var current_discard: PlayingCard
var n_monsters_defended: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	health_label.text = str(current_health)
	current_armor = null
	last_defended = max_health + 1
	current_discard = null
	n_monsters_defended = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(card: PlayingCard):
	var damage = 0
	if card.card.number == 1:
		damage = 14
	else: damage = card.card.number + card.card.face
	
	var effective_armor = 0
	if damage < last_defended and current_armor != null:
		effective_armor = current_armor.card.number
		add_monster_card_to_armor(card)
	else: discard_card(card)
	
	if damage > effective_armor:
		current_health = current_health - (damage - effective_armor)
		last_defended = damage
	
	if current_health < 0:
		current_health = 0
	health_label.text = str(current_health)

func add_monster_card_to_armor(monster_card: PlayingCard):
	monster_card.position = $ArmorPosition.position
	monster_card.position.x += 15 + n_monsters_defended * 15
	current_armor.add_child(monster_card)
	n_monsters_defended += 1

func add_new_armor(new_armor: PlayingCard):
	current_armor = new_armor
	last_defended = max_health + 1
	switch_armor_card(new_armor)
	
func switch_armor_card(card: PlayingCard):
	discard_card(current_armor)
		
	current_armor = card
	add_child(card)
	card.position = $ArmorPosition.position

func heal(card: PlayingCard):
	current_health += card.card.number
	if current_health > max_health:
		current_health = max_health
	health_label.text = str(current_health)
	discard_card(card)

func discard_card(card: PlayingCard):
	if card == null: return
	remove_child(current_discard)
	current_discard = card
	add_child(card)
	for i in current_discard.get_children():
		card.remove_child(i)
	card.position = $DiscardPilePosition.position
