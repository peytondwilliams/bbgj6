extends Node

signal player_dimension_swap(dimension: int)
signal spawn_portal(portal: Node2D)

var player_dimension: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	player_dimension_swap.connect(set_player_dimension)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("debug_restart_game"):
		player_dimension = 1

func set_player_dimension(dimension: int):
	player_dimension = dimension
