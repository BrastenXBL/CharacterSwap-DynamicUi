extends Node2D
# Main Scene Control
# This script resets the main seen when ESCAPE "ui_cancel" is pressed.

func _input(event):
	if event.is_action_released("ui_cancel"):
		get_tree().reload_current_scene()
