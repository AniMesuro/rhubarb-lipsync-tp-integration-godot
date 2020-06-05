tool
extends HBoxContainer


var settingsButton :TextureButton
var warningIcon :TextureRect
var warningLabel :Label

func _enter_tree() -> void:
	settingsButton = $SettingsButton
	warningIcon = $WarningIcon
	warningLabel = $WarningLabel
	disable_warning()
	
	
	warningLabel.text = ''
	
	
	#check Settings for Godot binary filepath
	#if file not valid, enable warning
	validate_rhubarb_path()

func validate_rhubarb_path() -> void:
	if !is_inside_tree():
		yield(self, "tree_entered")
	var Settings :Dictionary= owner.pluginInstance.Settings
	if Settings == {}:
#		print('---InfoHBox enter_tree settings dict null')
		return
	
	if !Settings.has('rhubarb_lipsync'):
		print('ib settings dict has not rhubarb_lipsync section')
		enable_warning("Settings Dictionary is empty.")
		warningLabel.text = "Settings have not been correctly loaded."
		return
	if !Settings.rhubarb_lipsync.has('path'):
		print('ib settings.rhubarb_lipsync dict has not path key')
		enable_warning("Settings Dictionary doesn't have 'path' key or path key not set in Settings file")
		warningLabel.text = "Rhubarb Binary Filepath not set in Settings."
		return
	var Dir :Directory= Directory.new()
	
	
#	print('rhubarb settings rhubarb =',Settings.rhubarb_lipsync.path)
	if !Dir.file_exists(Settings.rhubarb_lipsync.path):
		
		enable_warning('Rhubarb Binary File not found at path "' + Settings.rhubarb_lipsync.path + '", please select the filepath from Plugin Settings. (Gear Icon at left)')
		warningLabel.text = "Can't proceed. Rhubarb binary doesn't exist on path defined in Settings."
		return
	
	var file_basename :String= Settings.rhubarb_lipsync.path.get_basename().get_file()
	if file_basename != 'rhubarb':
		enable_warning("Please select the rhubarb file from Rhubarb Lipsync github releases page.")
		warningLabel.text = "Rhubarb file path at Settings calls to file not named rhubarb."
		return
	
#	print('OS execution ',OS.get_executable_path())
	var user_os :String = OS.get_name()
	match user_os:
		'X11': #Linux ?
			var rhubarb_dir :String= Settings.rhubarb_lipsync.path.get_base_dir()
			settingsButton.hint_tooltip = "It seems you're running a Linux distro. Plugin can't tell if file is binary as Rhubarb's release for linux doesn't have an extension."
			if !Dir.dir_exists(rhubarb_dir+'/res'):
				enable_warning("'res' folder comes with Rhubarb release and is needed for Rhubarb to work. Please drop it at the same path as Rhubarb Binary.")
				warningLabel.text = "Rhubarb Binary found but can't call 'res' folder."
				return
		_: # Others
			if Settings.rhubarb_lipsync.path.get_extension() == OS.get_executable_path().get_extension(): # '.exe' = '.exe' in windows
		#		print('filepath to rhubarb is binary')
				var rhubarb_dir :String= Settings.rhubarb_lipsync.path.get_base_dir()
				if !Dir.dir_exists(rhubarb_dir+'/res'):
					enable_warning("'res' folder comes with Rhubarb release and is needed for Rhubarb to work. Please drop it at the same path as Rhubarb Binary.")
					warningLabel.text = "Rhubarb Binary found but can't call 'res' folder."
					return
			else:
				enable_warning("Rhubarb file doesn't seem to be a Binary File. Please select the Rhubarb binary file specific to your OS.")
				warningLabel.text = Settings.rhubarb_lipsync.path
				return
			
#	if Settings.rhubarb_lipsync.path.get_extension() == OS.get_executable_path().get_extension(): # '.exe' = '.exe' in windows
##		print('filepath to rhubarb is binary')
#		var rhubarb_dir :String= Settings.rhubarb_lipsync.path.get_base_dir()
##		print('rhub res folder '+rhubarb_dir+'/res/')
#		if !Dir.dir_exists(rhubarb_dir+'/res/'):
#			print('Rhubarb binary found but res folder not found.')
#			enable_warning("'res' folder comes with Rhubarb release and is needed for Rhubarb to work. Please drop it at the same path as Rhubarb Binary.")
#			warningLabel.text = "Can't Proceed. Rhubarb binary found but can't call res folder."
#			return
#else:
#		enable_warning("Rhubarb file doesn't seem to be a Binary File. Please select the Rhubarb binary file specific to your OS.")
#		return
	disable_warning()
#	warningLabel = ""

func enable_warning(message :String):
	warningIcon.visible = true
	warningIcon.hint_tooltip = message
	warningLabel.visible = true

func disable_warning():
	warningIcon.visible = false
	warningLabel.visible = false
