extends Node
# Manage Character stats, state, and information.
# This script exports variables to the inspector to customize new characters 
# duplicated from character_blank.tscn
# At Runtime sets the Poloygon2D to the correct color.
# Handles signals when stats are changes. (e.g., health_changed)
# Very simple overall.

#signals
signal health_changed(value)

#export vars, Inspector
export var character_name = "char_name"
export var character_color = Color(0,0,0,1)
export var base_health: int = 100
export var current_health: int

#public vars
var poloygon : Polygon2D

#built-in virutal _ready method
func _ready():
	poloygon = get_parent().get_node("Polygon2D")
	poloygon.color = character_color
	current_health = base_health

#public methods
# 'damage()' is setup to only change the current_health value.
# It then emits a signal to any connected Nodes and 'func', to execute code.
func damage(value):
	current_health -= value
	emit_signal("health_changed", current_health)
