extends CanvasLayer

# Notifies the Main node that the button has been pressed
signal start_game

@onready var player = get_parent() as Player
@onready var health_bar = $HealthBar

func _ready():
	if player:
		if player.character:
			health_bar.front_bar.max_value = player.character.max_health
		else:
			player.connect("character_loaded", Callable(self, "_on_character_loaded"))

func _on_character_loaded(max_health):
	health_bar.set_max_health(max_health)

# Temporarily shows a message on the screen
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	
	$Message.text = "Pantheon"
	$Message.show()
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)

func _on_health_down_button_pressed():
	$HealthBar.set_health($HealthBar.front_bar.value - 20)

func _on_health_up_button_pressed():
	$HealthBar.set_health($HealthBar.front_bar.value + 20)

func _on_message_timer_timeout():
	$Message.hide()

func _process(delta: float) -> void:
	$Message.hide()
