extends Node2D

@export var anim_player : AnimationPlayer
@export var detection_area : Area2D
@export var button : AnimatableBody2D

@export var linked_node : Node2D

var held = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func switch_state(state: bool):
	held = state
	if linked_node != null and linked_node.has_method("switch_state"):
		linked_node.switch_state(state)
	else:
		print("linked node is null or doesnt have switch_state function!")

func _on_detection_2d_body_entered(body):
	if detection_area.get_overlapping_bodies().size() <= 1:
		anim_player.play("press_down")
		switch_state(true)

func _on_detection_2d_body_exited(body):
	if detection_area.get_overlapping_bodies().size() == 0:
		anim_player.play("press_up")
		switch_state(false)

func get_dimension_handler():
	return $DimensionHandler
