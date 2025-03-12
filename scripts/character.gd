class_name Character
extends CharacterBody2D

@export var max_health: int = 100
# Set initial current health to maximum
@export var current_health = max_health
@export var speed = 50 # Base movement speed (pixels/sec)

@export var ascension_tier: int = 0
@export var ascension_threshold: int = 1 # Number of kills to ascend to next tier

func get_ascension_tier() -> int:
	return ascension_tier


# Bounds for character position
var min_x = -20 * 16
var max_x = 19 * 16
var min_y = -20 * 16
var max_y = 19 * 16

# Distinguish between Player and AI control
enum ControlState { Player, AI }
var control_state: ControlState = ControlState.Player

# Saves the last y axis value of the character's velocity
var prev_y = 0;

## Define individual ability cooldowns
#@export var ability_cooldowns: Dictionary = {
	#"ability_1": 1.0,
	#"ability_2": 1.0,
	#"ability_3": 1.0,
	#"ability_4": 1.0,
	#"ability_5": 1.0,
	#"ability_6": 1.0
#}

# Track ability cooldown status
var ability_on_cd: Dictionary = {}

## Input-to-ability mapping (To be overridden in child nodes)
#var ability_bindings: Dictionary = {
	#"ability_1": "lmb",
	#"ability_2": "rmb",
	#"ability_3": "space",
	#"ability_4": "shift",
	#"ability_5": "e",
	#"ability_6": "q"
#}

func _ready():
	current_health = max_health # Ensure current health begins at max
	
	## Initialize cooldown states and timers for each ability
	#for ability_name in ability_cooldowns.keys():
		#ability_on_cd[ability_name] = false # Ensure all abilities start off cooldown
		#
		## Create a timer for each ability
		#var timer = Timer.new()
		#timer.name = ability_name + "_CDTimer"
		#timer.wait_time = ability_cooldowns[ability_name]
		#timer.one_shot = true
		#
		## Connect timer's timeout signal to the function
		#timer.connect("timeout", Callable(self, "_on_cooldown_end"))
		## Store the ability name in the timer's metadata for reference
		#timer.set_meta("ability_name", ability_name)
		
		#add_child(timer)

func move_unit(desired_direction: Vector2):
	velocity = desired_direction * speed
	move_and_slide()

func use_ability(ability_name: String):
	if has_method(ability_name):
		call(ability_name)
	else:
		print("Ability function '" + ability_name + "' does not exist")

func _process(_delta):
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
	if velocity.x != 0:
		$AnimatedSprite2D.play("walk_side")
		prev_y = 0
	elif velocity.y > 0:
		$AnimatedSprite2D.play("walk_forward")
		prev_y = 1
	elif velocity.y < 0:
		$AnimatedSprite2D.play("walk_up")
		prev_y = -1
	elif prev_y == -1:
		$AnimatedSprite2D.play("idle_up")
	else:
		$AnimatedSprite2D.play("idle_forward")
