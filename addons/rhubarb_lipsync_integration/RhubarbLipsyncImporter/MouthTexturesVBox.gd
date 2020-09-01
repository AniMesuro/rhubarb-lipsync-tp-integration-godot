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
	
	if get_tree().edited_scene_root != owner:
		get_tree().connect("files_dropped", self, "_on_files_dropped")

func _on_files_dropped(files :PoolStringArray, screen :int):
	if !is_inside_tree():
		return
	print('files dropped ',files)
	
	if !is_instance_valid(self):
		print('self not valid')
	
#	else:
#		print('MouthTextures inside tree')
	
	if files.size() == 1:
		var Dir :Directory= Directory.new()
		var f:String= files[0]
		
		# If file is not in Project  Directory
		if files[0].find(ProjectSettings.globalize_path(Dir.get_current_dir()).replace('/',"\\")) == -1:
			print("[Rhubarb Lip Sync TPI] Image can't be dropped as it's not located at project directory.")
			return
		
		if (f.get_extension() == 'png' or f.get_extension() == 'jpg' or f.get_extension() == 'gif'):
			yield(get_tree(), "idle_frame")
			var mouse_pos :Vector2= get_viewport().get_mouse_position()
			print("mouse ",mouse_pos)
			
			# Debug mouse pos
#			var spr :Sprite= Sprite.new();owner.pluginInstance.add_child(spr)
#			spr.texture = load('res://icon.png'); spr.global_position = mouse_pos; spr.modulate = Color(1,0,0,.5); spr.scale = Vector2(.3,.3)
			
			var mouthIcons :Array= $TopHBox.get_children() + $BottomVBox.get_children()
			# Inside MouthTextures Bounds - For some reason vector2 calculating doesn't work
			if ((mouse_pos.x > rect_global_position.x) && (mouse_pos.x < (rect_global_position.x + rect_size.x))
			&&  (mouse_pos.y > rect_global_position.y) && (mouse_pos.y < (rect_global_position.y + rect_size.y))):
				print('inside mouthtextures ',rect_global_position,'/',rect_global_position+ rect_size)
				var closest_square_distance :float= 922337203#6854775807
				var closest_icon :Control

				for icon in mouthIcons:
					var square_distance_to_mouse :float= (icon.rect_global_position + icon.rect_size/2).distance_squared_to(mouse_pos)
					if square_distance_to_mouse < closest_square_distance:
						closest_square_distance = square_distance_to_mouse
						closest_icon = icon

				var tex_new_mouth :StreamTexture= load(f)
				closest_icon.textureButton.texture_normal = tex_new_mouth
				mouthDB[closest_icon.mouth_shape] = tex_new_mouth

			return
#			for mouthIcon in mouthIcons:
#				var icon :Control= mouthIcon
#				if mouse_pos > icon.rect_global_position && mouse_pos < icon.rect_global_position + icon.rect_size:
#
#					print("mouse_pos =", mouse_pos," iconpos =",icon.rect_global_position, " iconpos2 =", icon.rect_global_position + icon.rect_size, "shape =",icon.mouth_shape)
#
#					var tex_new_mouth :StreamTexture= load(f)
#
#					icon.textureButton.texture_normal = tex_new_mouth
#					mouthDB[icon.mouth_shape] = tex_new_mouth
#					break

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
