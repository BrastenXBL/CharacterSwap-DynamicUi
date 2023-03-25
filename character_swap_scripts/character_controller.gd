extends KinematicBody2D #GD3.5
#extends CharacterBody2D #GD4.0
# Based on Example Code from 
# https://docs.godotengine.org/en/4.0/tutorials/physics/using_character_body_2d.html#movement-and-walls 

# Controls Character movement and collisions

#enums 
enum WallTypes {NONE, BLUE, RED, WHITE}

#export vars, Inspector
export var speed = 300.0
export var bounce_back_multiplier = 0.5
export(WallTypes) var wall_type = WallTypes.NONE

#public vars
var character_manager

#private vars
var _allow_input = true
var _input_timer = 0.0
var _bounce = Vector2(0,0)
var _velocity = Vector2(0,0) # Needed for GD3.5 
# GD4.0 CharacterBody2D has a velocity property 
# https://docs.godotengine.org/en/4.0/classes/class_characterbody2d.html#properties

#built-in virutal _ready method
func _ready():
	# Internal scene reference to Child CharacterManager and character_manager.gd
	character_manager = get_node("CharacterManager")

#remaining built-in virutal methods
func get_input():
	var input_dir = Input.get_vector("ui_left", "ui_right","ui_up","ui_down")
	_velocity = input_dir * speed

func _physics_process(delta):
	var collision_info
	
	# Disable Input while Character is bouncing back from collision.
	if _allow_input:
		# Normal movement. Player controlled
		get_input()
		collision_info = move_and_collide(_velocity * delta)
	else:
		# Bounce back movement. No Player control.
		_input_timer += delta
		move_and_slide(_bounce * bounce_back_multiplier * -1.0)
		# Reset Bounce vars after Time.
		if _input_timer > 0.1:
			_allow_input = true
			_input_timer = 0.0
			_bounce = Vector2(0,0)

	if collision_info != null:
		# Check Wall collider. For safty this checks for a 'null' in 'wall_type'
		if collision_info.collider.wall_type != wall_type && collision_info.collider.wall_type != null:
			# "Call Down" to CharacterManager function 'damage()'
			character_manager.damage(collision_info.collider.wall_damage)
			# Set Bounce vars
			_bounce = _velocity
			_allow_input = false
		
	
