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
	if linked_node == null:
		print("null node")
		return
	if linked_node.has_method("switch_state"):
		linked_node.switch_state(true)
	elif linked_node.has_method("handle_logic_gate"):
		linked_node.handle_logic_gate(true, get_instance_id())
	else:
		print("linked node  doesnt have switch_state or handle_logic_gate function!")

func get_dimension_handler():
	return $DimensionHandler
