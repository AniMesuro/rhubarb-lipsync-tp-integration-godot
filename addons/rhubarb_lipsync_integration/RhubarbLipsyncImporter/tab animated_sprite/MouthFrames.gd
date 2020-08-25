tool
extends VBoxContainer

const SCN_FrameSelectorPopup :PackedScene= preload("res://addons/rhubarb_lipsync_integration/RhubarbLipsyncImporter/tab animated_sprite/FrameSelectorPopup.tscn")

var mouthDB :Dictionary= {
		'rest': 0,
		'MBP': 0,
		'O': 0,
		'U': 0,
		'etc': 0,
		'FV': 0,
		'E': 0,
		'L': 0,
		'AI': 0
	}

#var frameSelectorPopup :PopupPanel
#
#func _on_MouthIcon_pressed(mouthIcon :VBoxContainer):
#
#	var textureButton :TextureButton= mouthIcon.textureButton
#
#	frameSelectorPopup = SCN_FrameSelectorPopup.instance()
#	owner.pluginInstance.add_child(frameSelectorPopup)
#	frameSelectorPopup.connect("frame_selected", self, "_on_frame_selected")
#
#func _on_frame_selected(id :int):
#	print('id')
#	pass
