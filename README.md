Rhubarb Lipsync Third Party Integration for Godot
---
<img src="https://i.imgur.com/Cb16Smg.png" width="250">


Rhubarb Lipsync TPI for Godot is a Godot Engine addon that integrates Rhubarb Lipsync's command-line program into a more user friendly popup-window optimized for use in Godot. 

[Rhubarb Lipsync](https://github.com/DanielSWolf/rhubarb-lip-sync/) is a tool created by Daniel S. Wolf that allows for an automated alternative to producing lipsync animations. You can use it for animating speech in computer games, animated cartoons, or any similar project.

---

You can use the user interface window by browsing in Godot **[Project > Tools > Rhubarb Lipsync TPI]** or using the functions directly by calling the plugin instance.

# Calling functions by Code.

Rhubarb Lipsync T.P. Integration for Godot allows you to use the functions that communicate with Rhubarb Lipsync directly by gdscript.
For that you need to call the plugin instance first. The addon uses Godot's group to easily call the plugin path by anywhere.

For example, create an empty scene and attach this script to a Control node:
```tool
extends Control

export var call_rhubarb_lipsync_tpi_plugin :bool setget set_rhubarb_lipsync_tpi_plugin #fake button | pressed via inspector

var rlsi_plugin_group :String= "plugin rhubarb_lipsync_integration" #current plugin group name
var rlsi_pluginInstance :EditorPlugin #Rhubarb Lipsync Integration

#Called when user clicks the fake button.
func set_rhubarb_lipsync_tpi_plugin(value):
	call_rhubarb_lipsync_tpi_plugin = false #fake button | value is ignored
	var group :Array= get_tree().get_nodes_in_group(rlsi_plugin_group)
	for node in group: 
		if node is EditorPlugin: #There should be only one EditorPlugin type at this group.
			rlsi_pluginInstance = node
#plugin now can be called by pluginInstance.
```

After you have called the Rhubarb Lipsync TPI plugin you can use two methods to communicate with Rhubarb Lipsync:
|Function|Description|
|-|-|
|run_rhubarb_lipsync|Executes Rhubarb Lipsync in Godot|
|import_lipsync|Imports a Lipsync TSV (tab-separated-value) file into an Animation resource.|
|import_deferred_lipsync|Uses import lipsync but waits for  (be careful with this as it yields until Rhubarb Lipsync finishes generating lipsync)|
