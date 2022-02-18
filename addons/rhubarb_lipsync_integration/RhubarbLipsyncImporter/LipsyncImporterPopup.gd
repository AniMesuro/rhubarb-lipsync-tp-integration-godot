@tool
extends Control

signal updated_reference (reference_name)
signal parameters_reset

const STR_ERROR_not_enough_references :String= "Can't proceed. Some references are missing."
const STR_ERROR_plugin_reference_not_valid :String= "Can't proceeed. Rhubarb Lipsync TPI Plugin Reference not valid."
const STR_ERROR_SpriteFrames_not_enough_frames :String= "Can't proceed. SpriteFrames has no frames."

const TEX_IconExpand :StreamTexture2D= preload("res://addons/rhubarb_lipsync_integration/assets/icons/icon_expand.png")

var handlerTop :ReferenceRect
var handlerBottom :ReferenceRect
var handlerLeft :ReferenceRect
var handlerRight :ReferenceRect

# Sprite Tab
var anim_mouthSprite 
# AnimatedSprite Tab
var anim_mouthAnimSprite
var anim_mouthAnimSprite_anim :String

var anim_audioPlayer
var anim_animationPlayer :AnimationPlayer
var anim_name :String
var anim_audiokey :Dictionary

var mouthDB :Dictionary= {}
var lipsync_data :String= ""

var pluginInstance :EditorPlugin
var path_plugin :String

# Sprite tab
@onready var mouthTextures :VBoxContainer= $Panel/VBox/TabContainer/Sprite.find_node('MouthTextures')
@onready var mouthFrames :VBoxContainer= $Panel/VBox/TabContainer/AnimatedSprite.find_node('MouthFrames')
@onready var mouthSpriteHBox = $Panel/VBox/TabContainer/Sprite.find_node("MouthSpriteHBox")

@onready var animateButton = find_node("AnimateButton")

@onready var animationPlayerHBox = find_node("AnimationPlayerHBox")
@onready var animationNameHBox = find_node("AnimationNameHBox")
@onready var audioTrackHBox = find_node("AudioTrackHBox")
@onready var audioKeyHBox = find_node("AudioKeyHBox")

#Change scene in Editor
#Open scene in Editor (executes first than _ready)
func _enter_tree() -> void:
	pluginInstance = _get_pluginInstance()
	pluginInstance.load_settings()
	
	if !pluginInstance.is_connected("scene_changed", _on_scene_changed):
		pluginInstance.connect("scene_changed", _on_scene_changed)

func _get_pluginInstance() -> EditorPlugin:
	if get_tree().has_group("plugin rhubarb_lipsync_integration"):
		var plugin_group :Array= get_tree().get_nodes_in_group("plugin rhubarb_lipsync_integration")
		for node in plugin_group:
			if node is EditorPlugin:
				path_plugin = node.path_plugin
				return node
	return null

####	#For some reason this major bug was fixed and I didn't even touch it... Ok.
#	if get_tree().edited_scene_root != self:
#		print("Please do not change scene in editor while this window is open.")

func get_relevant_children() -> Array:
	var editedSceneRoot = get_tree().edited_scene_root
	var edited_scene_tree :Array= []
	
	#For each child and its 5 children layers, reference itself to the edited_scene_tree Array
	for child in editedSceneRoot.get_children():
		edited_scene_tree.append(child)
		
		for child_a in child.get_children():
			edited_scene_tree.append(child_a)
			
			for child_b in child_a.get_children():
				edited_scene_tree.append(child_b)
				
				for child_c in child_b.get_children():
					edited_scene_tree.append(child_c)
					
					for child_d in child_c.get_children():
						edited_scene_tree.append(child_d)
						
						for child_e in child_d.get_children():
							edited_scene_tree.append(child_e)
	return edited_scene_tree


#Same function as plugin.gd - Get a texture from a Rhubarb Mouthshape "A, B, C"
func get_prestonblair_mouthtexture(rhubarb_shape :String) -> StreamTexture2D:
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

var editedSceneRoot
func _on_AnimateButton_pressed() -> void:
	if !is_instance_valid(pluginInstance):
		print(STR_ERROR_plugin_reference_not_valid)
		queue_free()
		return
		
#	Makes sure all references are called for importing.
	
	if $Panel/VBox/TabContainer.current_tab == 0: # Sprite Tab
		print(anim_mouthSprite)
		if !is_instance_valid(anim_mouthSprite):
			print(STR_ERROR_not_enough_references)
			queue_free()
			return
	elif $Panel/VBox/TabContainer.current_tab == 1: #AnimatedSprite Tab
		if !is_instance_valid(anim_mouthAnimSprite):
			print(STR_ERROR_not_enough_references )
			queue_free()
			return
		if !anim_mouthAnimSprite.frames.has_animation(anim_mouthAnimSprite_anim):
			print(STR_ERROR_not_enough_references)
			queue_free()
			return
			
		if anim_mouthAnimSprite.frames.get_frame_count(anim_mouthAnimSprite_anim) == 0:
			print(STR_ERROR_SpriteFrames_not_enough_frames)
			queue_free()
			return
			
	if !is_instance_valid(anim_animationPlayer):
		print(STR_ERROR_not_enough_references)
		queue_free()
		return
	if !is_instance_valid(anim_audioPlayer):
		print(STR_ERROR_not_enough_references)
		queue_free()
		return
	if !anim_animationPlayer.has_animation(anim_name):
		print(STR_ERROR_not_enough_references)
		queue_free()
		return
	if anim_audiokey == {}:
		print(STR_ERROR_not_enough_references)
		queue_free()
		return
	
	pluginInstance.load_settings()
	var path_audioclip
	path_audioclip = anim_audiokey.stream.resource_path
	
	#Saves a sliced wav from audiokey if audio has any offset.
#	var sliced_output_filename :String= ""
	if anim_audiokey.start_offset != 0 or anim_audiokey.end_offset != 0:
		if anim_audiokey.stream is AudioStreamSample:
			path_audioclip = slice_audio(anim_audiokey)
			anim_audiokey.sliced_path = path_audioclip
#			sliced_output_filename = slice_audio(anim_audiokey)
#	queue_free()
#	return
	
	var length = anim_audiokey.stream.get_length()
	if anim_audiokey.has('sliced_path'):
		length -= anim_audiokey.start_offset + anim_audiokey.end_offset

	pluginInstance.run_rhubarb_lipsync(path_audioclip, false, length)
	
	if $Panel/VBox/TabContainer.current_tab == 0:
		mouthDB = mouthTextures.mouthDB
		pluginInstance.import_deferred_lipsync(anim_audiokey, [anim_mouthSprite], anim_audioPlayer, anim_animationPlayer, anim_name, mouthTextures.mouthDB)
	elif $Panel/VBox/TabContainer.current_tab == 1:
		pluginInstance.import_deferred_lipsync(anim_audiokey, [anim_mouthAnimSprite, anim_mouthAnimSprite_anim], anim_audioPlayer, anim_animationPlayer, anim_name, mouthFrames.mouthDB)
	queue_free()
	return

func slice_audio(anim_audiokey :Dictionary) -> String:
	if !is_instance_valid(anim_audiokey.stream):
		print('sample not valid')
		return ""
	var new_stream :AudioStreamSample= AudioStreamSample.new()
	var new_data = [] + anim_audiokey.stream.data
	
	if !anim_audiokey.stream is AudioStreamSample:
		return ""
	new_stream.format = anim_audiokey.stream.format
	new_stream.stereo = anim_audiokey.stream.stereo
	new_stream.mix_rate = anim_audiokey.stream.mix_rate
	
	
	#Byte quantity
#	print(new_data.size())
#	print(new_stream.mix_rate)
#	print(new_data.size()/new_stream.mix_rate)
#	print(new_data.size()/new_stream.mix_rate/4) #64bits?
	
	#Slice end_offset
	var end_offset_bytesize :int= anim_audiokey.end_offset * new_stream.mix_rate * 4
	new_data.resize(new_data.size() - end_offset_bytesize)
	
	#Slice start offset
	var start_offset_bytesize :int= anim_audiokey.start_offset * new_stream.mix_rate * 4
	new_data.invert()
	new_data.resize(new_data.size() - start_offset_bytesize)
	new_data.invert()
	
#		print(anim_audiokey)
	new_stream.data = new_data
	var output_path :String= pluginInstance.Settings.output.path + "SLICED +"+str(snapped(anim_audiokey.start_offset, 0.01))+" -"+str(snapped(anim_audiokey.end_offset, 0.01))+" = "+anim_audiokey.stream.resource_path.get_file()
	if new_stream.save_to_wav(output_path) == OK:
		return output_path
	return ""

func _on_scene_changed(sceneRoot :Node):
	anim_animationPlayer = null
	anim_audioPlayer = null
	anim_mouthAnimSprite = null
	anim_mouthAnimSprite_anim = ""
	anim_mouthSprite = null
	anim_name = ""
	anim_audiokey = {}
	emit_signal("updated_reference", "anim_animationPlayer")
	emit_signal("parameters_reset")
