extends CharacterBody2D

@onready var PORTAL_PRELOAD = preload("res://scenes/objects/portal.tscn")

@onready var eb = EventBus

const SPEED = 12.0

var direction := Vector2(1, 1)

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):

	var collision := move_and_collide(SPEED * direction)
	if collision:
	
		var col_pos := collision.get_position()
		var col_normal := collision.get_normal()
		var col_collider := collision.get_collider()
		
		if col_collider.has_method("is_portalable") or true: # TODO remove true
			var portal = PORTAL_PRELOAD.instantiate()
			get_parent().add_child(portal)
			portal.global_position = col_pos
			eb.spawn_portal.emit(portal)
			portal.rotate(col_normal.angle())
			
		queue_free()

