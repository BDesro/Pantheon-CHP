extends CharacterBody2D

@export var max_health: int = 100
@export var speed = 200 # Base movement speed (pixels/sec)

# Define individual ability cooldowns
@export var ability_cooldowns: Dictionary = {
	"ability_1": 0.0,
	"ability_2": 0.0,
	"ability_3": 0.0,
	"ability_4": 0.0,
	"ability_5": 0.0,
	"ability_6": 0.0
}

# Track ability cooldown status
var ability_on_cd: Dictionary = {}

# Input-to-ability mapping (To be overridden in child nodes)
var ability_bindings: Dictionary = {
	"ability_1": "lmb",
	"ability_2": "rmb",
	"ability_3": "space",
	"ability_4": "shift",
	"ability_5": "e",
	"ability_6": "q"
}

# Set initial current health to maximum
var current_health = max_health

func _ready():
	current_health = max_health # Ensure current health begins at max
	
	# Initialize cooldown states and timers for each ability
	for ability_name in ability_cooldowns.keys():
		ability_on_cd[ability_name] = false # Ensure all abilities start off cooldown
		
		# Create a timer for each ability
		var timer = Timer.new()
		timer.name = ability_name + "_CDTimer"
		timer.wait_time = ability_cooldowns[ability_name]
		timer.one_shot = true
		
		# Connect timer's timeout signal to the function
		timer.connect("timeout", Callable(self, "_on_cooldown_end"))
		# Store the ability name in the timer's metadata for reference
		timer.set_meta("ability_name", ability_name)
		
		add_child(timer)
	
func _physics_process(_delta):
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed;
	move_and_slide()
