extends Node

const scene_ordering = [
	"Menu",
	"Level1-Box",
	"Level2-Platform",
	"EndScreen"
]

const scene_name_to_file_map = {
	"Menu": "res://scenes/menu/menu.tscn",
	"Level1-Box": "res://scenes/levels/level_1_box.tscn",
	"Level2-Platform": "res://scenes/levels/level_2_platform.tscn",
	"EndScreen": "res://scenes/menu/end_screen.tscn",
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func restart_cur_scene():
	get_tree().reload_current_scene()
	
func unregistered_scene_error(scene_name):
	print("Scene ", scene_name, " is not registered.")
	Game.change_scene_to_file("res://scenes/menu/end_screen.tscn")

func load_next_scene():
	var cur_scene_name = get_tree().current_scene.name
	var cur_scene_idx = scene_ordering.find(cur_scene_name)
	if cur_scene_idx == -1:
		unregistered_scene_error(cur_scene_name)
		
	var next_scene = scene_ordering[cur_scene_idx + 1]
	var next_scene_file = scene_name_to_file_map[next_scene]
	if next_scene_file == null:
		unregistered_scene_error(next_scene)
		
	Game.change_scene_to_file(next_scene_file)
	
