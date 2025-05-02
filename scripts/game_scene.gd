extends Node2D

@onready var pause_menu = $PauseMenu
@onready var hud = $Player/HUD

func _ready():
	pause_menu.visible = false

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("Menu"):
		toggle_pause()

func toggle_pause():
	if Engine.is_editor_hint():
		return # prevent pausing while testing in editor
	
	var tree = get_tree()
	if tree.paused:
		tree.paused = false
		pause_menu.visible = false
		hud.visible = true
	else:
		tree.paused = true
		pause_menu.visible = true
		hud.visible = false


func _on_resume_button_pressed() -> void:
	toggle_pause()

func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
