@tool
extends HBoxContainer

const STR_DEFAULT :String= "Please select Lipsync output's desired directory."

var warningIcon :TextureRect
var button :Button

var path_plugin :String
var ForbiddenDirectory :Dictionary

var fileDialog :FileDialog

func _ready() -> void:
	button.pressed.connect( _on_Button_pressed)
	
	path_plugin = owner.pluginInstance.path_plugin
	ForbiddenDirectory = {
		'project': "res://",
		'import': "res://.import",
		'addons': "res://addons",
		'plugin': path_plugin.rstrip('/'),
		'assets': path_plugin + "assets",
		'interface': path_plugin + "interface",
		'RhubarbLipsyncImporter': path_plugin + "RhubarbLipsyncImporter",
		'settings_popup': path_plugin + "settings_popup"
	}
	button.text = STR_DEFAULT
	if owner.pluginInstance.Settings.has('output'):
		if owner.pluginInstance.Settings.output.has('path'):
			var Dir :Directory= Directory.new()
			if !Dir.dir_exists(owner.pluginInstance.Settings.output.path):
				enable_warning("Selected folder at Settings doesn't exist.")
				owner.pluginInstance.Settings.output.path = owner.pluginInstance.load_default_settings(['output','path'])
			if !is_dir_forbidden(owner.pluginInstance.Settings.output.path):
				button.text = owner.pluginInstance.Settings.output.path
			else:
				enable_warning("Output folder at Settings is forbidden directory.")
				owner.pluginInstance.Settings.output.path = owner.pluginInstance.load_default_settings(['output','path'])

func _enter_tree() -> void:
	button = $Button
	warningIcon = $WarningIcon
	
	button.hint_tooltip = "Please note that some files in the directory may get overwritten or deleted, so it's recommended you select an empty folder.\nIf the directory isn't valid id will be set to '_temp'"
	
	disable_warning()

func _on_Button_pressed():
	fileDialog= owner.fileDialog
	fileDialog.popup()
	
	fileDialog.mode = FileDialog.MODE_OPEN_DIR
	fileDialog.access = FileDialog.ACCESS_RESOURCES
	fileDialog.current_path = owner.pluginInstance.Settings.output.path
	
#	fileDialog.current_path
	
	fileDialog.dir_selected.connect(_on_FileDialog_dir_selected)
	fileDialog.connect("popup_hide", _on_FileDialog_hide)

func _on_FileDialog_dir_selected(dir :String):
	if !is_instance_valid(owner.pluginInstance):
		return
	if !owner.pluginInstance.Settings.has("output"):
		owner.pluginInstance.Settings.output = {}
		return
#	if !owner.pluginInstance.Settings.has("path"):
#		return
	var Dir :Directory= Directory.new()
	if !Dir.dir_exists(dir):
		button.text = STR_DEFAULT
		owner.pluginInstance.Settings.output.path = owner.pluginInstance.load_default_settings(['output','path'])
		return
	
	if is_dir_forbidden(dir):
		enable_warning("Selected directory is forbidden, please selected a safer folder.")
		button.text = STR_DEFAULT
		owner.pluginInstance.Settings.output.path = owner.pluginInstance.load_default_settings(['output','path'])
		return
	button.text = dir
	owner.pluginInstance.Settings.output.path = dir 
	disable_warning()
	

func _on_FileDialog_hide():
	fileDialog.disconnect("dir_selected", _on_FileDialog_dir_selected)
	fileDialog.disconnect("popup_hide", _on_FileDialog_hide)

func enable_warning(message :String):
	warningIcon.visible = true
	warningIcon.hint_tooltip = message

func is_dir_forbidden(directory :String):
	for forbidden_dir in ForbiddenDirectory.keys():
		if directory == ForbiddenDirectory[forbidden_dir]:
			return true
	return false

func disable_warning():
	warningIcon.visible = false
