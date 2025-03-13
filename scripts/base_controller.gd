class_name BaseController
extends Node2D

@export var controller_name: String 

@export var character: Character

# ------------------------------------------------------------------------------
# Calls load_character_hierarchy and sets the current character
# to the one at index 0 in the array.
func _ready():
	if character:
		remove_child(character)
		character.queue_free()
	
	if CharacterManager.characters.is_empty():
		CharacterManager.characters_loaded.connect(_on_characters_loaded)
	else:
		var new_character = CharacterManager.characters[0]
		if new_character:
			character = new_character.instantiate()
			add_child(character)
	
func _on_characters_loaded():
	var new_character = CharacterManager.characters[0]
	if new_character:
		character = new_character.instantiate()
		add_child(character)

# ------------------------------------------------------------------------------
# Used by ascend() and descend() to change the character
#  assigned to this controller based on the current index
#  in the hierarchy
func swap_character(tier: int):
	if not CharacterManager.characters.has(tier):
		print("ERROR: No character found for tier", tier)
		return
	
	var new_character_scene = CharacterManager.characters[tier]
	
	var new_character = null
	if new_character_scene:
		new_character = new_character_scene.instantiate()
		
		if character:
			new_character.global_position = character.global_position
			character.queue_free()
		
		character = new_character
		add_child(character)
		
		print(controller_name, "Character Swap successful!")

# ------------------------------------------------------------------------------
# Sets current character to the next highest in the hierarchy (if able)
func ascend():
	var next_tier = character.ascension_tier + 1
	if CharacterManager.characters.has(next_tier):
		swap_character(next_tier)

# ------------------------------------------------------------------------------
# Sets current character to the next lowest in the hierarchy (if able)
func descend():
	var prev_tier = character.ascension_tier - 1
	if CharacterManager.characters.has(prev_tier):
		swap_character(prev_tier)
