@tool
extends HBoxContainer


@onready var button :MenuButton= $Button
@onready var popupMenu :PopupMenu
@onready var warningIcon :TextureRect= $WarningIcon

func _ready() -> void:
	popupMenu = button.get_popup()
	# private var last_index instead of get_current_index() function makes it accessible for Godot 3.2 Stable
	if button.last_index == -1: 
		enable_warning("No Sprite node selected. Can't proceed")
	
	popupMenu.connect("id_pressed", _on_PopupMenu_item_selected)

func _on_PopupMenu_item_selected(id :int):
	if id != -1:
		disable_warning()

func enable_warning(message :String):
	warningIcon.visible = true
	warningIcon.hint_tooltip = message

func disable_warning():
	warningIcon.visible = false
