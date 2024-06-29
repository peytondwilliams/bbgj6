extends CharacterBody2D

@export var swap_cooldown_timer : Timer
@export var camera: Camera2D
@export var gun: Sprite2D

@onready var PORTAL_PROJECTILE_PRELOAD = preload("res://scenes/objects/portal_projectile.tscn")
@onready var eb = EventBus

@export var spawned_portal : Node2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dimension = 1

var mirror_value = 1

func _ready():
	eb.spawn_portal.connect(spawn_portal_handler)
	

func _physics_process(delta):
	
			
	handle_portal_shoot()
	
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
		velocity.x = direction * SPEED * mirror_value
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	

	
func handle_portal_shoot():
	
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.x < global_position.x and gun.position.x > 0:
		gun.position.x = -1 * gun.position.x
	elif mouse_pos.x > global_position.x and gun.position.x < 0:
		gun.position.x = -1 * gun.position.x
	
	gun.look_at(mouse_pos)
	
	if not Input.is_action_just_pressed("input_click"):
		return
		
	var portal_proj = PORTAL_PROJECTILE_PRELOAD.instantiate()
	get_parent().add_child(portal_proj)
	portal_proj.global_position = gun.global_position
	portal_proj.direction = Vector2.RIGHT.rotated(gun.rotation)
	portal_proj.set_collision_mask_value(dimension + 3, true)
	
func swap_dimension(new_dimension: int):
	if not swap_cooldown_timer.is_stopped():
		return false
	
	swap_cooldown_timer.start()
	
	dimension = new_dimension
	eb.player_dimension_swap.emit(new_dimension)

	velocity = -1 * velocity
	# TODO determine how to process inputs which would keep taking you back to same portal, add slight throw?
	
	mirror_value = -1 * mirror_value 
	camera.zoom.x = -1 * camera.zoom.x 
	
	return true

func spawn_portal_handler(new_portal: Node2D):
	if spawned_portal != null:
		spawned_portal.queue_free()
	spawned_portal = new_portal
