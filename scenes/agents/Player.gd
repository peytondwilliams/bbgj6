extends RigidBody2D

@export var body: RigidBody2D
@export var swap_cooldown_timer : Timer
@export var camera: Camera2D
@export var gun: Sprite2D
@export var feet_area: Area2D

@onready var PORTAL_PROJECTILE_PRELOAD = preload("res://scenes/objects/portal_projectile.tscn")
@onready var eb = EventBus

@export var spawned_portal : Node2D

const HORIZONTAL_MOVE_FORCE = 2000.0
const VERTICAL_MOVE_FORCE = -50000.0

const MOVE_FORCE = Vector2(HORIZONTAL_MOVE_FORCE, VERTICAL_MOVE_FORCE)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dimension = 1

var mirror_value = 1

var is_on_floor = true

func _ready():
	eb.spawn_portal.connect(spawn_portal_handler)

func _on_feet_area_2d_body_entered(body):
	is_on_floor = true

func _on_feet_area_2d_body_exited(body):
	if feet_area.get_overlapping_bodies().size() == 0:
		is_on_floor = false
	
func get_input_direction():
	var direction_vector = Vector2.ZERO
	if is_on_floor:
		if Input.is_action_pressed("ui_left"):
			direction_vector.x -= 1
		if Input.is_action_pressed("ui_right"):
			direction_vector.x += 1
		if Input.is_action_just_pressed("ui_up"):
			direction_vector.y += 1
	return direction_vector.normalized()
	

func _physics_process(delta):
	
	handle_portal_shoot()
	var input_direction = get_input_direction()
	
	var movement_force = input_direction * MOVE_FORCE * mirror_value
	apply_central_force(movement_force)

	
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
		
	print("new dimension for player: ", new_dimension)
	
	swap_cooldown_timer.start()
	
	for physics_body in [body, feet_area]:
		physics_body.set_collision_layer_value(dimension + 3, false)
		physics_body.set_collision_mask_value(dimension + 3, false)
		physics_body.set_collision_layer_value(new_dimension + 3, true)
		physics_body.set_collision_mask_value(new_dimension + 3, true)

	dimension = new_dimension
	eb.player_dimension_swap.emit(new_dimension)

	# velocity = -1 * velocity
	# TODO determine how to process inputs which would keep taking you back to same portal, add slight throw?
	
	mirror_value = -1 * mirror_value 
	camera.zoom.x = -1 * camera.zoom.x 
	
	return true

func spawn_portal_handler(new_portal: Node2D):
	if spawned_portal != null:
		spawned_portal.queue_free()
	spawned_portal = new_portal
	new_portal.set_dimension(dimension)
