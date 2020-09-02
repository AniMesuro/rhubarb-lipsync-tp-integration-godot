tool
extends Control

var starting_dir :String= "res://"

var current_dir :String setget _set_current_dir
var Dir :Directory
var dir_files :PoolStringArray= PoolStringArray()
var dir_folders :PoolStringArray= PoolStringArray()

var filters :PoolStringArray

func _ready() -> void:
	current_dir = starting_dir
	_list_files()
	
	yield(get_tree(), "idle_frame")
	rect_size = rect_size+Vector2(1000,1000)

func _set_current_dir(new_dir :String):
	current_dir = new_dir
	_list_files()
	$"Panel/VBox/PathHBox/LineEdit".text = current_dir

func _list_files():
	# Get folders and files
	dir_files = []
	dir_folders = []
	
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
	else:
		print('filepath not ok')
	$"Panel/VBox/FilePanel/ScrollContainer/FileContainer".update_file_list()
