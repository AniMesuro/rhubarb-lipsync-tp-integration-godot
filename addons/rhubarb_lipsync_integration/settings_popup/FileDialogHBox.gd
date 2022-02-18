@tool
extends HBoxContainer

const file_dialog_option :Dictionary= {
	'godot': "Godot - FileDialog",
	'file_selector_preview': "Custom - FileSelectorPreview"
}

func _ready() -> void:
	var popupMenu :PopupMenu= $MenuButton.get_popup()
	for option in file_dialog_option:
		popupMenu.add_item(file_dialog_option[option])
	popupMenu.connect("id_pressed", _on_popupMenu_id_pressed)
	
	if !is_instance_valid(owner.pluginInstance):
		return
	
	$MenuButton.text = file_dialog_option[owner.pluginInstance.Settings.file_selection.file_dialog]

func _on_popupMenu_id_pressed(id :int):
	if !is_instance_valid(owner.pluginInstance):
		return
	owner.pluginInstance.Settings.file_selection.file_dialog = file_dialog_option.keys()[id]
	$MenuButton.text = file_dialog_option.values()[id]
