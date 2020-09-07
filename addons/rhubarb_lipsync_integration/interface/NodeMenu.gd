tool
extends MenuButton

var last_index :int= -1

const TEX_IconExpand :StreamTexture= preload("res://addons/rhubarb_lipsync_integration/assets/icons/icon_expand.png")

export var NO_NODE_FOUND = "No node found at tree."
export var owner_reference :String= 'anim_'
export var node_type :String= 'Node'

var editedSceneRoot

onready var popup :PopupMenu= get_popup()

func _ready() -> void:
	connect('pressed', self, '_on_Button_pressed')
	popup.connect('id_pressed', self, '_on_PopupMenu_item_selected')#, [button.selected])
	
	text = NO_NODE_FOUND
	owner.connect("parameters_reset", self, "_on_parameters_reset")

func _on_Button_pressed() -> void:
	editedSceneRoot = get_tree().edited_scene_root
	if !is_instance_valid(editedSceneRoot):
		return
	var edited_scene_child = owner.get_relevant_children()
	
	popup.clear()
	for i in edited_scene_child.size():
		if (edited_scene_child[i].get_class() == node_type):
			popup.add_item(editedSceneRoot.get_path_to(edited_scene_child[i]))
	if edited_scene_child.size() == 0:
		text = NO_NODE_FOUND

func _on_parameters_reset():
	icon = TEX_IconExpand
	text = NO_NODE_FOUND
	popup.clear()

func _on_PopupMenu_item_selected(id :int):
	last_index = id
	var item_name :String= popup.get_item_text(id)
	text = item_name
	
	
	icon = owner.pluginInstance.get_editor_interface().get_inspector().get_icon(node_type, "EditorIcons")
	owner.set(owner_reference, editedSceneRoot.get_node(item_name))
	owner.emit_signal("updated_reference", owner_reference)
