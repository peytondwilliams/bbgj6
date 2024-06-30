extends Node2D

@export var linked_node : Node2D
@export var size = 2

var input_dict := {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func handle_logic_gate(value: bool, unique_id: int):
	input_dict[unique_id] = value
	
	if input_dict.size() == size:
		var all_true = true
		
		for key in input_dict:
			if not input_dict[key]:
				all_true = false
				
		if linked_node == null:
			print("null node")
			return
		if linked_node.has_method("switch_state"):
			linked_node.switch_state(all_true)
		elif linked_node.has_method("handle_logic_gate"):
			linked_node.handle_logic_gate(all_true, get_instance_id())

