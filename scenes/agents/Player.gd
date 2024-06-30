extends RigidBody2D

@export var body: RigidBody2D
@export var swap_cooldown_timer : Timer
@export var camera: Camera2D
@export var gun: Sprite2D
@export var feet_area: Area2D
@export var interact_area: Area2D
@export var pickup_area: Area2D

@onready var PORTAL_PROJECTILE_PRELOAD = preload("res://scenes/objects/portal_projectile.tscn")
@onready var eb = EventBus

@export var spawned_portal : Node2D

const GOAL_VELOCITY_FACTOR = 300
const ACCEL_FACTOR = 4000
const FORCE_FACTOR = 100
const VERTICAL_MOVE_IMPULSE = 500

const MAX_PICKUP_DIST = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var dimension = 1
var mirror_value = 1
var is_on_floor = true

var nearby_interact_area : Area2D = null

var curr_pickup_obj : RigidBody2D = null

func _ready():
	eb.spawn_portal.connect(spawn_portal_handler)

func _on_feet_area_2d_body_entered(body):
	is_on_floor = true

func _on_feet_area_2d_body_exited(body):
	if feet_area.get_overlapping_bodies().size() == 0:
		is_on_floor = false
	
func get_input_direction():
	if Input.is_action_pressed("ui_left"):
		return Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		return Vector2.RIGHT
	return Vector2.ZERO
	

func _physics_process(delta):
	
	if Input.is_action_just_pressed("input_interact") and nearby_interact_area != null:
		nearby_interact_area.interact()
	
	handle_portal_shoot()
	
	# Moving logic below
	
	var air_factor = 1.0
	
	if not is_on_floor:
		air_factor = 0.07
	
	var input_direction = get_input_direction()
	
	var moving_plat = null
	for feet_body in feet_area.get_overlapping_bodies():
		if feet_body.is_in_group("platform"):
			moving_plat = feet_body
			break
			
		
	var goal_velocity = input_direction * GOAL_VELOCITY_FACTOR * mirror_value
	
	if moving_plat != null:
		goal_velocity += moving_plat.get_parent().get_velocity() 
	
	var horz_velocity = Vector2(linear_velocity.x, 0)

	var dot = goal_velocity.normalized().dot(horz_velocity.normalized())
	var factor = 1
	if dot < 0:
		factor -= dot

	var new_velocity = horz_velocity.move_toward(goal_velocity, ACCEL_FACTOR * factor * delta)
	var needed_accel = ((new_velocity - horz_velocity) / delta)

	var moving_plat_factor = 1

	apply_central_force(needed_accel * mass * air_factor * moving_plat_factor)
		
	apply_central_force(Vector2.DOWN * 9.8 * mass * FORCE_FACTOR)
	
	if Input.is_action_just_pressed("ui_up") and is_on_floor:
		apply_central_impulse(Vector2.UP * VERTICAL_MOVE_IMPULSE)
	
	#var movement_force = input_direction * MOVE_FORCE * mirror_value
	#apply_central_force(movement_force)

	
func handle_portal_shoot():
	
	var mouse_pos = get_global_mouse_position()
	var vector_to_mouse_gun = mouse_pos - global_position
	vector_to_mouse_gun = vector_to_mouse_gun.normalized() * MAX_PICKUP_DIST
	gun.global_position = global_position + vector_to_mouse_gun
	
	gun.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("input_click"):	
		var portal_proj = PORTAL_PROJECTILE_PRELOAD.instantiate()
		get_parent().add_child(portal_proj)
		portal_proj.global_position = gun.global_position
		portal_proj.direction = Vector2.RIGHT.rotated(gun.rotation)
		portal_proj.set_collision_mask_value(dimension + 3, true)
		
		if spawned_portal != null:
			spawned_portal.queue_free()
			spawned_portal = null
			

			
	if Input.is_action_pressed("input_right_click"):
		var vector_to_mouse = mouse_pos - global_position
		vector_to_mouse = vector_to_mouse.normalized() * MAX_PICKUP_DIST
		pickup_area.global_position = global_position + vector_to_mouse
		
		var closest_pickup_obj = null
		for pickup_body in pickup_area.get_overlapping_bodies():
			if pickup_body.is_in_group("pickup"):
				if closest_pickup_obj == null:
					closest_pickup_obj = pickup_body
				elif (global_position - closest_pickup_obj.global_position).length() > (global_position - pickup_body.global_position):
					closest_pickup_obj = pickup_body
					
		if closest_pickup_obj == null:
			if curr_pickup_obj != null:
				closest_pickup_obj = curr_pickup_obj
			else:
				return
			
		if closest_pickup_obj is RigidBody2D:
			var MAX_PICKUP_FORCE = 5000
			var diff_vec = (pickup_area.global_position - closest_pickup_obj.global_position)
			var new_force = diff_vec * 100
			if new_force.length() > MAX_PICKUP_FORCE:
				new_force = new_force.normalized() * MAX_PICKUP_FORCE
			closest_pickup_obj.apply_central_force(new_force)
			curr_pickup_obj = closest_pickup_obj

	if Input.is_action_just_released("input_right_click"):
		curr_pickup_obj = null
	
func swap_dimension(new_dimension: int):
	if not swap_cooldown_timer.is_stopped():
		return false
		
	print("new dimension for player: ", new_dimension)
	
	swap_cooldown_timer.start()
	
	for physics_body in [body, feet_area, interact_area, pickup_area]:
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

func _on_interact_area_2d_area_entered(area):
	if area.is_in_group("interactable"):
		print("nearby interact")
		nearby_interact_area = area

func _on_interact_area_2d_area_exited(area):
	if area.is_in_group("interactable"):
		nearby_interact_area = null
