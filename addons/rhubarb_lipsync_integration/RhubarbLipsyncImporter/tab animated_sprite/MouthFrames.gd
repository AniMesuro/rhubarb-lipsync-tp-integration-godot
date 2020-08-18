extends VBoxContainer

const SCN_FrameSelectorPopup :PackedScene= preload("res://addons/rhubarb_lipsync_integration/RhubarbLipsyncImporter/tab animated_sprite/FrameSelectorPopup.tscn")

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
