tool
extends GridContainer

const SCN_FileIcon :PackedScene= preload("res://addons/rhubarb_lipsync_integration/file_selector_preview/FileIcon.tscn")
const TEX_IconFolder :StreamTexture= preload("res://addons/rhubarb_lipsync_integration/assets/icons/icon_folder.png")

var fileSelectorPreview :Control

func _enter_tree() -> void:
	fileSelectorPreview = owner

func update_file_list():
	#Clear children
	for child in get_children():
		child.queue_free()
	
	# Populate FileContainer with a FileIcon for each file
	for folder in owner.dir_folders:
		var fileIcon :VBoxContainer= SCN_FileIcon.instance()
		add_child(fileIcon)
		fileIcon.get_node("Preview").texture_normal = TEX_IconFolder
		fileIcon.file_name = folder
		fileIcon.my_type = fileIcon.TYPE.folder
		fileIcon.connect("folder_selected", self, "_on_folder_selected") 
		fileIcon.setup()
	for file in owner.dir_files:
		if !file.get_extension() in owner.filters:
#			print(file,' is ',file.get_extension(),' not ',owner.filters)
			continue
		var fileIcon :VBoxContainer= SCN_FileIcon.instance()
		add_child(fileIcon)
#		fileIcon.get_node("Preview").texture_normal = load(file)
		fileIcon.file_name = file
		fileIcon.my_type = fileIcon.TYPE.file
		fileIcon.connect("file_selected", self, "_on_file_selected")
		fileIcon.setup()
	$"../../../ZoomHbox"._update_FileIcon_sizes()

func _on_file_selected(file_name :String):
	print('current_dir =',owner.current_dir)
	pass

func _on_folder_selected(file_name :String):
	print('current_dir =',owner.current_dir)
	owner.Dir.change_dir(owner.current_dir + file_name)
	owner.current_dir = owner.current_dir + file_name + "/"
	
