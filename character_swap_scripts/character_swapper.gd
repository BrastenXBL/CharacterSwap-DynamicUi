extends Node
# Handles characters loading and tracks swaps.
# This script loads and stores charaters and their related UI elements.
# The Arrays 


#export variables, Inspector
export var number_of_characters = 0
export var active_character_index = 0

#private variables

# Using a Dictonary to replace a number with character name. This is being unnecessarily fancy, and is not really needed.
var _character_dict = {-1: "blank", 0: "briar", 1: "riely", 2: "whitney"}
# Arrays for tracking charaters and UI elements
var _characters_list : Array
var _health_display_list : Array
#
var _character_blank
var _player_root
var _health_display_root
var _input_character_swap : bool
var _previous_character_index : int

#built-in virutal _ready method
func _ready():
	_player_root = get_parent()
	# Getting a node referance to the VBoxContainer. Not ideal for reusability, or if the NodePath changes during development.
	_health_display_root = get_tree().get_root().get_node("MainScene/MainUi/HealthBars/VBoxContainer")
	#
	_setup_characters_and_arrays()
	_attach_character_to_player()

#remaining built-in virutal methods
func _input(event):
	# When Space/Return/Enter are pressed Swap or change which character is active.
	if event.is_action_released("ui_accept"):
		_swap_characters()

#private methods
# Intial character loading and refernce storage to Arrays
func _setup_characters_and_arrays():
	# Test loading of Blank Character. Left in as commnet for clean example.
	#_character_blank = load("res://characters/character_blank.tscn").instance()
	#_characters_list.append(_character_blank)
	
	for n in number_of_characters:
		# Dictonary is used to replace number 'n' with string a that is the charater's name.
		var temp_string = "res://characters/character_" + _character_dict[n] + ".tscn"
		## 
		# var temp_string = "res://characters/character_" + str(n+1) + ".tscn"
		# print_debug(temp_string) #Uncomment to see result printed to console.
		
		# Append the Charaters and an Instance() copy of the 'health_display' PackedScene to their Arrays.
		_characters_list.append(load(temp_string).instance())
		_health_display_list.append(load("res://character_swap_ui/health_display.tscn").instance())
		
		# Configure the HealthDisplay for each 'n' character. 
		# Store temporary reference for this 'n' loop.
		var temp_ref = _characters_list[n].get_node("CharacterManager")
		# Connect the "health_changed" signal in character_manager, 
		# to the func 'on_health_changed()' in the HealthDisplay node. 
		# See health_display.gd
		temp_ref.connect("health_changed", _health_display_list[n], "on_health_changed" )
		
		# Set the HealthDisplay values. Normally you should "Signal Across" to another Scene and prompt functions, instead of Calling functions. 
		# However we already have the References from loading and storing.
		# So we'll Call the public Setter functions/methods, this one time, during setup.
		_health_display_list[n].set_name_display(temp_ref.character_name)
		_health_display_list[n].set_max_health(temp_ref.base_health)
		_health_display_list[n].set_current_health(temp_ref.base_health)


# Attach the 1st Character who will be "Active" to the Player node. 
# The Character could added anywhere, to get it into the Scene Tree.
# Player node is just a nice organizing point, and can be used as a Spawn Point.
func _attach_character_to_player():
	_player_root.call_deferred("add_child", _characters_list[active_character_index])
	
	# Attach the HealthDisplays for all charaters to the VBoxContainer.
	for n in _health_display_list.size():
		_health_display_root.call_deferred("add_child", _health_display_list[n])


# Apologies for how wordy this is. 
# The var names could be shorter to make it more readable at a glance,
# by someone who knows what's going on.
# 
# Remember:		active_character_index is an Integer (0 to 2), for the 3 characters.
#	Same for:	_previous_character_index, this is an Integer
#
# Comments will do an example step through by Number,
# on the Line following using 'p' for previous
#
# Code for swapping Characters
func _swap_characters():
	_previous_character_index = active_character_index
	# Result:	^ p0 'briar'		^ 0 'briar'
	
	active_character_index += 1
	# Result: 1 'riely'
	
	# Ignore this in the example.
	# Loop back to the start of the Array, to keep cycling through characters.
	if active_character_index > number_of_characters-1:
		active_character_index = 0
		# Result: 0 'briar'
		
	# Bring 1 'riely' into the SceneTree. 'riely' was Loaded but not Parented to the Scene.   
	# https://docs.godotengine.org/en/3.5/tutorials/scripting/scene_tree.html#scene-tree
	_player_root.add_child(_characters_list[active_character_index])
	# ^ Player node			^ Array[]				^ 1 'riely'
	
	# Set the position of the incoming Character to where the outgoing character is.
	_characters_list[active_character_index].set_position(_characters_list[_previous_character_index].position)
	# ^ Array[]			^ 1 'riely'								^ Array[]		^ p0 briar'
	
	# Should probably create a "Signal Across" instead of Calling public func directly. See health_display.gd
	_health_display_list[active_character_index].move_health_display_to_top()
	
	_player_root.remove_child(_characters_list[_previous_character_index])
	# ^ Player node				^ Array[]			^ p0 'briar'
	#
	# Remove p0 'briar' from the Scene Tree. They are no longer a child of Root Viewport or any other Node.
	# We are not using 'queue_free()'. We want the Instance() of 'briar' to stay, outside the Scene Tree.
	# https://docs.godotengine.org/en/3.5/tutorials/scripting/scene_tree.html#root-viewport
	# https://docs.godotengine.org/en/3.5/classes/class_node.html#class-node-method-remove-child
	# https://docs.godotengine.org/en/3.5/classes/class_node.html?class-node-method-queue_free#class-node-method-queue-free
	

