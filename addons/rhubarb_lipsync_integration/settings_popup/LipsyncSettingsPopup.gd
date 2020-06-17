tool
extends Popup

signal updated_settings

const GROUP_PLUGIN :String= "plugin rhubarb_lipsync_integration"
var pluginInstance :EditorPlugin
var path_plugin :String

var fileDialog :FileDialog

var okButton :Button

func _ready() -> void:
	okButton = $Panel/VBox/OkButton
	okButton.connect( "pressed", self, '_on_OkButton_pressed')
	connect("hide", self, "_on_hide")
	
	

func _on_hide():
	if get_tree().edited_scene_root == self:
		return
	if !is_queued_for_deletion():
		queue_free()
	queue_free()

func _enter_tree() -> void:
	
	pluginInstance = _get_pluginInstance()
	pluginInstance.load_settings()
	
	fileDialog = $FileDialog
	if get_tree().edited_scene_root == self:
		visible=true

func _get_pluginInstance() -> EditorPlugin:
	if get_tree().has_group(GROUP_PLUGIN):
		var plugin_group :Array= get_tree().get_nodes_in_group(GROUP_PLUGIN)
		for node in plugin_group:
			if node is EditorPlugin:
				path_plugin = node.path_plugin
				return node
	return null

func _on_OkButton_pressed():
	pluginInstance.save_settings()
	if is_queued_for_deletion():
		return
	queue_free()
