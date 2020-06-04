tool
extends HBoxContainer

var menuButton :MenuButton
var popupMenu :PopupMenu

func _ready() -> void:
	menuButton = $MenuButton
	popupMenu = menuButton.get_popup()
	
	menuButton.connect( "pressed", self, "_on_MenuButton_pressed")
	popupMenu.connect( "id_pressed", self, "_on_PopupMenu_item_selected")
	
	if !is_instance_valid(owner.pluginInstance):
		return
#	if !pluginInstance
	
	menuButton.text = owner.pluginInstance.CleanMode.keys()[owner.pluginInstance.Settings.output.clean_mode]

func _on_MenuButton_pressed():
#	print('cleanmode ',owner.pluginInstance.load_default_settings(['output','clean_mode']))
#	return
	popupMenu.clear()
	
	for i in owner.pluginInstance.CleanMode:
		popupMenu.add_item(i)
	popupMenu.popup()

func _on_PopupMenu_item_selected(id :int):
	if !is_instance_valid(owner.pluginInstance):
		return
	if !owner.pluginInstance.Settings.has("output"):
		owner.pluginInstance.Settings.output = {}
	
#	print('id ',id,' ',owner.pluginInstance.CleanMode.values()[id])
	owner.pluginInstance.Settings.output.clean_mode = id #owner.pluginInstance.CleanMode.values()[id]
	menuButton.text = popupMenu.get_item_text(id)
