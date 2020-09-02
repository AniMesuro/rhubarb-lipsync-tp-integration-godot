tool
extends VBoxContainer

signal file_selected (filepath)
signal folder_selected (filepath)

enum TYPE {
	file,
	folder
}
var my_type :int

var file_name :String= "icon.png"

func _ready() -> void:
	var preview :TextureButton= $Preview
	preview.connect("pressed", self, "_on_Preview_pressed")

func setup():
	var label :Label= $Label
	
	label.text = file_name
	match file_name.get_extension():
		'png','jpg':
				var preview :TextureButton= $Preview
				preview.texture_normal = load(get_parent().fileSelectorPreview.current_dir+ file_name)
#				print(get_parent().fileSelectorPreview.current_dir+ file_name)

func _on_Preview_pressed():
	print("FileIcon pressed||",file_name)
	if my_type == TYPE.file:
		emit_signal("file_selected", file_name)
	elif my_type == TYPE.folder:
		emit_signal("folder_selected", file_name)
