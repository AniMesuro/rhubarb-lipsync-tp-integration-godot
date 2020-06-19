tool
extends VBoxContainer

export var _temp_texture :StreamTexture
var mouthDB :Dictionary
var mouthIconDB :Dictionary= {}

func reload_mouthshape_textures(library :Dictionary):
	for mouthshape in library:
		mouthDB[mouthshape] = load(library[mouthshape])
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


var fileDialog :FileDialog


func _on_MouthIcon_pressed(mouthIcon :VBoxContainer) -> void:
	var button :TextureButton= mouthIcon.textureButton
#	ask_for_filepath(textureButton)
	fileDialog = FileDialog.new()
	fileDialog.connect("popup_hide", self, "_on_FileDialog_popup_hide")
	owner.pluginInstance.add_child(fileDialog)
	fileDialog.mode = fileDialog.MODE_OPEN_FILE
	fileDialog.resizable = true
	fileDialog.rect_min_size = Vector2(400, 300)
	fileDialog.filters = PoolStringArray(['*.png','*.jpg'])
#	fileDialog.access = fileDialog.ACCESS_FILESYSTEM
	fileDialog.popup()
	
	yield(fileDialog, "file_selected")
#	print("file path =", fileDialog.current_path)
	button.texture_normal = load(fileDialog.current_path)
	mouthDB[mouthIcon.mouth_shape] = button.texture_normal
#	print('mouthDB =', mouthDB)

######################



func _on_FileDialog_popup_hide():
	if !fileDialog.is_queued_for_deletion():
		fileDialog.queue_free()
