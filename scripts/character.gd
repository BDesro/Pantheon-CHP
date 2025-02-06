extends CharacterBody2D

@export var speed = 200 # (pixels/sec)
var screen_size # Size of game window

func _ready():
	screen_size = get_viewport_rect().size

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed;
	
func _physics_process(_delta):
	get_input()
	move_and_slide()
