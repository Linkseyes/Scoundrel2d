class_name Player
extends Node

@onready var armor_position: Marker2D = $ArmorPosition
@onready var hero_health_bar: TextureProgressBar = $CanvasLayer/HealthOrbs
@onready var armor_slot: Sprite2D = $"ArmorSlot"
@onready var canvas_layer: CanvasLayer = $CanvasLayer


## The Max Health of the player
@export var max_health: int
@export var room_manager: RoomManager
@export var armor_monster_card_offset: int
# The current card that is serving as the current armor
var current_armor: PlayingCard
# The current health of the Player
var current_health: int
# The last card the armor was used against defended
var last_defended: int

# The number of monsters defeated
var n_monsters_defended: int
# Signal that goes off when the Player dies (current_heath <= 0)
signal player_death
signal monster_defeated(monster_number: int)

func ready_player():
	current_health = max_health
	canvas_layer.visible = true
	set_health_ui(current_health)
	current_armor = null
	last_defended = max_health + 1
	n_monsters_defended = 0
	armor_slot.region_enabled = true
	armor_slot.region_rect = Rect2(Vector2(0,32), Vector2(16,16))

# Processes the player taking damage form a card
func take_damage(card: PlayingCard):
	# Corrects the damage made by the Ace card (does 1 because of number but should do 14)
	var damage = 0
	if card.card.number == 1:
		damage = 14
	else: damage = card.card.number + card.card.face
	
	# Determines if current armor will be used (effective_armor)
	# An armor that last defended a 5 can't defend against a 6 (takes full 6 damage)
	var effective_armor = 0
	if damage < last_defended and current_armor != null:
		effective_armor = current_armor.card.number
		add_monster_card_to_armor(card)
		last_defended = damage
	else: room_manager.discard_card(card)
	
	# Calculates damages for instances where the armor isn't enough (0 otherwise)
	if damage > effective_armor:
		current_health = current_health - (damage - effective_armor)
	
	# Sets current health
	print("current_healt=" + str(current_health))
	if current_health <= 0:
		current_health = 0
		emit_signal("player_death")
	else:
		emit_signal("monster_defeated", damage)
	set_health_ui(current_health)

# Adds the monster card on top of the armor card
# Aesthetic choice to make the player dont forget the last defended enemy
func add_monster_card_to_armor(monster_card: PlayingCard):
	# Moves the moster card to position
	# First resets the position because it will be a child of the location
	monster_card.position = Vector2(0,0)
	monster_card.scale = Vector2(1,1)
	monster_card.position.x += armor_monster_card_offset + n_monsters_defended * armor_monster_card_offset
	monster_card.z_index = current_armor.z_index + 1 + n_monsters_defended
	# Adds the monster to the armor list
	armor_position.add_child(monster_card)
	n_monsters_defended += 1

# Switches the old armor card with the new one
# Gets rid of all attatched monster cards
func add_new_armor(new_armor: PlayingCard):
	# Discards all cards in the Armor list (to clear the monster cards stored in there)
	for card in armor_position.get_children():
		armor_position.remove_child(card)
		room_manager.discard_card(card)
	# Adds the new Armor card to the Armor list (resets postion)
	# First resets the position because it will be a child of the location
	new_armor.position = Vector2(0,0)
	new_armor.scale = Vector2(1,1)
	armor_position.add_child(new_armor)
	# Set up new values
	current_armor = new_armor
	last_defended = max_health + 1
	n_monsters_defended = 0
	armor_slot.region_rect = new_armor.card_visuals.get_visual()

# Heals the player by the ammount on the card
# The maximum ammount of heath is determined by max_health
func heal(card: PlayingCard):
	print("current_healt=" + str(current_health))
	# Sums the number of the card to the current health of the player (respecting max_health)
	current_health += card.card.number
	if current_health > max_health:
		current_health = max_health
	# Sets new new heath value and dicards the card
	set_health_ui(current_health)
	room_manager.discard_card(card)

func set_health_ui(new_health: int):
	var tween = create_tween()
	tween.tween_property(hero_health_bar, "value", new_health, 1).set_trans(Tween.TRANS_SINE).set_delay(0)
