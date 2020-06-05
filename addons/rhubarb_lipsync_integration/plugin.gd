tool
extends EditorPlugin

signal finished_generating_lipsync_data

#const PATH_SETTINGS :String= "res://addons/rhubarb_lipsync_importer/"
const FILENAME_SETTINGS :String= "settings.ini"

const IMPORT_LIPSYNC_SCRIPTNAME :String= "Rhubarb Lipsync TPI"
#const GENERATE_LIPFLAP_SCRIPTNAME :String= "Generate Lipflap Animation"

const SpeechRecognizer = {
	pocketSphinx = 'pocketSphinx',
	phonetic = 'phonetic'
}
enum CleanMode {
	Never,
	OpenPlugin,
	ClosePlugin
}

var path_plugin :String

var group_plugin :String= "plugin rhubarb_lipsync_integration"

var Settings :Dictionary

var rhubarbTimer :Timer
var timer_remainingcalls :int= 0

var lipsyncImporterPopup :Control

#---------------------------------------------------------------------------------------------------------------#
#   Please note that Rhubarb Lipsync is a command line tool by DanielSWolf that this plugin integrates to Godot.
#---------------------------------------------------------------------------------------------------------------#


func _enter_tree():
	_fix_pathplugin()
#	var scr :Script= get_script()
#	path_plugin = scr.resource_path.get_base_dir()+'/'
	load_settings()
	
	if !get_tree().has_group(group_plugin):
		add_to_group(group_plugin)
#	get_groups()
#	is_in_group(
	add_tool_menu_item(IMPORT_LIPSYNC_SCRIPTNAME, self, "_on_importLipsync_Run")
	_do_cleaning_routine(CleanMode.OpenPlugin)
#	print("Settings")

func _do_cleaning_routine(event :int):
	if !Settings.has("output"):
		load_settings()
	if !Settings.output.has("clean_mode"):
		load_settings()
	if !Settings.output.has("path"):
		load_settings()
	
	if Settings.output.clean_mode != event:
		return
	
	
	
	
	
	match event:
		CleanMode.Never:
			return
		CleanMode.OpenPlugin:
			Settings.cleaning = {}
			Settings.cleaning.batoto = "OpenPlugin"
			print('plugin_opened')
			
			_clean_files()
			
			save_settings()
		CleanMode.ClosePlugin:
#			Dir
#			Settings.output.path
			
			Settings.cleaning = {}
			Settings.cleaning.batata = "ClosePlugin"
			print('plugin_closed')
			
			_clean_files()
#			print(Settings.cleaning)
			save_settings()
	
func _clean_files():
	var Dir :Directory= Directory.new()
	if !Dir.dir_exists(Settings.output.path):
		Settings.bombom = {}
		Settings.bombom.chocolate = "atalho n existe"
		save_settings()
		Dir.make_dir(Settings.output.path)
		return
	
	var files :PoolStringArray = PoolStringArray([])
	if Dir.open(Settings.output.path) == OK:
		Dir.list_dir_begin(false, true)
		
		var file_path :String= Dir.get_next()
		while file_path != "":
			files.append(file_path)
			file_path = Dir.get_next()
		Dir.list_dir_end()
		
		for i in files.size():
			if files[i].get_extension() == "tsv":
				Dir.remove(files[i])
#				Settings.cleaning['file'+str(i)] = files[i]
	else:
		return
		
	
	
func _notification(what: int) -> void:
	match what:
		#Called when you quit to Godot Project List or call close project window (doesn't have to be confirmed quit)
		NOTIFICATION_WM_QUIT_REQUEST:
			_do_cleaning_routine(CleanMode.ClosePlugin)


func load_settings():
	load_default_settings()
	
	if path_plugin == "":
		_fix_pathplugin()
#	print('pathplugin =',path_plugin)
	var configFile :ConfigFile= ConfigFile.new()
	var err = configFile.load(path_plugin + FILENAME_SETTINGS)
	if err == OK:
		for section in configFile.get_sections():
			Settings[section] = {}
			for key in configFile.get_section_keys(section):
				Settings[section][key] = configFile.get_value(section, key)
		
		#Check if Settings file has empty sections
		for section in Settings:
			if !configFile.has_section(section):
				save_settings()
				break
	elif err == ERR_FILE_NOT_FOUND:
#		load_default_settings()
		save_settings()
#	print('Settings =',Settings)

func _fix_pathplugin():
	if !is_inside_tree():
		yield(self, "tree_entered")
	var scr :Script= get_script()
	path_plugin = scr.resource_path.get_base_dir()+'/'

func load_default_settings(keys :PoolStringArray= PoolStringArray([])):
	if path_plugin == "":
		_fix_pathplugin()
	var _default_settings :Dictionary= {
		'rhubarb_lipsync': {
			'path': "",
			'recognizer': SpeechRecognizer.pocketSphinx
		},
		'output': {
			'path': path_plugin+'_temp/',
			'clean_mode': CleanMode.Never
		}
	}
	
	if keys == PoolStringArray([]):
		Settings = _default_settings
		return
	else:
		var str_default_settings :String= "_default_settings"#_default_settings"
		for section in _default_settings:
			if section == keys[0]:
				if keys.size() == 1:
					return _default_settings[section]
				else:
					for def_key in _default_settings[section]:
						if keys.size() == 2:
							return _default_settings[section][def_key]
						else:
							return
		return
#WHY IS THIS NOT WORKINGNNGNGNNG. :( AAAAAAAAAAAAAAAAA.
#			str_default_settings = str_default_settings+ ".get(keys[" + str(i)+ "])"#str_default_settings.insert(str_default_settings.length(), key'.')
#			str_default_settings = str_default_settings+ "[" + key + "]"
#			str_default_settings = str_default_settings.insert(str_default_settings.length(), ']')
#		str_default_settings = str_default_settings.trim_prefix('.')
		
#		print('str ', str_default_settings)
#		print('get ', _default_settings.get(keys[0]).get(keys[1]) )
#		return get(str_default_settings)
		
		#get(str_default_settings)

func save_settings():
	if path_plugin == "":
		_fix_pathplugin()
	var configFile = ConfigFile.new()
	var err = configFile.load(path_plugin + FILENAME_SETTINGS)
	if err == OK or err == ERR_FILE_NOT_FOUND:
		for section in Settings:
			for key in Settings[section]:
				configFile.set_value(section, key, Settings[section][key])
#	print("trying to save at ",path_plugin + FILENAME_SETTINGS)
	configFile.save(path_plugin + FILENAME_SETTINGS)
	

func _on_importLipsync_Run(event) -> void:
	if path_plugin == "":
		_fix_pathplugin()
	lipsyncImporterPopup = load(path_plugin + "RhubarbLipsyncImporter/LipsyncImporterPopup.tscn").instance()
	add_child(lipsyncImporterPopup)
	lipsyncImporterPopup.find_node('Panel').rect_position = OS.window_position + OS.window_size*.5 - lipsyncImporterPopup.find_node('Panel').rect_size*.5
	lipsyncImporterPopup.pluginInstance = self


func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		for child in get_children():
			if !child.is_queued_for_deletion():
				child.queue_free()
#		if is_instance_valid(rhubarbTimer):
#			rhubarbTimer.queue_free()

func _exit_tree():
#	remove_custom_type("LipsyncImporter")
	remove_tool_menu_item(IMPORT_LIPSYNC_SCRIPTNAME)
	
	_do_cleaning_routine(CleanMode.ClosePlugin)
	save_settings()

#Executes Rhubarb binary from the Settings.rhubarb_lipsync.path filepath.
#The program should generate lipsync externally to the Settings.output.path directory.
func run_rhubarb_lipsync(path_input_audio :String, are_paths_absolute :bool= false, length :float= 0.0): #Signal should send output path to Connect.
#	print('Rhubarb function, Settings =',Settings)
	if !Settings.has('rhubarb_lipsync'):
		print('settings dict has no rhubarb_lipsync section.')
		return
	if !Settings.rhubarb_lipsync.has('path'):
		print('settings dict has no rhubarb_lipsync path key or key is invalid filepath.')
		return
	
	var dir:Directory= Directory.new()
	if !dir.dir_exists(Settings.output.path):
		dir.make_dir_recursive(Settings.output.path)
		
	#TODO: Check if path is rhubarb
	
	var input_filename = path_input_audio.get_basename().get_file()
#	print('input_filename =',input_filename)
	
	var gpath_rhubarb :String= ProjectSettings.globalize_path(Settings.rhubarb_lipsync.path)
	var gpath_input_audio :String= ProjectSettings.globalize_path(path_input_audio)
	var gpath_output_data :String= ProjectSettings.globalize_path(Settings.output.path + input_filename + '.tsv')
#	return
	
#	print('going to execute rhubarb at', gpath_rhubarb)
	var pid = OS.execute(
		gpath_rhubarb,[
			"-o",
				gpath_output_data,#Output filepath
				gpath_input_audio,#WAV filepath
			"-r", Settings.rhubarb_lipsync.recognizer,#Speech Recognizer
			"-f", "tsv",#File format
			"--extendedShapes", "GHX"#Additional Mouthshapes
		],
		false
	)
	if pid == -1:
		print("Error. Rhubarb binary file didn't execute successfully.")
		return
	print('Rhubarb binary file executed succesfully. Check Debug Console for Progress or Errors. Please DO NOT change scene while rhubarb is running as node references might get confused.')
	
#	Gross and hacky workaround, ideally the progress bar should show in the Editor
#	or at least printed also on the Editor Console.
#	But Godot doesn't seem to have an "process_died(pid)" signal.

	var Dir = Directory.new()
	if Dir.file_exists(gpath_output_data):
		Dir.remove(gpath_output_data)
		print("File at "+gpath_output_data+" already exists, so it'll be overwritten")
	
	if is_instance_valid(rhubarbTimer):
		rhubarbTimer.queue_free()
	rhubarbTimer = Timer.new()
#	print('root =',get_tree().root)
	get_tree().root.add_child(rhubarbTimer)
	
#	var call_length :int= length * 2.5
#	if length >= 5.0:
#		call_length = ceil(length)
#	else:
#		call_length = 5
	var timer_max_calls :int= ceil(length * 0.33 * 2.5) #0.2 = portions of 5sec | 0.33 portions of 3sec
	timer_max_calls = clamp(timer_max_calls, 20, 84) #20 calls = 1min | 84= 7min
	print('length =',length)
	print('timer_max_calls =',timer_max_calls)
	var timer_sec :int= 3
	print("Rhubarb is generating lipsync... This may take up to a few minutes. (NOT A ESTIMATE) Plugin will wait for max. "+str(timer_sec * timer_max_calls)+' sec')
	
	rhubarbTimer.start(timer_sec)
	timer_remainingcalls = timer_max_calls
	rhubarbTimer.connect( "timeout", self, "_on_RhubarbTimer_timeout", [gpath_output_data, input_filename, timer_sec, timer_max_calls])
	
#	for i in timer_max_calls:
#		yield(rhubarbTimer, "timeout")
#		if Dir.file_exists(gpath_output_data):
#			print("Rhubarb finished generating "+input_filename+".tsv file.")
#			emit_signal("finished_generating_lipsync_data")
#
#			return
		
#		if i == timer_max_calls:
	
func _on_RhubarbTimer_timeout(output_filepath :String, input_filename :String, timer_sec :int, timer_max_calls :int= 12):
	timer_remainingcalls -= 1
		
	var Dir :Directory= Directory.new()
	if Dir.file_exists(output_filepath):
		print("Rhubarb finished generating "+input_filename+".tsv file.")
		emit_signal("finished_generating_lipsync_data")
		rhubarbTimer.disconnect("timeout", self, "_on_RhubarbTimer_timeout")
		if !rhubarbTimer.is_queued_for_deletion():
			rhubarbTimer.queue_free()
		return
	if timer_remainingcalls <= 0:
		rhubarbTimer.disconnect("timeout", self, "_on_RhubarbTimer_timeout")
		print("Plugin gave up on waiting for Rhubarb to generate file. This could be because there was an error with Rhubarb generating lipsync, but is probably just because it's taking more than the Timer limit ("+str(timer_sec * timer_max_calls)+" seconds)")
		if !rhubarbTimer.is_queued_for_deletion():
			rhubarbTimer.queue_free()
		return
	if !rhubarbTimer.is_connected("timeout", self, "_on_RhubarbTimer_timeout"):
		if !rhubarbTimer.is_queued_for_deletion():
			rhubarbTimer.queue_free()
		return
	rhubarbTimer.start(timer_sec)

#Converts a Rhubarb mouthshape (A,B,C) to PrestonBlair (MBP,etc,E)
func get_prestonblair_mouthtexture(rhubarb_shape :String, mouthDB :Dictionary) -> StreamTexture:
	var shape :String
	match rhubarb_shape:
		'A':
			return mouthDB['MBP']
		'B':
			return mouthDB['etc']
		'C':
			return mouthDB['E']
		'D':
			return mouthDB['AI']
		'E':
			return mouthDB['O']
		'F':
			return mouthDB['U']
		'G':
			return mouthDB['FV']
		'H':
			return mouthDB['L']
		'X':
			return mouthDB['rest']
		_:
			return null

#Only execute importing when Rhubarb has finished generating lipsync data.
func import_deferred_lipsync(
 audiokey :Dictionary,
 mouthSprite :Sprite,
 audioPlayer :AudioStreamPlayer,
 animationPlayer :AnimationPlayer,
 anim_name :String,
 mouthDB :Dictionary
 ): #override_region :bool= false
#	var anim :Animation= animationPlayer.get_animation(anim_name)
#	var editedSceneRoot :Node= get_tree().edited_scene_root
#	var anim_root :Node= animationPlayer.get_node(animationPlayer.root_node)
#
#	var tr_mouth_texture :int= anim.find_track(str(anim_root.get_path_to(mouthSprite))+':texture')
#	var tr_audio :int= anim.find_track(anim_root.get_path_to(audioPlayer))
#
#	if tr_mouth_texture == -1: #If mouthSprite:texture track doesn't exist, create one.
#		tr_mouth_texture = anim.add_track(Animation.TYPE_VALUE)
#		anim.track_set_path(tr_mouth_texture, str(anim_root.get_path_to(mouthSprite))+':texture')
	var anim = animationPlayer.get_animation(anim_name)
	print('import called on plugin script.')
	yield(self, "finished_generating_lipsync_data")
	import_lipsync(
		anim,
		animationPlayer,
		audiokey,
		audioPlayer,
		mouthDB,
		mouthSprite
	)
	print("Importing Lipsync to selected Animation...")
	
	

#Not implemented yet.
#This will import lipsync files by code.
func import_lipsync(
 anim :Animation,
 animationPlayer :AnimationPlayer,
 audiokey :Dictionary,
 audioPlayer :AudioStreamPlayer,
 mouthDB :Dictionary,
 mouthSprite :Sprite
 ):
	var anim_root :Node= animationPlayer.get_node(animationPlayer.root_node)
	
	var tr_mouth_texture :int= anim.find_track(str(anim_root.get_path_to(mouthSprite))+':texture')
	var tr_audio :int= anim.find_track(anim_root.get_path_to(audioPlayer))
	
	if tr_mouth_texture == -1: #If mouthSprite:texture track doesn't exist, create one.
		tr_mouth_texture = anim.add_track(Animation.TYPE_VALUE)
		anim.track_set_path(tr_mouth_texture, str(anim_root.get_path_to(mouthSprite))+':texture')
	
	
	var lipsync_filepath = Settings.output.path + audiokey.stream.resource_path.get_basename().get_file()+'.tsv'
	var f = File.new()
	if !f.file_exists(lipsync_filepath):
		print("Importing tried to start, but lipsync file was not found.")
		return
	f.open(lipsync_filepath, f.READ)
	var ls_text :String= f.get_as_text() #lipsync_data
	f.close()
	
	
	var ls_line :PoolStringArray= ls_text.split("\n")
#	print(ls_line)
#	var ls_data :PoolStringArray= []
	
#	ls_data.resize(ls_line.size())
	var lipsync_start_time :float= audiokey.time - audiokey.start_offset
	var lipsync_end_time :float= audiokey.time + audiokey.stream.get_length() - audiokey.start_offset - audiokey.end_offset
	
	for line in ls_line.size():
		var sample :PoolStringArray= ls_line[line].split("	", false, 2)
		if sample.size() <= 1:
			break
		
		var cur_time :float= lipsync_start_time + float(sample[0]) #- audiokey.start_offset
		#If key happens before the audiokey, ignore key.
		if cur_time < lipsync_start_time + audiokey.start_offset:
			continue
		#If key happens after the audiokey, ignore the rest of the keys.
		if cur_time > lipsync_end_time:
			break
		var mouthshape :StreamTexture= get_prestonblair_mouthtexture(sample[1], mouthDB)
		anim.track_insert_key(
		 tr_mouth_texture,
		 lipsync_start_time + float(sample[0]),
		 mouthshape, 0)
	
	print('Importing finished.')