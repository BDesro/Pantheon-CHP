extends Node

@onready var characters: Dictionary = {}

const CHARACTERS_PATH = "res://scenes/characters/"

signal characters_loaded

func _ready():
	load_character_scenes()

func load_character_scenes():
	var dir = DirAccess.open(CHARACTERS_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var paths_to_check = []
		
		while file_name != "":
			if file_name.ends_with(".tscn"):
				var scene_path = CHARACTERS_PATH + file_name
				ResourceLoader.load_threaded_request(scene_path)
				paths_to_check.append(scene_path)
			
			file_name = dir.get_next()
		
		# Wait until all loads are complete
		while true:
			var all_loaded = true
			for path in paths_to_check:
				if ResourceLoader.load_threaded_get_status(path) != ResourceLoader.THREAD_LOAD_LOADED:
					all_loaded = false
					break
			if all_loaded:
				break
			await get_tree().process_frame
		
		finalize_character_load()
	else:
		push_error("Error: Could not access character directory!")

func finalize_character_load():
	var dir = DirAccess.open(CHARACTERS_PATH)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.ends_with(".tscn"):
				var scene_path = CHARACTERS_PATH + file_name
				var scene = ResourceLoader.load_threaded_get(scene_path)
				
				if scene is PackedScene:
					var instance = scene.instantiate()
					
					if instance.has_method("get_ascension_tier"):
						var tier = instance.get_ascension_tier()
						characters[tier] = scene
					
					instance.queue_free()
			file_name = dir.get_next()
		
	sort_characters()
	characters_loaded.emit() # Emits signal in case UI/other nodes need to react

func sort_characters():
	var sorted_keys = characters.keys()
	sorted_keys.sort()
	
	var sorted_characters = {}
	for key in sorted_keys:
		sorted_characters[key] = characters[key]
	
	characters = sorted_characters

func get_next_character(current_tier: int) -> PackedScene:
	var tiers = characters.keys()
	var index = tiers.find(current_tier)
	
	if index != -1 and index < tiers.size() - 1:
		return characters[tiers[index + 1]]
	return null # No higher tier available

func get_prev_character(current_tier: int) -> PackedScene:
	var tiers = characters.keys()
	var index = tiers.find(current_tier)
	
	if index > 0:
		return characters[tiers[index - 1]]
	return null # No lower tier available
