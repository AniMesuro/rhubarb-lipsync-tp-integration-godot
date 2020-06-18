tool
extends HBoxContainer

var menuButton :MenuButton
var popupMenu :PopupMenu
var warningIcon :TextureRect

func _ready() -> void:
	menuButton = $MenuButton
	popupMenu = menuButton.get_popup()
	
#	menuButton.connect("pressed", self, '_on_MenuButton_pressed')
	popupMenu.connect("id_pressed", self, '_on_PopupMenu_item_pressed')
	
func _on_PopupMenu_item_pressed(id :int):
	var item = popupMenu.get_item_text(id)
	
	if !owner.pluginInstance.Settings.has("rhubarb_lipsync"):
		owner.pluginInstance.load_settings()
	if !owner.pluginInstance.Settings.rhubarb_lipsync.has("recognizer"):
		owner.pluginInstance.load_settings()
	
	if owner.pluginInstance.Settings.rhubarb_lipsync.recognizer != item:
		owner.pluginInstance.Settings.rhubarb_lipsync.recognizer = item
	menuButton.text = owner.pluginInstance.Settings.rhubarb_lipsync.recognizer
	validate_setting()

#func _on_MenuButton_pressed():
##	popupMenu.clear()
#	pass
	

func _enter_tree() -> void:
	menuButton = $MenuButton
	warningIcon = $WarningIcon
	validate_setting()
	
func validate_setting():
	var Settings :Dictionary= owner.pluginInstance.Settings
	
	if !Settings.has("rhubarb_lipsync"):
		enable_warning("'rhubarb_lipsync' section not found at Settings Dict.")
		return
	if !Settings.rhubarb_lipsync.has("recognizer"):
		enable_warning("'recognizer' key not found at Settings Dict.")
		return
	
	if(Settings.rhubarb_lipsync.recognizer == 'pocketSphinx'
	or Settings.rhubarb_lipsync.recognizer == 'phonetic'):
		menuButton.text = Settings.rhubarb_lipsync.recognizer
		disable_warning()
		return
	enable_warning(Settings.rhubarb_lipsync.recognizer+' is not a valid Speech Recognizer. Save settings to fix.')
	Settings.rhubarb_lipsync.recognizer = 'pocketSphinx'

func enable_warning(message :String):
	warningIcon.visible = true
	warningIcon.hint_tooltip = message

func disable_warning():
	warningIcon.visible = false
