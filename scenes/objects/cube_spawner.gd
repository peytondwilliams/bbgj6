extends StaticBody2D

@onready var CUBE_PRELOAD = preload("res://scenes/objects/box.tscn")

@export var cube_dimension = 1
@export var cube_is_all_dimensions = false
@export var all_dimension_color: Color

var cube_tracker : RigidBody2D = null 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func switch_state(state: bool):
	# ignore state, will just spawn a single cube
	
	if cube_tracker != null:
		cube_tracker.queue_free()
	
	var new_cube = CUBE_PRELOAD.instantiate()
	new_cube.get_dimension_handler().dimension = cube_dimension
	new_cube.get_dimension_handler().is_all_dimensions = cube_is_all_dimensions
	if cube_is_all_dimensions:
		new_cube.modulate = all_dimension_color
	
	get_parent().add_child(new_cube)
	new_cube.global_position = $Marker2D.global_position
	
	cube_tracker = new_cube
	

func get_dimension_handler():
	return $DimensionHandler
