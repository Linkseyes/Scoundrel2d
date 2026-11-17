extends CanvasLayer

@onready var restart_button: Button = $Container/RestartButton
#@onready var color_rect: ColorRect = $ColorRect
@onready var message: Label = $Container/Message

func hide_hud():
	message.hide()
	restart_button.hide()
	#await fade_out().finished
	#color_rect.visible = false

func show_message(text):
	message.text = text
	message.show()

func show_game_loss():
	show_message("You Lost")
	
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	restart_button.text = "Try Again"
	restart_button.show()

func show_game_won():
	show_message("You Won!")
	
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	restart_button.text = "Restart"
	restart_button.show()

func fade_out():
	var tween = create_tween()
	#tween.tween_property(color_rect,"color:a",0,1)
	return tween
