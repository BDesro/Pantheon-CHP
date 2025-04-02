class_name Player
extends BaseController


var camera: Camera2D

func _ready():
	super._ready()
	
	# Initialize camera and check ability bindings
	setup_camera()
	ensure_input_actions_exist()

func _process(_delta):
	handle_input()

func handle_input():
	if not character:
		return
	
	# Point character toward mouse
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - character.global_position).normalized()
	
	character.rotation = direction.angle() + PI / 2
	
	#var right_direction = direction.rotated(PI / 2)  # Perpendicular for strafing
#
	## Get input vector
	#var input_vector = Vector2.ZERO
	#if Input.is_action_pressed("move_forward"):  # "W" moves toward the mouse
		#input_vector += direction
	#if Input.is_action_pressed("move_backward"):  # "S" moves opposite the mouse
		#input_vector -= direction
	#if Input.is_action_pressed("move_left"):  # "A" strafes left
		#input_vector -= right_direction
	#if Input.is_action_pressed("move_right"):  # "D" strafes right
		#input_vector += right_direction
	#
	#character.move_unit(input_vector)
	
	# Basic movement
	var input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	character.move_unit(input_direction)
	camera.global_position = character.global_position
	
	if Input.is_action_just_pressed("primary"):
		character.use_ability("primary")

func setup_camera():
	camera = $Camera2D
	camera.make_current() # Camera follows player
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 10.0

func ensure_input_actions_exist():
	var actions = [
		["move_right", KEY_D],
		["move_left", KEY_A],
		["move_forward", KEY_W],
		["move_backward", KEY_S],
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
