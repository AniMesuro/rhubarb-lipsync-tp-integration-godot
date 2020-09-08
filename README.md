Rhubarb Lip Sync Third Party Integration for Godot
---
<img src="https://i.imgur.com/Cb16Smg.png" width="250">


Rhubarb Lip Sync T.P.I. for Godot is a Godot Engine addon made by AniMesuro that integrates Rhubarb Lip Sync's command-line program into a more user friendly popup-window optimized for use in Godot. 

[Rhubarb Lip Sync](https://github.com/DanielSWolf/rhubarb-lip-sync/) is a tool created by Daniel Wolf that allows for an automated alternative to producing lip sync animations. You can use it for animating speech in computer games, animated cartoons, or any similar project.

---

You can use the user interface window by browsing in Godot **`[Project > Tools > Rhubarb Lipsync TPI]`** or using the functions directly by calling the plugin instance. [(see below)](#calling-functions-by-code)

# Table of Contents
- [Table of Contents](#table-of-contents)
- [Usage](#usage)
	- [Setup:](#setup)
	- [General Usage:](#general-usage)
- [Speech Recognizer](#speech-recognizer)
- [Mouth Libraries](#mouth-libraries)
	- [AnimatedSprite Frame Sequence](#animatedsprite-frame-sequence)
- [Cleaning Routine](#cleaning-routine)
- [File Checking Timer](#file-checking-timer)
- [Screenshots](#screenshots)
	- [Main Window (Sprite Importing)](#main-window-sprite-importing)
	- [Main Window (AnimatedSprite Importing)](#main-window-animatedsprite-importing)
	- [FileSelectorPreview](#fileselectorpreview)
	- [About Window](#about-window)
	- [Settings Window](#settings-window)
	- [Result](#result)
- [Videos](#videos)
- [FileSelectorPreview](#fileselectorpreview-1)
- [Audio Slicing](#audio-slicing)
- [Calling functions by Code.](#calling-functions-by-code)
- [Function Usage](#function-usage)
- [Disclaimer](#disclaimer)
- [Bug Report](#bug-report)

# Usage
## Setup:

1. When you first install Rhubarb Lip Sync TPI for Godot, you can use it by browsing in Godot **`[Project > Tools > Rhubarb Lipsync TPI]`**
1. This should open the Plugin Popup Window. If it's your first time running it, you will see a error message `"Can't proceed. Rhubarb binary doesn't exist on path defined in Settings".` </br>So click the gear icon to open the Settings window.
1. The Settings window should also give you a warning stating that it didn't find Rhubarb's binary at the plugin settings. </br>Click the highlighted link `"Rhubarb Lip Sync"` at the top to go to Rhubarb Lip Sync's releases page.
1. Download the appropriate release for your operating system.
2. Extract the contents from the zip file you downloaded to your desired directory. (We'll use the plugin directory `"res://addons/rhubarb_lipsync_integration"`)
3. If the directory you extracted is inside the project directory, rename the Rhubarb Lip Sync folder to the same name but with a dot in the beggining. ex: `".rhubarb-lip-sync-1.10.0-linux"` </br>This will make Godot ignore this folder.
4. Go back to Godot, click the Rhubarb Path button and call Rhubarb Lip Sync Binary from the folder you just extracted. *
5. Hit save button.
   
>*4 - `If you get a warning saying that the plugin didn't recognize the program as a binary file, try renaming Rhubarb's binary to the same extension as your Godot binary. ex: "rhubarb.32"`


## General Usage:

1. Make sure the Edited Scene has the following nodes: AnimationPlayer, AudioStreamPlayer and (Sprite or AnimatedSprite).
2. Select AnimationPlayer and open/create the Animation to lip sync.
3. Click on **`Add track`** and create an Audio Playback Track
4. Drag the .WAV or .OGG audio file to the track
5. Now Browse **`[Project > Tools > Rhubarb Lipsync TPI]`**
6. Select which node to lip sync the mouth from the tabs: Sprite or AnimatedSprite
7. Assign the NodePath to the mouth Sprite || Assign NodePath to AnimatedSprite and SpriteFrames animation.
8. Assign the NodePath to the AnimationPlayer
9. Assign the Animation to be lip synced
10. Assign the NodePath to the AudioStreamPlayer
11. Assign the Audio key containing the voice recording to be lip synced
12. Press Done.

When all values are correctly assigned, Rhubarb Lip Sync should start generating the lip sync file. You can check the progress by opening Godot's Debug Console on Windows. For other OS's you rely on Godot printing on Editor Console.

When Rhubarb Lip Sync has finished generating lip sync data, there'll be a delay until the lip sync is imported to the Animation. [That's because the plugin relies on a Timer instead of communicating with Rhubarb.](#File-Checking-Timer)

# Speech Recognizer

Speech Recognizers are speech recognition libraries used by Rhubarb Lip Sync to determine what phonemes or words are being said in a voice recording

By default, Rhubarb Lip Sync TPI uses pocketSphinx as the recognizer for Rhubarb Lip Sync, but you can change it to phonetic in Settings.

|Recognizer|Usecase|
|-|-|
|pocketSphinx|recommended for English voice recordings.|
|phonetic|recommended for any non-English voice recordings.|

Speech Recognizers are not used directly through this plugin, but as a parameter for executing Rhubarb Lip Sync. For more information about Recognizers, see [Rhubarb Lip Sync's section on Recognizers](https://github.com/DanielSWolf/rhubarb-lip-sync/#Recognizers)

# Mouth Libraries

Mouth libraries are groups of mouth textures stored in file format that can be reused to lip sync a voice recording.
</br> The default mouth library is located at the directory `"res://addons/rhubarb_lipsync_integration/assets/lipsync default mouthshapes/"`

You can create your own Mouth Library by pressing the `"Plus"` icon in the Mouthshape Library bar then setting a name for it. The name should be alphanumerical `(a-z, 0-9)` and spaces should be replaced with `"_"` underline.

To rename a mouth library, click the `"Pen"` icon in the Mouthshape library bar and setting a new name for it with the same rules as stated above.

To replace the Mouthshape texture, press the desired mouthshape image and browse to the new image filepath. (By default the plugin uses a custom FileDialog named FileSelectorPreview) Press ``"Save"`` icon in the Mouthshape Library

To remove a Mouthshape texture, press the ``"Delete"`` icon in the MouthShape Library.

>Please note that Rhubarb Lip Sync TPI uses the file paths to reference the textures, so if the images change directory the texture will fail to load.

## AnimatedSprite Frame Sequence
In AnimatedSprites mouthshapes are stored in frames, so there's no need to assign image file paths.
By default the mouthshape frame sequence is as follows:

`rest - MBP - FV - O - U - etc - E - L - AI`

but it can be changed by pressing a a MouthFrameIcon and assigning a frame in a frame selector popup.

# Cleaning Routine

After you lip sync a lot of voice recordings, you may find your lip sync output directory to be full of used lip sync files you probably don't need anymore, so Rhubarb Lip sync TPI has a Cleaning Routine functionality to clean all `".TSV"` and `".WAV"` lip sync data and sliced audio files after a determined event.

These events are:
|Event|Condition|
|-|-|
|Never|Cleaning is never executed|
|OpenPlugin|Project is opened or plugin is enabled|
|ClosePlugin|Project is closed or plugin is disabled|

# File Checking Timer
Godot doesn't have a native "process_died" signal so the plugin relies on checking if an output ``".TSV"`` (lip sync data) file has been created before importing the animation.
This is done through a Timer node that calls the checking every interval of seconds for a calculated maximum period of time (This is why the plugin prints "(NOT A ESTIMATE) Plugin will wait for max...")

By default the interval is ``3 sec`` and the maximum number of calls is ``200`` (this should roughly estimate 10 minutes until plugin gives up on waiting for an output). These values can be changed in the ``"file_checks"`` section of the Settings:
> timer_max_calls - maximum number of file checking calls
> 
> timer_sec - the interval in seconds

# Screenshots

## Main Window (Sprite Importing)

![Imgbox](https://images2.imgbox.com/e4/57/sWSyp0z4_o.png)

## Main Window (AnimatedSprite Importing)

![Imgbox](https://images2.imgbox.com/67/f2/ZedFspEB_o.png)

## FileSelectorPreview

![Imgbox](https://images2.imgbox.com/29/ac/u2Yu6d2J_o.png)

## About Window
![Imgur](https://i.imgur.com/td7izxn.png)


## Settings Window

![Imgur](https://i.imgur.com/HD0BQoZ.png)

## Result

![Imgbox](https://images2.imgbox.com/6e/06/DdRt5Mto_o.png)

# Videos

[![Plugin Demo Video](http://i3.ytimg.com/vi/uphYDsIXu6M/hqdefault.jpg)](https://www.youtube.com/watch?v=uphYDsIXu6M)
</br>Plugin Demo Video (version 1.0)

[![Video Tutorial](https://img.youtube.com/vi/qPWBWRkcFjY/hqdefault.jpg)](https://www.youtube.com/watch?v=qPWBWRkcFjY)
</br>Video tutorial on how to use Rhubarb Lip Sync TPI's basic functionality (version 1.0)

# FileSelectorPreview
FileSelectorPreview is an alternative to Godot's FileDialog. The main advantage is the presence of thumbnails and an Icon display structure. It has a zoom feature to display more/less files at once.
You can also select a file by typing the full file path into the directory LineEdit.

By default FileSelectorPreview is the default FileDialog for selecting images for mouthshapes, but this can be changed at section ``file_selection`` at Settings.
> file_selector_preview - Custom file dialog

> godot - Godot's native FileDialog

# Audio Slicing
When you have a really long audio file, but want to lip sync only a small portion, you can slice the audio key using it's start_offset and end_offset properties. However it works differently depending on the audio key sample's extension:
> .WAV files will save a new sliced input file to be used as a parameter for Rhubarb Lip Sync, so only the _SLICED LENGTH AUDIO_ will have lip sync generated. Therefore there's no data outside offsets to ignore.

> .OGG files will have the lip sync for the __FULL LENGTH AUDIO__ generated and the data outside the offsets will be ignored on importing.


# Calling functions by Code.

Rhubarb Lipsync T.P. Integration for Godot allows you to use the functions that communicate with Rhubarb Lip Sync directly by gdscript.
For that you need to call the plugin instance first. The addon uses Godot's group to easily call the plugin path from anywhere.
> But please note this is experimental, there's no guarantee something will not break.
> This was only tested on tool scripts.

For example, create an empty scene and attach this script to a Control node:
```gdscript
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

After you have called the Rhubarb Lip Sync TPI plugin you can use these functions to communicate with Rhubarb Lip Sync TPI plugin:
|Function|Description|
|-|-|
|run_rhubarb_lipsync()|Executes Rhubarb Lip Sync in Godot|
|import_lipsync()|Imports a Lipsync TSV (tab-separated-value) file into an Animation resource.|
|import_deferred_lipsync()|Imports lip sync to Animation but only after Rhubarb Lip Sync has finished generating the output lip sync file `(be careful with this as it yields until Rhubarb Lip Sync finishes generating lip sync)`|
|get_prestonblair_mouthtexture()|Returns a StreamTexture from a Rhubarb Lip Sync mouthshape input|
|get_mouthDB()|Returns a Dictionary with Mouthshape database from a mouthshape library

see [below](#function-usage) for a breakthrough of the function arguments.



# Function Usage


>## run_rhubarb_lipsync( )
|argument|type|description|
|-|-|-|
|path_input_audio|String|FilePath to audio file (should be .WAV or .OGG)
are_paths_absolute|bool|False for a relative path ``("res://")`` </br> True for an absolute path ``("C://")``
|length|float|Audio length in seconds 

>## import_lipsync( )
|argument|type|description|
|-|-|-|
|anim|Animation|Animation Resource Object from animationPlayer|
|animationPlayer|AnimationPlayer|AnimationPlayer Instance|
|audiokey|Dictionary|Data about the audio key from anim|
|audioPlayer|AudioStreamPlayer|AudioStreamPlayer Instance|
|mouthDB|Dictionary|Mouthshape database|
|extraParams|Array|Parameters for the lip sync import (Sprite / AnimatedSprite, Animation)|

>## import_deferred_lipsync( )
|argument|type|description|
|-|-|-|
|audiokey|Dictionary|Data about the audio key from anim_name's Animation|
|extraParams|Array|Parameters for the lip sync import (Sprite / AnimatedSprite, Animation)|
|audioPlayer|AudioStreamPlayer|AudioStreamPlayer Instance|
|animationPlayer|AnimationPlayer|AnimationPlayer Instance|
|anim_name|String|Animation resource's name from AnimationPlayer|
|mouthDB|Dictionary|Mouthshape database|

Requires that Rhubarb Lip Sync is run aswell, otherwise it yields forever and causes memory leak.

>## get_prestonblair_mouthtexture( )
|argument|type|description|
|-|-|-|
|rhubarb_shape|String|Rhubarb Lip Sync mouthshape ``("A", "B", "C")``
|mouthDB|Dictionary|Mouthshape texture database

>## get_mouthDB( )
|argument|type|description|
|-|-|-|
|mouth_library|String|Section in the ``mouthshape_libraries.ini`` config file|

# Disclaimer

Rhubarb Lip Sync Third Party Integration for Godot does not have warranty for any eventual issue and bug that may break your project. It is always advisable that you backup your project.
I don't assume any responsibility for any possible corruption or deletion of your files.
Please notice this addon doesn't come with Rhubarb Lip Sync's binary. It's advisable you only download Rhubarb from the official Rhubarb Lip Sync Github releases page. The plugin currently has no way to determine if the file is valid.

# Bug Report

If you encounter any errors, try opening Godot's Debug Console on Windows or start Godot from the terminal and replicate the problem.
When reporting an issue, make sure to include any errors printed there.
Rhubarb Lip Sync Third Party Integration for Godot