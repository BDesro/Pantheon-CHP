extends Node2D

class_name Player

# Reference to current character and camera
var current_character: Character
var camera: Camera2D

func _ready():
	# Initialize character and camera
	current_character = $Character
	camera = $Camera2D

func _process(_delta):
	handle_input()
	
	if current_character:
		camera.global_position = current_character.global_position

func handle_input():
	if not current_character:
		return
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	current_character.move_unit(input_direction)
