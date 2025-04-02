extends Node

var units := {} # Key: unit_id, Value: unit reference
var unit_teams := {1: [], 2: []} # Units stored by team
var team_scores := {1: 0, 2: 0} # Tracks team kills/points
var ascension_progress := {} # Track ascension thresholds for all units

func register_unit(unit, team_id):
	units[unit.get_instance_id()] = unit
	unit_teams[team_id].append(unit)
	ascension_progress[unit.get_instance_id()] = 0

func deregister_unit(unit):
	var unit_id = unit.get_instance_id()
	if units.has(unit_id):
		var team_id = unit.team_id
		unit_teams[team_id].erase(unit)
		units.erase(unit_id)
		ascension_progress.erase(unit_id)

func get_unit_by_id(unit_id):
	if units.has(unit_id):
		return units[unit_id]
	return null

func register_kill(killer, victim):
	if not killer or not victim:
		return
	var killer_id = killer.get_instance_id()
	var victim_id = victim.get_instance_id()
	
	# Increment team score
	var killer_team = killer.team_id
	team_scores[killer_team] += 1
	
	# Track ascension progress
	if ascension_progress.has(killer_id):
		ascension_progress[killer_id] += 1
	
	# Check for ascension
	check_ascension(killer, ascension_progress[killer_id])

func check_ascension(unit, kills):
	if kills >= unit.ascension_threshold:
		unit.ascend()
		ascension_progress[unit.get_instance_id()] = 0 # Reset kills after ascension

func get_team(unit):
	if unit and units.has(unit.get_instance_id()):
		return unit.team_id
	return -1

func get_team_score(team_id):
	return team_scores.get(team_id, 0)

# Reset match state for a new game
func reset_game():
	units.clear()
	unit_teams = {1: [], 2: []}
	team_scores = {1: 0, 2: 0}
	ascension_progress.clear()
