extends Area2D

@export var linked_node: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interact():
	# TODO sound effect
	if linked_node != null and linked_node.has_method("switch_state"):
		linked_node.switch_state(true)
	else:
		print("linked node is null or doesnt have switch_state function!")

func get_dimension_handler():
	return $DimensionHandler
