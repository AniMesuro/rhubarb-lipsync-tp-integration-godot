tool
extends Control

var starting_dir :String= "res://"

var current_file :String= "" setget _set_current_file
var current_dir :String setget _set_current_dir
var dir_files :PoolStringArray= PoolStringArray()
var dir_folders :PoolStringArray= PoolStringArray()

var filters :PoolStringArray= PoolStringArray(['png','jpg'])
var current_filter :String= "" setget _set_current_filter

func _ready() -> void:
	current_dir = starting_dir
	_list_files()
	
	yield(get_tree(), "idle_frame")
	
	# Hacky way to get anchors to update properly.
	rect_size = rect_size+Vector2(1,1)
	$Panel/RectHandlerContainer.handler_size = $Panel/RectHandlerContainer.handler_size
	

var filesystem_access :int
func setup(access :int):
	filesystem_access = access
	

func _set_current_dir(new_dir :String):
	if current_dir.get_base_dir() == new_dir.get_base_dir():
		$"Panel/Margin/VBox/PathHBox/LineEdit".text = current_dir
		return
#	var Dir :Directory= Directory.new()
	
	if !new_dir.ends_with('/'):
		current_dir = new_dir.get_base_dir()+'/'
	else:
		current_dir = new_dir
	_list_files()
	$"Panel/Margin/VBox/PathHBox/LineEdit".text = current_dir
	self.current_file = ""

func _set_current_file(new_file :String):
	current_file = new_file
	$"Panel/Margin/VBox/FileHBox/LineEdit".text = current_file

func _set_current_filter(new_filter :String):
	if current_filter == new_filter:
		return
	
	current_filter = new_filter
	$"Panel/Margin/VBox/FilePanel/ScrollContainer/FileContainer".update_file_list()
	if current_filter == "*": # All filters
		pass

func _list_files():
	var Dir :Directory
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
	$"Panel/Margin/VBox/FilePanel/ScrollContainer/FileContainer".update_file_list()
