extends Area2D

@onready var eb = EventBus

var to_dimension := 2
var in_dimension := 1

# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	
	if body.has_method("get_dimension_handler"):
		print("swapping box to dimension:", to_dimension)
		body.get_dimension_handler().swap_dimension(to_dimension)
	elif body.has_method("swap_dimension"):
		body.swap_dimension(to_dimension)
		
		var temp_dimension = to_dimension
		to_dimension = in_dimension
		in_dimension = temp_dimension
