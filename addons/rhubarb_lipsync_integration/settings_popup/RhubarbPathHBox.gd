@tool
extends HBoxContainer

const STR_DEFAULT :String= "Please select Rhubarb's filepath."

var label :Label
var button :Button
var warningIcon :TextureRect

func _ready() -> void:
	button.connect("pressed", _on_button_pressed)
#	owner.connect("updated_settings", self, '_on_updated_settings()')

func _on_updated_settings():
	check_for_warnings()

func check_for_warnings():
	label = $Label
	button = $Button
	warningIcon = $WarningIcon
	var Settings :Dictionary= owner.pluginInstance.Settings
	if Settings == {}:
		return
	
	if !Settings.has('rhubarb_lipsync'):
		enable_warning("Settings Dictionary is empty.")
		button.text = "Settings File has not been correctly loaded."
		return
	if !Settings.rhubarb_lipsync.has('path'):
		enable_warning("Settings path key not set in Settings file")
		button.text = STR_DEFAULT
		return
	button.hint_tooltip = Settings.rhubarb_lipsync.path
	var Dir :Directory= Directory.new()
	
	if !Dir.file_exists(Settings.rhubarb_lipsync.path):
		button.text = "Rhubarb Binary File not found at path"
		enable_warning("Can't proceed. Rhubarb binary doesnt exist at path " + Settings.rhubarb_lipsync.path)
		return
	
	var file_basename :String= Settings.rhubarb_lipsync.path.get_basename().get_file()
	if file_basename != 'rhubarb':
		enable_warning("Please select the rhubarb file from Rhubarb Lipsync github releases page.")
		button.text = Settings.rhubarb_lipsync.path
		return
	
	var user_os :String = OS.get_name()
	match user_os:
		'X11','OSX': #Linux ? Mac ?
			var rhubarb_dir :String= Settings.rhubarb_lipsync.path.get_base_dir()
			button.hint_tooltip = "It seems you're running a Linux distro/Mac OS. Plugin can't tell if file is binary as Rhubarb's release for linux/mac doesn't have an extension."
			if !Dir.dir_exists(rhubarb_dir+'/res'):
				enable_warning("'res' folder comes with Rhubarb release and is needed for Rhubarb to work. Please drop it at the same path as Rhubarb Binary.")
				button.text = "Rhubarb Binary found but can't call 'res' folder."
				return
		_: # Others
			if Settings.rhubarb_lipsync.path.get_extension() == OS.get_executable_path().get_extension(): # '.exe' = '.exe' in windows
		#		print('filepath to rhubarb is binary')
				var rhubarb_dir :String= Settings.rhubarb_lipsync.path.get_base_dir()
				if !Dir.dir_exists(rhubarb_dir+'/res'):
					enable_warning("'res' folder comes with Rhubarb release and is needed for Rhubarb to work. Please drop it at the same path as Rhubarb Binary.")
					button.text = "Rhubarb Binary found but can't call 'res' folder."
					return
			else:
				enable_warning("Rhubarb file doesn't seem to be a Binary File. Please select the Rhubarb binary file specific to your OS.")
				button.text = Settings.rhubarb_lipsync.path
				return
	disable_warning()
	button.text = Settings.rhubarb_lipsync.path

func _enter_tree() -> void:
	check_for_warnings()
	
var fileDialog :FileDialog
func _on_button_pressed():
	fileDialog = owner.fileDialog
	fileDialog.popup()
	var bin_extension :String= OS.get_executable_path().get_extension()
	var os_name :String= OS.get_name()
	fileDialog.filters = ['rhubarb.'+bin_extension+' ; Rhubarb Binary file for ' + os_name + ' OS']
	
	fileDialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	fileDialog.access = FileDialog.ACCESS_FILESYSTEM
	
	var global_pluginpath = ProjectSettings.globalize_path(owner.pluginInstance.path_plugin) 
	fileDialog.current_dir = global_pluginpath
	
	fileDialog.connect("file_selected", _on_fileDialog_file_selected)
	fileDialog.connect("popup_hide", _on_fileDialog_hide)


func _on_fileDialog_file_selected(filepath :String):
	
	var f :File= File.new()
	if !f.file_exists(filepath):
		enable_warning("File not found from filepath.")
		return
	
	var bin_extension :String= OS.get_executable_path().get_extension()
	if filepath.get_extension() != bin_extension:
		enable_warning('Selected file is not a binary file.')
		return
	
	if owner.pluginInstance.Settings == {}:
		owner.pluginInstance.load_default_settings()
	owner.pluginInstance.Settings.rhubarb_lipsync.path = filepath
	button.hint_tooltip = filepath
	button.text = filepath
	disable_warning()
	owner.emit_signal('updated_settings')

func _on_fileDialog_hide():
	fileDialog.disconnect("file_selected", _on_fileDialog_file_selected)
	fileDialog.disconnect("popup_hide", _on_fileDialog_hide)

func enable_warning(message :String):
	warningIcon.visible = true
	warningIcon.hint_tooltip = message

func disable_warning():
	warningIcon.visible = false
