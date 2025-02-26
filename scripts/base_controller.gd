class_name BaseController
extends Node2D

@export var controller_name: String 
@export var cur_character: Character
@export var character_hierarchy: Array[PackedScene] = [] # Ordered list of Character ascension tiers

var character_index: int = 0 # Tracks current ascension tier

# ------------------------------------------------------------------------------
# Calls load_character_hierarchy and sets the current character
# to the one at index 0 in the array.
func _ready():
	print("made it to base controller")
	load_character_hierarchy()
	
	cur_character = character_hierarchy[0].instantiate() as Character
	if cur_character:
		add_child(cur_character)
		character_index = get_character_index(cur_character)

# ------------------------------------------------------------------------------
# Populates the character hierarchy with all available Characters
#  listed in the Characters folder. 
#
# Also makes sure the Characters are properly ordered by their
#  ascension tiers for smooth ascend/descend calls
# 
# Fully encapsulated from BaseController implementations
func load_character_hierarchy():
	# Access characters in folder
	var char_folder = "res://scenes/Characters/"
	var dir = DirAccess.open(char_folder)
	print("Opened character folder")
	
	if dir:
		var files = dir.get_files()
		var temp_list = []
		
		# load characters as PackedScenes while populating the temporary
		# list so they can be sorted.
		for file in files:
			var scene_path = char_folder + file
			var packed_scene = load(scene_path) as PackedScene
			if packed_scene:
				var temp_instance = packed_scene.instantiate() as Character
				if temp_instance:
					temp_list.append({"scene": packed_scene, "tier": temp_instance.ascension_tier})
					temp_instance.queue_free()
		
		# sort by ascension tier
		temp_list.sort_custom(func(a,b): return a["tier"] < b["tier"])
		
		# store Character scenes in sorted order as PackedScenes
		for entry in temp_list:
			character_hierarchy.append(entry["scene"])

# ------------------------------------------------------------------------------
# Returns the index of the given Character by matching its
#  ascension tier to that of its designated spot in the 
#  character hierarchy. 
#
# (MAY SIMPLIFY LATER)
func get_character_index(character: Character) -> int:
	for i in range(character_hierarchy.size()):
		var temp_instance = character_hierarchy[i].instantiate() as Character
		if temp_instance and temp_instance.ascension_tier == character.ascension_tier:
			temp_instance.queue_free()
			return i
		temp_instance.queue_free()
	return 0 # Defaults to first character

# ------------------------------------------------------------------------------
# Used by ascend() and descend() to change the character
#  assigned to this controller based on the current index
#  in the hierarchy
func swap_character(new_index: int):
	if new_index < 0 or new_index >= character_hierarchy.size():
		return # Out of bounds protection
		
	if cur_character:
		remove_child(cur_character)
		cur_character.queue_free()
	
	character_index = new_index
	cur_character = character_hierarchy[character_index].instantiate() as Character
	add_child(cur_character)

# ------------------------------------------------------------------------------
# Sets current character to the next highest in the hierarchy (if able)
func ascend():
	if character_index < character_hierarchy.size() - 1:
		swap_character(character_index + 1)
		# print(controller_name, " Ascended to: ", cur_character.name)

# ------------------------------------------------------------------------------
# Sets current character to the next lowest in the hierarchy (if able)
func descend():
	if character_index > 0:
		swap_character(character_index - 1)
		# print(controller_name, " Descended to:", cur_character.name)
