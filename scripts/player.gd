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

# Processes the player taking damage form a card
func take_damage(card: PlayingCard):
	# Corrects the damage made by the Ace card (does 1 because of number but should do 14)
	var damage = 0
	if card.card.number == 1:
		damage = 14
	else: damage = card.card.number + card.card.face
	
	# Determines if current armor will be used
	# An armor that last defended a 5 can't defend against a 6 (takes full 6 damage)
	var effective_armor = 0
	if damage < last_defended and current_armor != null:
		effective_armor = current_armor.card.number
		add_monster_card_to_armor(card)
		last_defended = damage
	else: discard_card(card)
	
	# Calculates damages for instances where the armor isn't enough (0 otherwise)
	if damage > effective_armor:
		current_health = current_health - (damage - effective_armor)
	
	# Sets current health
	print("current_healt=" + str(current_health))
	if current_health < 0:
		current_health = 0
	health_label.text = str(current_health)

# Adds the monster card on top of the armor card
# Aesthetic choice to make the player dont forget the last defended enemy
func add_monster_card_to_armor(monster_card: PlayingCard):
	# Moves the moster card to position
	# First resets the position because it will be a child of the location
	monster_card.position = Vector2(0,0)
	monster_card.position.x += 40 + n_monsters_defended * 40
	monster_card.z_index = current_armor.z_index + 1 + n_monsters_defended
	# Adds the monster to the armor list
	$ArmorPosition.add_child(monster_card)
	n_monsters_defended += 1

# Switches the old armor card with the new one
# Gets rid of all attatched monster cards
func add_new_armor(new_armor: PlayingCard):
	# Discards all cards in the Armor list (to clear the monster cards stored in there)
	for card in $ArmorPosition.get_children():
		$ArmorPosition.remove_child(card)
		discard_card(card)
	# Adds the new Armor card to the Armor list (resets postion)
	# First resets the position because it will be a child of the location
	new_armor.position = Vector2(0,0)
	$ArmorPosition.add_child(new_armor)
	# Set up new values
	current_armor = new_armor
	last_defended = max_health + 1
	n_monsters_defended = 0

# Heals the player by the ammount on the card
# The maximum ammount of heath is determined by max_health
func heal(card: PlayingCard):
	print("current_healt=" + str(current_health))
	# Sums the number of the card to the current health of the player (respecting max_health)
	current_health += card.card.number
	if current_health > max_health:
		current_health = max_health
	# Sets new new heath value and dicards the card
	health_label.text = str(current_health)
	discard_card(card)

# Method that moves a card to the discard pile
# Since, acording to the rules of the game, the players doesn't need to check the
# discarding pile, this method deletes the old card and replaces it with the new one
# The card in the discard pile is a child of Player so it can be rendered
func discard_card(card: PlayingCard):
	# Return if the card is null
	if card == null: return
	# Removes the current card in the discard pile
	remove_child(current_discard)
	# Adds the new card and moves it to position
	add_child(card)
	current_discard = card
	card.position = $DiscardPilePosition.position
