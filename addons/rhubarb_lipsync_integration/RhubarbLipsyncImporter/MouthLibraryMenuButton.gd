tool
extends MenuButton

var SCN_AskNamePopup :PackedScene

var current_library :String= "default" setget _set_current_library

onready var mouthLibraryHBox :HBoxContainer= get_parent()
var mouthTextures :VBoxContainer

onready var saveButton :TextureButton= $'../SaveButton'
onready var renameButton :TextureButton= $'../RenameButton'
onready var newButton :TextureButton= $'../NewButton'
onready var deleteButton :TextureButton= $'../DeleteButton'

onready var popupMenu :PopupMenu

func _ready() -> void:
	
	saveButton.connect("pressed", self, '_on_SaveButton_pressed')
	renameButton.connect("pressed", self, '_on_RenameButton_pressed')
	newButton.connect("pressed", self, '_on_NewButton_pressed')
	deleteButton.connect("pressed", self, '_on_DeleteButton_pressed')
	
	popupMenu = get_popup()
	popupMenu.connect("id_pressed", self, '_on_PopupMenu_item_selected')
	mouthTextures = owner.find_node('MouthTextures')
	
	if !is_inside_tree():
		yield(self, "tree_entered")
	SCN_AskNamePopup = load(owner.pluginInstance.path_plugin + "interface/AskNamePopup.tscn")
##################


func update_PopupMenu_items():
	popupMenu.clear()
	for library in mouthLibraryHBox.mouthLibraryDB:
		popupMenu.add_item(library)

func _set_current_library(value):
	current_library = value
	text = value

func _on_PopupMenu_item_selected(id :int):
	self.current_library = popupMenu.get_item_text(id)
#	updates mouthTextures panel with the textures from the selected library.
	mouthTextures.reload_mouthshape_textures(mouthLibraryHBox.mouthLibraryDB[current_library])
#	text = current_library

#func load_mouthshape_textures():
#	mouthLibraryHBox.mouthLibraryDB


func _on_SaveButton_pressed():
	mouthLibraryHBox.mouthLibraryDB[current_library] = {
	'rest': mouthTextures.mouthDB['rest'].resource_path,
	'MBP': mouthTextures.mouthDB['MBP'].resource_path,
	'O': mouthTextures.mouthDB['O'].resource_path,
	'U': mouthTextures.mouthDB['U'].resource_path,
	'etc': mouthTextures.mouthDB['etc'].resource_path,
	'FV': mouthTextures.mouthDB['FV'].resource_path,
	'E': mouthTextures.mouthDB['E'].resource_path,
	'L': mouthTextures.mouthDB['L'].resource_path,
	'AI': mouthTextures.mouthDB['AI'].resource_path
	}
	
	mouthLibraryHBox.save_mouthshape_library(current_library)
	
func _on_RenameButton_pressed():
	if current_library == 'default':
		return
	var askNamePopup = ask_for_name()
	var library_name :String= ""
	
	yield(askNamePopup, 'name_settled')
	library_name = askNamePopup.new_name
	askNamePopup.queue_free()
	
	if !library_name.is_valid_identifier():
		print(library_name,' is not a valid name, please avoid using special characters.')
		return
		
	#Create library with new name and stealing current_library's contents.
	mouthLibraryHBox.mouthLibraryDB[library_name] = {}
	for mouthshape in mouthLibraryHBox.mouthLibraryDB[current_library]:
		mouthLibraryHBox.mouthLibraryDB[library_name][mouthshape] = mouthLibraryHBox.mouthLibraryDB[current_library][mouthshape]
	mouthLibraryHBox.save_mouthshape_library(library_name)
	mouthLibraryHBox.delete_mouthshape_library(current_library)
	
	self.current_library = library_name
	mouthLibraryHBox.load_mouthshape_library_file()
	mouthTextures.reload_mouthshape_textures(mouthLibraryHBox.mouthLibraryDB[current_library])
	update_PopupMenu_items()
	#Old library still not being deleted.

func _on_NewButton_pressed():
	var askNamePopup = ask_for_name()
	var library_name :String= ""
	
	yield(askNamePopup, 'name_settled')
	library_name = askNamePopup.new_name
	askNamePopup.queue_free()
	
	if !library_name.is_valid_identifier():
		print(library_name,' is not a valid name, please avoid using special characters.')
		return
		
	
	mouthLibraryHBox.create_new_mouthshape_library(library_name)
	mouthLibraryHBox.save_mouthshape_library(library_name)
	
	self.current_library = library_name
	mouthLibraryHBox.load_mouthshape_library_file()
	mouthTextures.reload_mouthshape_textures(mouthLibraryHBox.mouthLibraryDB[current_library])
	update_PopupMenu_items()
#	text = current_library

func ask_for_name() -> Popup:
	var askNamePopup :Popup= SCN_AskNamePopup.instance()
	owner.pluginInstance.add_child(askNamePopup)
	askNamePopup.titlebar.title_name = "Please insert the name of the new library."
	askNamePopup.label.text = "Please avoid special characters (ex: !@*-=óü~/?;| etc.) and replace spaces with underscores " +'"(_)"'
	return askNamePopup

func _on_DeleteButton_pressed():
	if current_library == 'default':
		return
	mouthLibraryHBox.delete_mouthshape_library(current_library)
	update_PopupMenu_items()
	self.current_library = 'default'
