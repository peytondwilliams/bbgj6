extends Node

@onready var eb = EventBus

@export var swap_cooldown_timer: Timer
@export var bodies: Array[CollisionObject2D]

@export var dimension = 1
@export var is_all_dimensions = false

# Called when the node enters the scene tree for the first time.
func _ready():
	eb.player_dimension_swap.connect(player_dimension_swap)

	var other_dimension = 2
	if dimension == 2:
		other_dimension = 1
		
	for body : CollisionObject2D in bodies:
		body.set_collision_layer_value(other_dimension + 3, false)
		body.set_collision_mask_value(other_dimension + 3, false)
		body.set_collision_layer_value(dimension + 3, true)
		body.set_collision_mask_value(dimension + 3, true)
	
	if is_all_dimensions:
		for body : CollisionObject2D in bodies:
			body.set_collision_layer_value(4, true)
			body.set_collision_mask_value(4, true)
			body.set_collision_layer_value(5, true)
			body.set_collision_mask_value(5, true)
			
	elif dimension != eb.player_dimension:
		swap_hidden()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func player_dimension_swap(player_dimension: int):
	if not is_all_dimensions:
		swap_hidden()
	

func swap_hidden():
	for body : CollisionObject2D in bodies:
		body.visible = !body.visible
	

func swap_dimension(new_dimension: int):
	if is_all_dimensions:
		return
		
	if not swap_cooldown_timer.is_stopped():
		return

	for body : CollisionObject2D in bodies:
		body.set_collision_layer_value(dimension + 3, false)
		body.set_collision_mask_value(dimension + 3, false)
		body.set_collision_layer_value(new_dimension + 3, true)
		body.set_collision_mask_value(new_dimension + 3, true)
	
		if body is RigidBody2D:
			body.linear_velocity = -1 * body.linear_velocity
			body.apply_central_impulse(body.mass * 200 * body.linear_velocity.normalized())
	
	dimension = new_dimension
	
	swap_hidden()
	
	swap_cooldown_timer.start()

		
	# TODO support player or other physics types?
	
