extends Character
class_name Soldier



func _ready():
	max_health = 100
	abilities["primary"]["cooldown"] = 1.0
	super._ready()

func _process(_delta):
	handle_animations()

func handle_animations():
	if $AnimationPlayer.is_playing():
		return
	
	if velocity.x != 0 or velocity.y != 0:
		$Sprite.play("walk")
	else:
		$Sprite.play("idle")

func primary():
	$AnimationPlayer.play("spear_thrust")

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(30)
