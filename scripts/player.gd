class_name Player
extends BaseController


var camera: Camera2D

func _ready():
	super._ready()
	print("Made it to player")
	# Initialize camera and check ability bindings
	setup_camera()
	ensure_input_actions_exist()

func _process(_delta):
	handle_input()

func handle_input():
	if not cur_character:
		return
	
	# Basic movement
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	cur_character.move_unit(input_direction)
	camera.global_position = cur_character.global_position
	

func setup_camera():
	camera = $Camera2D
	camera.make_current() # Camera follows player
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 10.0

func ensure_input_actions_exist():
	var actions = [
		["move_right", KEY_D],
		["move_left", KEY_A],
		["move_up", KEY_W],
		["move_down", KEY_S],
		["primary", MOUSE_BUTTON_LEFT],
		["secondary", MOUSE_BUTTON_RIGHT],
		["dash_dodge", KEY_SPACE],
		["offense_ability", KEY_SHIFT],
		["defense_ability", KEY_E],
		["all_in_ability", KEY_Q]
	]

	for pair in actions:
		var action = pair[0]
		var key = pair[1]
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			var event = InputEventKey.new()
			event.keycode = key 
			InputMap.action_add_event(action, event)
