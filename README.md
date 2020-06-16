Rhubarb Lipsync Third Party Integration for Godot
---
<img src="https://i.imgur.com/Cb16Smg.png" width="250">


Rhubarb Lipsync TPI for Godot is a Godot Engine addon that integrates Rhubarb Lipsync's command-line program into a more user friendly popup-window optimized for use in Godot. 

[Rhubarb Lipsync](https://github.com/DanielSWolf/rhubarb-lip-sync/) is a tool created by Daniel S. Wolf that allows for an automated alternative to producing lipsync animations. You can use it for animating speech in computer games, animated cartoons, or any similar project.

---

You can use the user interface window by browsing in Godot **`[Project > Tools > Rhubarb Lipsync TPI]`** or using the functions directly by calling the plugin instance. [(see below)](#calling-functions-by-code)

# Table of Contents
- [Table of Contents](#table-of-contents)
- [Usage](#usage)
	- [Setup:](#setup)
	- [General Usage:](#general-usage)
- [Mouth Libraries](#mouth-libraries)
- [Cleaning Routine](#cleaning-routine)
- [Screenshots](#screenshots)
- [Calling functions by Code.](#calling-functions-by-code)
- [Function Usage](#function-usage)
- [Bug Report](#bug-report)

# Usage
## Setup:

1. When you first install Rhubarb Lipsync TPI for Godot, you can use it by browsing in Godot **`[Project > Tools > Rhubarb Lipsync TPI]`**
1. This should open the Plugin Popup Window. If it's your first time running it, you will see a error message `"Rhubarb Lipsync not found, goto settings".` </br>So click the gear icon to open the Settings window.
1. The Settings window should also give you a warning stating that it didn't find Rhubarb's binary at the plugin settings. </br>Click the highlighted link at the top to go to Rhubarb Lipsync's releases page.
1. Download the appropriate release for your operating system.
2. Extract the contents from the zip file you downloaded to your desired directory. (We'll use the plugin directory)
3. If the directory you extracted is inside the project folder, rename the Rhubarb Lipsync folder to the same name but with a dot in the beggining. ex: `".rhubarb-lip-sync-1.10.0-linux"` </br>This will make Godot ignore this folder.
4. Go back to Godot, click the Rhubarb Path button and call Rhubarb Lipsync Binary from the folder you just extracted. *
5. Hit save button.
   
*4 - `If you get a warning saying that the plugin didn't recognize the program as a binary file, try renaming Rhubarb's binary to the same extension as your Godot binary. ex: "rhubarb.32"`

## General Usage:

1. Make sure the Edited Scene has the following nodes: AnimationPlayer, Sprite & AudioStreamPlayer.
2. Select AnimationPlayer and open/create the Animation to lipsync.
3. Create an Audio Playback Track
4. Drag the .WAV or .OGG audio file to the track
5. Now Browse **`[Project > Tools > Rhubarb Lipsync TPI]`**
6. Assign the NodePath to the mouth Sprite
7. Assign the NodePath to the AnimationPlayer
8. Assign the Animation to lipsync
9. Assign the NodePath to the AudioStreamPlayer
10. Assign the Audio key containing the audio to lipsync
11. Press Done.

When all values are correctly assigned, Rhubarb Lipsync should start generating the lipsync file. You can check the progress by opening Godot's Debug Console on Windows. For other OS's you rely on Godot printing on Editor Console.

When Rhubarb Lipsync has finished generating lipsync, there'll be a delay until the lipsync is imported to the Animation.

# Mouth Libraries


# Cleaning Routine

# Screenshots

# Calling functions by Code.

Rhubarb Lipsync T.P. Integration for Godot allows you to use the functions that communicate with Rhubarb Lipsync directly by gdscript.
For that you need to call the plugin instance first. The addon uses Godot's group to easily call the plugin path from anywhere.

For example, create an empty scene and attach this script to a Control node:
```js
tool
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

|run_rhubarb_lipsync()|Executes Rhubarb Lipsync in Godot|
|import_lipsync()|Imports a Lipsync TSV (tab-separated-value) file into an Animation resource.|
|import_deferred_lipsync()|Uses import lipsync but waits for  (be careful with this as it yields until Rhubarb Lipsync finishes generating lipsync)|
|get_prestonblair_mouthtexture()|Returns a StreamTexture from a Rhubarb Lipsync mouthshape input|

# Function Usage


>## run_rhubarb_lipsync( )
|argument|type|description|
|-|-|-|
|path_input_audio|String|FilePath to audio file (should be .WAV or .OGG)
are_paths_absolute|bool|False for a relative path ("res://") </br> True for an absolute path ("C://")
|length|float|Audio length in seconds 

>## import_lipsync( )
|argument|type|description|
|-|-|-|
|anim|Animation|Animation Resource Object from animationPlayer|
|animationPlayer|AnimationPlayer|AnimationPlayer Instance|
|audiokey|Dictionary|Data about the audio key from anim|
|audioPlayer|AudioStreamPlayer|AudioStreamPlayer Instance|
|mouthDB|Dictionary|Mouthshape database|
|mouthSprite|Sprite|Mouth Sprite Instance|

>## import_deferred_lipsync( )
|argument|type|description|
|-|-|-|
|audiokey|Dictionary|Data about the audio key from anim_name's Animation|
|mouthSprite|Sprite|Mouth Sprite Instance|
|audioPlayer|AudioStreamPlayer|AudioStreamPlayer Instance|
|animationPlayer|AnimationPlayer|AnimationPlayer Instance|
|anim_name|String|Animation resource's name from AnimationPlayer|
|mouthDB|Dictionary|Mouthshape database|


>## get_prestonblair_mouthtexture( )
|argument|type|description|
|-|-|-|
|rhubarb_shape|String|Rhubarb Lipsync mouthshape ("A", "B", "C")
|mouthDB|Dictionary|Mouthshape texture database

# Bug Report

If you encounter any errors, try opening Godot's Debug Console on Windows or start Godot from the terminal and repplicate the problem.
When reporting an issue, make sure to include any errors printed there.