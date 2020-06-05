tool
extends TextureButton

export (PackedScene) var SCN_LipsyncSettingsPopup
var lipsyncSettingsPopup :Popup

func _ready() -> void:
	connect( "pressed", self, "_on_SettingsButton_pressed")
	
func _on_SettingsButton_pressed():
	lipsyncSettingsPopup= SCN_LipsyncSettingsPopup.instance()
	owner.add_child(lipsyncSettingsPopup)
	lipsyncSettingsPopup.connect( "tree_exited", self, "_on_LipsyncSettingsPopup_tree_exited")
	lipsyncSettingsPopup.popup()

func _on_LipsyncSettingsPopup_tree_exited() -> void:
#	owner.pluginInstance.
	
	get_parent().validate_rhubarb_path()
