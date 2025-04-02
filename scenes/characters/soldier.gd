extends Character
class_name Soldier

func _process(_delta):
	handle_animations()

func handle_animations():
	if velocity.x != 0 or velocity.y != 0:
		sprite.play("walk")
	else:
		sprite.play("idle")
