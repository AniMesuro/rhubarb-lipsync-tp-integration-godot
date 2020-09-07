tool
extends VBoxContainer

const SCN_FileSelectorPreview :PackedScene= preload("res://addons/rhubarb_lipsync_integration/file_selector_preview/FileSelectorPreview.tscn")

export var _temp_texture :StreamTexture
var mouthDB :Dictionary= {}
var mouthIconDB :Dictionary= {}

func reload_mouthshape_textures(library :Dictionary):
#	print(library)
	for mouthshape in library:
		if !library.has(mouthshape):
			continue
		mouthDB[mouthshape] = load(library[mouthshape])
		if is_instance_valid(mouthIconDB[mouthshape]):
			if is_instance_valid(mouthIconDB[mouthshape].textureButton):
				mouthIconDB[mouthshape].textureButton.texture_normal = load(library[mouthshape])

func _enter_tree() -> void:
	mouthDB = {
		'rest': _temp_texture,
		'MBP': _temp_texture,
		'O': _temp_texture,
		'U': _temp_texture,
		'etc': _temp_texture,
		'FV': _temp_texture,
		'E': _temp_texture,
		'L': _temp_texture,
		'AI': _temp_texture
	}
#	var mouthLibraryHBox :HBoxContainer= $"../../MouthLibraryHBox"
#	reload_mouthshape_textures(mouthLibraryHBox.mouthLibraryDB[mouthLibraryHBox.menuButton.current_library])
	




var fileDialog :FileDialog
var fileSelectorPreview :Control

func _on_MouthIcon_pressed(mouthIcon :VBoxContainer) -> void:
	var button :TextureButton= mouthIcon.textureButton
	
	if !owner.pluginInstance.Settings.has('file_selection'):
		owner.pluginInstance.Settings.file_selection = {}
	
	if owner.pluginInstance.Settings.file_selection.file_dialog.to_lower() == "file_selector_preview":
		if is_instance_valid(fileSelectorPreview):
			return
		fileSelectorPreview = SCN_FileSelectorPreview.instance()
		fileSelectorPreview.connect("file_selected", self, "_on_FileSelectorPreview_file_selected", [mouthIcon])
		fileSelectorPreview.setup(FileDialog.ACCESS_RESOURCES, PoolStringArray(['png','jpg','jpeg']), "* All Images", "Please select an image for "+mouthIcon.mouth_shape)
		fileSelectorPreview.rect_global_position = OS.window_size/2 - fileSelectorPreview.rect_size/2
		owner.pluginInstance.add_child(fileSelectorPreview)
	else:
	
		fileDialog = FileDialog.new()
		fileDialog.connect("popup_hide", self, "_on_FileDialog_popup_hide")
		owner.pluginInstance.add_child(fileDialog)
		fileDialog.mode = fileDialog.MODE_OPEN_FILE
		fileDialog.resizable = true
		fileDialog.rect_min_size = Vector2(400, 300)
		fileDialog.filters = PoolStringArray(['*.png','*.jpg'])
		fileDialog.popup()
		
		yield(fileDialog, "file_selected")
		button.texture_normal = load(fileDialog.current_path)
		mouthDB[mouthIcon.mouth_shape] = button.texture_normal

######################



func _on_FileDialog_popup_hide():
	if !fileDialog.is_queued_for_deletion():
		fileDialog.queue_free()

func _on_FileSelectorPreview_file_selected(filepath :String, mouthIcon :VBoxContainer):
	mouthIcon.get_node('Texture').texture_normal = load(filepath)
	mouthDB[mouthIcon.mouth_shape] = mouthIcon.get_node('Texture').texture_normal
