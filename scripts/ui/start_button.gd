extends MainMenuButton 

func _on_mouse_entered() -> void:
	change_on_hover_enter()

func _on_mouse_exited() -> void:
	change_on_hover_exit()

func _on_button_down() -> void:
	change_on_press_down()
	print("start")

func _on_button_up() -> void:
	change_on_press_up()
