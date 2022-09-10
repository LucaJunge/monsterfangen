extends Node

var MONSTERS := {}

func _ready() -> void:
	var monsters := _load_monsters()
	
	for monster in monsters:
		MONSTERS[monster.unique_id] = monster

func get_monster_data(unique_id: String) -> Monster:
	if not unique_id in MONSTERS:
		printerr("Trying to get nonexistent monster %s in monster database" % unique_id)
		return null
	
	return MONSTERS[unique_id]

func _load_monsters() -> Array:
	var monster_files := []
	var monsters_folder := "res://resources/monsters"
	
	var directory := Directory.new()
	var can_continue := directory.open(monsters_folder) == OK
	if not can_continue:
		print_debug('Could not open directory "%s"' % [monsters_folder])
		return monster_files
		
	# warning-ignore:return_value_discarded
	directory.list_dir_begin(true, true)
	var file_name := directory.get_next()
	while file_name != "":
		if file_name.get_extension() == "tres":
			monster_files.append(monsters_folder.plus_file(file_name))
		file_name = directory.get_next()
		
	var monster_resources := []
	for path in monster_files:
		# Loads the tres files into memory
		monster_resources.append(load(path))
	
	if OS.is_debug_build():
		var ids := []
		var bad_monsters := []
		
		for monster in monster_resources:
			if monster.unique_id in ids:
				bad_monsters.append(monster)
			else:
				ids.append(monster.unique_id)
				
		for monster in bad_monsters:
			printerr("Monster %s has a non-unique ID: %s" % [monster.display_name, monster.unique_id])
	
	return monster_resources
	
	
	
	
	
	
	
	
	
	
	
	
	
