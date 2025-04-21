extends Control

@onready var front_bar: ProgressBar = $GreenBar
@onready var back_bar: ProgressBar = $YellowBar

var max_health: int = 100

var delay_timer := 0.0
var damage_lerp_speed := 0.5 # Higher = yellow catches up faster

func set_max_health(new_max: int):
	max_health = new_max
	front_bar.max_value = max_health
	back_bar.max_value = max_health
	front_bar.value = front_bar.max_value

func set_health(new_health: int):
	var clamped_health = clamp(new_health, 0, max_health)
	
	if clamped_health < front_bar.value:
		# Took damage
		front_bar.value = clamped_health
		delay_timer = 0.4  # Wait 0.4 seconds before yellow starts to follow
	elif clamped_health > front_bar.value:
		# Healed
		front_bar.value = clamped_health
		back_bar.value = clamped_health

func _process(delta: float) -> void:
	if delay_timer > 0:
		delay_timer -= delta
	else:
		if back_bar.value > front_bar.value:
			back_bar.value = lerp(back_bar.value, front_bar.value, damage_lerp_speed)
		
			if abs(back_bar.value - front_bar.value) <= 1:
				back_bar.value = front_bar.value
		else:
			back_bar.value = front_bar.value
