extends Control

var starting_dir :String= "res://"

var current_dir :String
var Dir :Directory
var dir_files :PoolStringArray= PoolStringArray()
var dir_folders :PoolStringArray= PoolStringArray()

func _ready() -> void:
	# Get folders and files
	
	current_dir = starting_dir
	Dir = Directory.new()
	if Dir.open(current_dir) == OK:
		Dir.list_dir_begin()
		var file_name = Dir.get_next()
		while file_name != "":
			if !Dir.current_is_dir():
				dir_files.append(file_name)
			else:
				dir_folders.append(file_name)
			file_name = Dir.get_next()
	
