# Calls of the Button that 
class_name AdvanceButton
extends Button

var active: bool

signal advance_button_pressed

func _ready() -> void:
	active = true

func _on_pressed() -> void:
	if active:
		emit_signal("advance_button_pressed")

func activate():
	active = true

func deactivate():
	active = false
