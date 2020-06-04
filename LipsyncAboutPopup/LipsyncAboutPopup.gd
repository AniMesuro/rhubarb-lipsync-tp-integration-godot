tool
extends Popup

const GROUP_PLUGIN :String= "plugin rhubarb_lipsync_integration"
var pluginInstance :EditorPlugin

func _enter_tree() -> void:
	if get_tree().edited_scene_root == self:
		visible = true
		
func _ready() -> void:
	connect("hide", self, "_on_hide")

func _on_hide():
	if get_tree().edited_scene_root == self:
		return
	if !is_queued_for_deletion():
		queue_free()
	queue_free()

func _get_pluginInstance() -> EditorPlugin:
	if get_tree().has_group(GROUP_PLUGIN):
		var plugin_group :Array= get_tree().get_nodes_in_group(GROUP_PLUGIN)
		for node in plugin_group:
			if node is EditorPlugin:
				return node
				break
	return null
