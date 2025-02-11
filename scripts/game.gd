extends Node2D

var player_unit: Unit = null

func _ready():
	assign_player_control()

func assign_player_control():
	if player_unit:
		player_unit.set_control_state(Unit.ControlState.AI)
		
	player_unit = $TestUnit
	player_unit.set_control_state(Unit.ControlState.Player)
