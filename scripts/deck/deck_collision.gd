extends CollisionShape2D

var in_deck: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	in_deck = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_mouse_click") and in_deck:
		print(2)
	

func _on_deck_mouse_entered() -> void:
	in_deck = true
	print(1)


func _on_deck_mouse_exited() -> void:
	in_deck = false
	print(0)
