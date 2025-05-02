class_name Character
extends CharacterBody2D

signal ability_requested(ability_name: String)
signal health_changed(current_health: int)

@export var max_health: int = 100
@export var current_health: int = max_health
@export var speed = 50 # Base movement speed (pixels/sec)
@export var ascension_tier: int = 0
@export var ascension_threshold: int = 1 # Number of kills to ascend to next tier

var can_move: bool = true

enum Team { RED = 1, BLUE = 2 }
var team_id = Team.RED # Default team value to be changed upon instantiation

var abilities: Dictionary = {
	"primary": {"cooldown": 1.5}
}
var ability_cooldowns: Dictionary = {}

@onready var sprite = $Sprite
@onready var animation_player = $AnimationPlayer
@onready var attack_area = $AttackArea
@onready var hurtbox = $Hurtbox
@onready var collision_shape = $CollisionShape2D
@onready var health_bar = $HealthBar

func _ready():
	current_health = max_health
	
	if get_parent().has_method("setup_camera"):
		health_bar.hide()
	
	for ability_name in abilities.keys():
		ability_cooldowns[ability_name] = Timer.new()
		ability_cooldowns[ability_name].wait_time = abilities[ability_name]["cooldown"]
		ability_cooldowns[ability_name].one_shot = true
		ability_cooldowns[ability_name].connect("timeout", Callable(self, "_on_cooldown_end").bind(ability_name))
		add_child(ability_cooldowns[ability_name])
	
	GameManager.register_unit(self, team_id)

func use_ability(ability_name: String):
	if ability_name in abilities:
		if ability_cooldowns[ability_name].is_stopped():
			can_move = false
			velocity = Vector2.ZERO
			call(ability_name)
			ability_cooldowns[ability_name].start()
		else:
			print(ability_name + " is on cooldown!")
	else:
		print("Ability '" + ability_name + "' not found!")

func _on_ability_end():
	can_move = true

func _on_cooldown_end(ability_name: String):
	print(ability_name + " is off cooldown!")

func move_unit(desired_direction: Vector2):
	# Normalize diagonal movement
	if desired_direction.length() > 0:
		desired_direction = desired_direction.normalized()
	
	if can_move:
		velocity = desired_direction * speed
	move_and_slide()

func die():
	collision_shape.set_deferred("disabled", true) # Disables collision on death
	queue_free()

# Saves the last y axis value of the character's velocity
var prev_y = 0;
func _process(_delta):
	handle_animations()

func handle_animations():
	if velocity.x < 0:
		sprite.flip_h = true
	if velocity.x > 0:
		sprite.flip_h = false
	
	if velocity.x != 0:
		sprite.play("walk_side")
		prev_y = 0
	elif velocity.y > 0:
		sprite.play("walk_forward")
		prev_y = 1
	elif velocity.y < 0:
		sprite.play("walk_up")
		prev_y = -1
	elif prev_y == -1:
		sprite.play("idle_up")
	else:
		sprite.play("idle_forward")

func get_ascension_tier() -> int:
	return ascension_tier

# This will need to be played with to make it work
func _on_death(killer):
	GameManager.register_kill(killer, self)
	GameManager.deregister_unit(self)

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_class("Hurtbox"):
		take_damage(body.damage)

func take_damage(amount: int):
	current_health = clamp(current_health - amount, 0, max_health)
	print("Character took", amount, "damage! Remaining HP:", current_health)
	health_changed.emit(current_health)
	if current_health <= 0:
		die()

func heal(amount: int):
	current_health = clamp(current_health + amount, 0, max_health)
	print("Character healed", amount, "health. New Health:", current_health)
	health_changed.emit(current_health)

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_class("CollisionShape2D"):
		body.take_damage(30)
	if body.is_in_group("enemies"):
		body.take_damage(30)
