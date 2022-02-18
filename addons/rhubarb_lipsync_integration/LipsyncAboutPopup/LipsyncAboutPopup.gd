@tool
extends Popup

const GROUP_PLUGIN :String= "plugin rhubarb_lipsync_integration"
var pluginInstance :EditorPlugin

func _enter_tree() -> void:
	if get_tree().edited_scene_root == self:
		visible = true
		
func _ready() -> void:
	connect("hide", _on_hide)
	
	if !is_inside_tree():
		await tree_entered
		
	
	$"Panel/VBox/VersionLabel".text = "Version: " + await get_plugin_version()

func get_plugin_version() -> String:
	#if !is_instance_valid(self):
		#await get_tree().idle_frame
	pluginInstance = _get_pluginInstance()
	
	var pluginConfig :ConfigFile= ConfigFile.new()
	var err = pluginConfig.load(pluginInstance.path_plugin+"plugin.cfg")
	var version :String= "x.x.x"
	if err == OK:
		if !pluginConfig.has_section("plugin"):
			return version
			
		version = pluginConfig.get_value("plugin", "version", "1.0")
	return version

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
