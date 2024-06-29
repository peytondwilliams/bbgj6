extends Node2D

@export var state := false # false is closed, true is open
@export var anim_player: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func switch_state(new_state: bool):
	if state != new_state:
		var anim_start_time := 0.0
		if anim_player.is_playing():
			anim_start_time = 0.7 - anim_player.current_animation_position
		
		if new_state:
			anim_player.play("open")	
		else:
			anim_player.play("close")
			
		anim_player.seek(anim_start_time, true)
	
		state = new_state
	
		
