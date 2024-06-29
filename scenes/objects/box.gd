extends RigidBody2D

@onready var eb = EventBus

@export var swap_cooldown_timer: Timer

@export var dimension = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	eb.player_dimension_swap.connect(player_dimension_swap)
	
	if dimension != 1:
		swap_hidden()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func player_dimension_swap(player_dimension: int):
	swap_hidden()
	

func swap_hidden():
	visible = !visible
	set_collision_mask_value(3, !get_collision_mask_value(3))
	

func swap_dimension(new_dimension: int):
	if not swap_cooldown_timer.is_stopped():
		return
		
	set_collision_layer_value(dimension + 3, false)
	set_collision_mask_value(dimension + 3, false)
	set_collision_layer_value(new_dimension + 3, true)
	set_collision_mask_value(new_dimension + 3, true)
	
	dimension = new_dimension
	
	swap_hidden()
	
	swap_cooldown_timer.start()
	
	linear_velocity = -1 * linear_velocity
	
