tool
extends HBoxContainer

const PATH_MOUTHLIBRARIES :String= ""#res://addons/rhubarb_lipsync_importer/"
const FILENAME_MOUTHLIBRARIES :String= "mouthshape_libraries.ini"

var default_mouthtexture :PoolStringArray

var mouthLibraryDB :Dictionary= {}

onready var menuButton :MenuButton= $MenuButton
var popupMenu :PopupMenu

func _enter_tree() -> void:
	yield(get_tree(), "idle_frame")
	_load_default_mouthtexture_paths()
	load_mouthshape_library_file()

func _ready() -> void:
	if !is_inside_tree():
		yield(self, "tree_entered")
	yield(get_tree(), "idle_frame")
	
	popupMenu = menuButton.get_popup()
	_load_default_mouthtexture_paths()
	load_mouthshape_library_file()
	
	menuButton.update_PopupMenu_items()
	
	

func _load_default_mouthtexture_paths():
	var path_plugin :String= owner.path_plugin
	if path_plugin == "":
		path_plugin = "res://addons/rhubarb_lipsync_integration/"
	default_mouthtexture = PoolStringArray([
		path_plugin + "assets/lipsync default mouthshapes/rest.png",
		path_plugin + "assets/lipsync default mouthshapes/MBP.png",
		path_plugin + "assets/lipsync default mouthshapes/O.png",
		path_plugin + "assets/lipsync default mouthshapes/U.png",
		path_plugin + "assets/lipsync default mouthshapes/etc.png",
		path_plugin + "assets/lipsync default mouthshapes/FV.png",
		path_plugin + "assets/lipsync default mouthshapes/E.png",
		path_plugin + "assets/lipsync default mouthshapes/L.png",
		path_plugin + "assets/lipsync default mouthshapes/AI.png"
		])
	var f :File= File.new()
	if !f.file_exists(default_mouthtexture[0]):
		print("Error! Image doesn't exist at path ", default_mouthtexture[0])

func load_mouthshape_library_file():
	if !is_inside_tree():
		yield(self, "tree_entered")
		
	
#	if mouthLibraryDB != {}: mouthLibraryDB = {}
	create_new_mouthshape_library('default')
	var library_file :ConfigFile= ConfigFile.new()
	
	var err = library_file.load(owner.path_plugin + PATH_MOUTHLIBRARIES + FILENAME_MOUTHLIBRARIES)
	if err == OK:
		if !library_file.has_section('default'):
			save_mouthshape_library('default')
			
		for section in library_file.get_sections():
			mouthLibraryDB[section] = {
			'rest': library_file.get_value(section, 'rest', default_mouthtexture[0]), # need a default path value
			'MBP': library_file.get_value(section, 'MBP', default_mouthtexture[1]),
			'O': library_file.get_value(section, 'O', default_mouthtexture[2]),
			'U': library_file.get_value(section, 'U', default_mouthtexture[3]),
			'etc': library_file.get_value(section, 'etc', default_mouthtexture[4]),
			'FV': library_file.get_value(section, 'FV', default_mouthtexture[5]),
			'E': library_file.get_value(section, 'E', default_mouthtexture[6]),
			'L': library_file.get_value(section, 'L', default_mouthtexture[7]),
			'AI': library_file.get_value(section, 'AI', default_mouthtexture[8])
			}
		
		
	elif err == ERR_FILE_NOT_FOUND:
		save_mouthshape_library('default')

#Creates a new library in the library database with given name
func create_new_mouthshape_library(library :String):
	mouthLibraryDB[library] = {
	'rest': default_mouthtexture[0],
	'MBP': default_mouthtexture[1],
	'O': default_mouthtexture[2],
	'U': default_mouthtexture[3],
	'etc': default_mouthtexture[4],
	'FV': default_mouthtexture[5],
	'E': default_mouthtexture[6],
	'L': default_mouthtexture[7],
	'AI': default_mouthtexture[8]
	}

func delete_mouthshape_library(library :String):
	var library_file :ConfigFile= ConfigFile.new()
	var err = library_file.load(owner.path_plugin +PATH_MOUTHLIBRARIES + FILENAME_MOUTHLIBRARIES)
	if err == OK:
		if library_file.has_section(library):
			library_file.erase_section(library)
			library_file.save(owner.path_plugin +PATH_MOUTHLIBRARIES + FILENAME_MOUTHLIBRARIES)

func save_mouthshape_library(library :String):
	var library_file :ConfigFile= ConfigFile.new()
	var err = library_file.load(owner.path_plugin +PATH_MOUTHLIBRARIES + FILENAME_MOUTHLIBRARIES)
	if err == OK or err == ERR_FILE_NOT_FOUND:
		if library_file.has_section(library):
			pass
		
		for mouthshape in mouthLibraryDB[library]:
			library_file.set_value(library, mouthshape, mouthLibraryDB[library][mouthshape])
	
		library_file.save(owner.path_plugin +PATH_MOUTHLIBRARIES + FILENAME_MOUTHLIBRARIES)
