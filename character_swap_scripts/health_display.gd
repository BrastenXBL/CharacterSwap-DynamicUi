extends Control

#private variables
var _health_bar : ProgressBar
var _name_display : Label


#built-in virutal _ready method
func _ready():
	_health_bar = get_node("HealthBar")
	_name_display = get_node("HealthBar/NameDisplay")

#public methods

# Function is used during initial Character setup.
func setup_health_display(character_name, current_health):
	set_name_display(character_name)
	set_current_health(current_health)


func set_name_display(character_name):
	# Null check. Bad practice, covering for setting up before all nodes are ready.
	if _name_display == null:
		_name_display = get_node("HealthBar/NameDisplay")
	_name_display.text = character_name


func set_current_health(current_health):
	# Null check. Bad practice, covering for setting up before all nodes are ready.
	if _health_bar == null:
		_health_bar = get_node("HealthBar")
	_health_bar.value = current_health


func set_max_health(max_health):
	# Null check. Bad practice, covering for setting up before all nodes are ready.
	if _health_bar == null:
		_health_bar = get_node("HealthBar")
	_health_bar.max_value = max_health


# Function for Signal "health_changed". Emit from Active Character when its health changes.	
# Uses set_current_health. Can be expanded to do more than set ProgessBar value.
# Example: a function to make bar "shake" visually when hit.
func on_health_changed(current_health):
	set_current_health(current_health)


# Function for Signal "move_health_display_to_top" # No Singal currently exists. Function is Called.
# to move the Health_Display to the top of the VBoxContainer.
# Emit from Active Character. Used when Character becomes Active.
func move_health_display_to_top():
	get_parent().move_child(self, 0)

