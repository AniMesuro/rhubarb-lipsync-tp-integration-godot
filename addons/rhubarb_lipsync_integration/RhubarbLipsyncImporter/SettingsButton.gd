@tool
extends TextureButton

@export var SCN_LipsyncSettingsPopup: PackedScene
var lipsyncSettingsPopup :Popup

func _ready() -> void:
	connect( "pressed", _on_SettingsButton_pressed)
	
func _on_SettingsButton_pressed():
	lipsyncSettingsPopup= SCN_LipsyncSettingsPopup.instantiate()
	owner.add_child(lipsyncSettingsPopup)
	lipsyncSettingsPopup.connect( "tree_exited", _on_LipsyncSettingsPopup_tree_exited)
	lipsyncSettingsPopup.popup()

func _on_LipsyncSettingsPopup_tree_exited() -> void:
#	owner.pluginInstance.
	
	get_parent().validate_rhubarb_path()
