tool
extends TextureButton

export (PackedScene) var SCN_LipsyncAboutPopup
var lipsyncAboutPopup :Popup

func _ready() -> void:
	connect("pressed", self, "_on_pressed")
	

func _on_hide():
	if !is_queued_for_deletion():
		queue_free()
	queue_free()

func _on_pressed() -> void:
	lipsyncAboutPopup = SCN_LipsyncAboutPopup.instance()
	owner.add_child(lipsyncAboutPopup)
#	lipsyncAboutPopup.connect("tree_exited", self, "_on_LipsyncAboutPopup_tree_exited")
	lipsyncAboutPopup.popup()

#func _on_LipsyncAboutPopup_tree_exited() -> void:
#	owner.pluginInstanc

