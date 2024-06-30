extends Sprite2D

const FORCE = 1000.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	var direction_vector = Vector2(cos(rotation), sin(rotation)).rotated(deg_to_rad(-90))
	if body is RigidBody2D:
		body.apply_central_impulse(direction_vector * FORCE)
