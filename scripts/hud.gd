extends CanvasLayer

@onready var message: Label = $Message
@onready var start_button: Button = $StartButton
@onready var color_rect: ColorRect = $ColorRect


signal start_game

func show_message(text):
	message.text = text
	message.show()

func show_game_loss():
	show_message("You Lost")
	
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	start_button.text = "Try Again"
	start_button.show()

func show_game_won():
	show_message("You Won!")
	
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	start_button.text = "Start"
	start_button.show()

func _on_start_button_pressed():
	start_button.hide()
	start_game.emit()
	await fade_out().finished
	color_rect.visible = false

func fade_out():
	var tween = create_tween()
	tween.tween_property(color_rect,"color:a",0,1)
	return tween
