extends Node2D

@export_category("configuration")
@export var is_horz = true
@export var activated = true
@export var left_dist_pixels = 100
@export var right_dist_pixels = 100
@export var speed_pixels = 60
@export var curr_pos = 0
@export var direction = 1

@export_category("nodes")
@export var platform: AnimatableBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func switch_state(state: bool):
	activated = state	
	
func get_dimension_handler():
	return $DimensionHandler	
	
func get_velocity():
	if is_horz:
		return speed_pixels * direction * Vector2.RIGHT
	else:
		return speed_pixels * direction * Vector2.DOWN
		
func _physics_process(delta):
	if not activated:
		return
		
	var move_pixels = direction * speed_pixels * delta

	var curr_pos_copy = curr_pos
	curr_pos_copy += move_pixels
	
	if curr_pos_copy > right_dist_pixels:
		direction = -1
		move_pixels -= curr_pos_copy - right_dist_pixels
		
	elif curr_pos_copy < -1 * left_dist_pixels:
		direction = 1
		move_pixels -= curr_pos_copy + left_dist_pixels
		
	curr_pos += move_pixels	
	
	if is_horz:
		platform.position.x += move_pixels
	else:
		platform.position.y += move_pixels
