extends Control

@onready var front_bar: ProgressBar = $GreenBar
@onready var back_bar: ProgressBar = $YellowBar

var delay_timer := 0.0
var damage_lerp_speed := 0.5 # Higher = yellow catches up faster

func set_health(new_health: float):
	front_bar.value = clamp(new_health, 0, 100)
	delay_timer = 0.4 # Wait 0.4 seconds before yellow starts to follow
	
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
