extends CharacterBody2D

@export var swap_cooldown_timer : Timer

@onready var eb = EventBus

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dimension = 1

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func swap_dimension(new_dimension: int):
	if not swap_cooldown_timer.is_stopped():
		return
	
	swap_cooldown_timer.start()
	
	dimension = new_dimension
	print("emitting player dimension swap")
	eb.player_dimension_swap.emit(new_dimension)

	velocity = -1 * velocity
	# TODO determine how to process inputs which would keep taking you back to same portal, add slight throw?
