class_name Character
extends CharacterBody2D

signal ability_requested(ability_name: String)

@export var max_health: int = 100
@export var speed = 50 # Base movement speed (pixels/sec)
@export var ascension_tier: int = 0
@export var ascension_threshold: int = 1 # Number of kills to ascend to next tier

var current_health = max_health
var abilities: Dictionary = {
	"primary": {"cooldown": 1.5}
}
var ability_cooldowns: Dictionary = {}

func _ready():
	for ability_name in abilities.keys():
		ability_cooldowns[ability_name] = Timer.new()
		ability_cooldowns[ability_name].wait_time = abilities[ability_name]["cooldown"]
		ability_cooldowns[ability_name].one_shot = true
		ability_cooldowns[ability_name].connect("timeout", Callable(self, "_on_cooldown_end").bind(ability_name))
		add_child(ability_cooldowns[ability_name])

func use_ability(ability_name: String):
	if ability_name in abilities:
		if ability_cooldowns[ability_name].is_stopped():
			call(ability_name)
			ability_cooldowns[ability_name].start()
		else:
			print(ability_name + " is on cooldown!")
	else:
		print("Ability '" + ability_name + "' not found!")

func _on_cooldown_end(ability_name: String):
	print(ability_name + " is off cooldown!")

func primary():
	print("Primary used")

func move_unit(desired_direction: Vector2):
	velocity = desired_direction * speed
	move_and_slide()

# Saves the last y axis value of the character's velocity
var prev_y = 0;
func _process(_delta):
	handle_animations()

func handle_animations():
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

func get_ascension_tier() -> int:
	return ascension_tier
