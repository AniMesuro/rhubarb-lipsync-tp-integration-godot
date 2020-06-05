tool
extends HBoxContainer


var settingsButton :TextureButton
var warningIcon :TextureRect
var label :Label

func _enter_tree() -> void:
	settingsButton = $SettingsButton
	warningIcon = $WarningIcon
	label = $Label
	disable_warning()
	
	var Settings :Dictionary= owner.pluginInstance.Settings
	if Settings == {}:
#		print('---InfoHBox enter_tree settings dict null')
		return
	
	if !Settings.has('rhubarb_lipsync'):
		print('ib settings dict has not rhubarb_lipsync section')
		enable_warning("Settings Dictionary is empty.")
		label.text = "Settings have not been correctly loaded."
		return
	if !Settings.rhubarb_lipsync.has('path'):
		print('ib settings.rhubarb_lipsync dict has not path key')
		enable_warning("Settings Dictionary doesn't have 'path' key or path key not set in Settings file")
		label.text = "Rhubarb Binary Filepath not set in Settings."
		return
	var Dir :Directory= Directory.new()
	
	if !Dir.file_exists(Settings.rhubarb_lipsync.path):
		print('rhubarb binary not found at path: "', Settings.rhubarb_lipsync.path, '"')
		label.text = 'Rhubarb Binary File not found at path "' + Settings.rhubarb_lipsync.path + '", please select the filepath from Plugin Settings. (Gear Icon at left)'
		enable_warning("Can't proceed. Rhubarb binary doesnt exist at path " + Settings.rhubarb_lipsync.path)
		return
	
#	print('OS execution ',OS.get_executable_path())
	if Settings.rhubarb_lipsync.path.get_extension() == OS.get_executable_path().get_extension(): # '.exe' = '.exe' in windows
#		print('filepath to rhubarb is binary')
		var rhubarb_dir :String= Settings.rhubarb_lipsync.path.get_base_dir()
#		print('rhub res folder '+rhubarb_dir+'/res/')
		if !Dir.dir_exists(rhubarb_dir+'/res/'):
			print('Rhubarb binary found but res folder not found')
			enable_warning("'res' folder comes with Rhubarb release and is needed for Rhubarb to work. Please drop it at the same path as Rhubarb Binary.")
			label.text = "Can't Proceed. Rhubarb binary found but can't call res folder."
			return
	disable_warning()
	label.text = 'Settings.'
	
	
	#check Settings for Godot binary filepath
	#if file not valid, enable warning
	pass

func enable_warning(message :String):
	warningIcon.visible = true
	warningIcon.hint_tooltip = message

func disable_warning():
	warningIcon.visible = false
