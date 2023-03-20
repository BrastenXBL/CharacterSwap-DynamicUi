tool
class_name WallBody2D
extends KinematicBody2D
# This script defines a new node type WallBody2D.
# WallBody2D contains extra code to help setup Walls in the Editor.
# Using the 'tool' keyword to allow the 'setget' setter to trigger 
# when 'wall_type' is changed in the Inspector.

#enums
enum WallTypes {NONE, BLUE, RED, WHITE}

#export vars, Inspector
export var wall_damage = 5
export(WallTypes) var wall_type = WallTypes.NONE setget _set_wall_type #custom Setter

# private vars
var _poloygon : Polygon2D

#built-in virutal _ready method
func _ready():
	_poloygon = get_node("Polygon2D")
	collision_layer = 0x0000
	collision_mask =  0x0000
	set_wall_color(wall_type)
 

# Set the Wall Color based on its type in the Inspector. 
# This saves manually editing each Wall, 
# or having a PackedScene for each Wall Color and Size.
func set_wall_color(type):
	# This is needed for the Editor tool. Get the Wall child Polygon2D node to change the color.
	if _poloygon == null:
		_poloygon = get_node("Polygon2D")

	match (type):
		WallTypes.NONE:
			_poloygon.color = Color(0, 0, 0)
			collision_layer = 0b0001
		WallTypes.BLUE:
			_poloygon.color = Color(31/255.0 , 68/255.0, 156/255.0)
			collision_layer = 0b0010
		WallTypes.RED:
			_poloygon.color = Color(240/255.0, 80/255.0, 57/255.0)
			collision_layer = 0b0100
		WallTypes.WHITE:
			_poloygon.color = Color(211/255.0, 211/255.0, 211/255.0)
			collision_layer = 0b1000


#private methods

# Custom Setter
# https://docs.godotengine.org/en/3.5/tutorials/plugins/running_code_in_the_editor.html#editing-variables
func _set_wall_type(new_value)->void:
	wall_type = new_value
	set_wall_color(new_value)
