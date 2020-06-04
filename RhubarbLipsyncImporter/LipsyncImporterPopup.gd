tool
extends Control

signal updated_reference (reference_name)

var handlerTop :ReferenceRect
var handlerBottom :ReferenceRect
var handlerLeft :ReferenceRect
var handlerRight :ReferenceRect


var anim_mouthSprite :Sprite
var anim_audioPlayer :AudioStreamPlayer
var anim_animationPlayer :AnimationPlayer
var anim_name :String
var anim_audiokey :Dictionary

var mouthDB :Dictionary= {}
var lipsync_data :String= ""

var pluginInstance :EditorPlugin
var path_plugin :String

onready var mouthTextures :VBoxContainer= find_node('MouthTextures')
onready var animateButton = find_node("AnimateButton")

onready var mouthSpriteHBox = find_node("MouthSpriteHBox")
onready var animationPlayerHBox = find_node("AnimationPlayerHBox")
onready var animationNameHBox = find_node("AnimationNameHBox")
onready var audioTrackHBox = find_node("AudioTrackHBox")
onready var audioKeyHBox = find_node("AudioKeyHBox")

#Change scene in Editor
#Open scene in Editor (executes first than _ready)
func _enter_tree() -> void:
	
#	if get_tree().edited_scene_root == self:
#		print(self,' is being edited')
		
	
#	print('groups ', get_tree().get_groups())
	pluginInstance = _get_pluginInstance()
	pluginInstance.load_settings()
#	if !is_inside_tree():
#		yield(self, "tree_entered")
#	print('parent =',get_parent(),'='+get_parent().name)
#	print('tree finiished entering, plugininstance ', pluginInstance)
#	print('pluginpath =', path_plugin)
	
	yield(get_tree(), "idle_frame")
#	print('pluginpath defferedframe =', path_plugin)
	

func _get_pluginInstance() -> EditorPlugin:
#	if !get_tree().has_group("plugin rhubarb_lipsync_integration"):
#		print('tree has not plugin group')
#		add_to_group("plugin rhubarb_lipsync_integration" )
	if get_tree().has_group("plugin rhubarb_lipsync_integration"):
#		print('tree has plugin group')
		var plugin_group :Array= get_tree().get_nodes_in_group("plugin rhubarb_lipsync_integration")
		for node in plugin_group:
			if node is EditorPlugin:
				return node
				path_plugin = node.path_plugin
#				print('editorplugin is called in group')
				break
	return null

func _ready() -> void:
#	if !is_inside_tree():
#		yield(self, "tree_entered")
#	print('parent =',get_parent(),'='+get_parent().name)
	path_plugin = pluginInstance.path_plugin
#	print("lipsyncpopup ready pluginInstance ",str(pluginInstance))
	if get_tree().edited_scene_root != self:
		print("Please do not change scene in editor while this window is open.")

func get_relevant_children() -> Array:
	var editedSceneRoot = get_tree().edited_scene_root
	var edited_scene_tree :Array= []
	
	
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



func get_prestonblair_mouthtexture(rhubarb_shape :String) -> StreamTexture:
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
#	print(mouthTextures.mouthDB)
#	return
	
	
	if !is_instance_valid(pluginInstance):
		print("Can't Proceed. Failed to call Plugin Instance.")
		return
		
#	Makes sure all references are called.
	
	if !is_instance_valid(anim_mouthSprite):
		return
	if !is_instance_valid(anim_animationPlayer):
		return
	if !is_instance_valid(anim_audioPlayer):
		return
	if !anim_animationPlayer.has_animation(anim_name):
		return
	if anim_audiokey == {}:
		return
	
	pluginInstance.load_settings()
	var path_audioclip = anim_audiokey.stream.resource_path
	pluginInstance.run_rhubarb_lipsync(path_audioclip)
	
	
#	print("starting to import lipsync")
	mouthDB = mouthTextures.mouthDB
	pluginInstance.import_deferred_lipsync(anim_audiokey, anim_mouthSprite, anim_audioPlayer, anim_animationPlayer, anim_name, mouthTextures.mouthDB)
	queue_free()
	return
#	TEMPORARY RETURN









#	editedSceneRoot = get_tree().edited_scene_root
#	if !(is_instance_valid(anim_mouthSprite)
#	&&  is_instance_valid(anim_animationPlayer)):
#		if is_queued_for_deletion():
#			return
#		queue_free()
#		print("Couldn't import lipsync animation, not all nodes are assigned.")
#		return
#	if !anim_animationPlayer.has_animation(anim_name):
#		print("Couldn't import lipsync animation, Animation not found on selected AnimationPlayer.")
#		return
#
##	print(lipsync_data)
#	var lipsync_table :PoolStringArray
#	lipsync_table = lipsync_data.split("\n")
##	print(lipsync_table)
#	mouthDB = mouthTextures.mouthDB
#	print(mouthDB)
	
	#Animate
#	var animation :Animation= anim_animationPlayer.get_animation(anim_name)
#
#	var anim_root = anim_animationPlayer.get_node(anim_animationPlayer.root_node)
#	print('anim_root ',anim_root)
#
#	var track_mouth :int= animation.find_track(str(anim_root.get_path_to(anim_mouthSprite))+':texture')
#	if track_mouth == -1: #didnt find
#		track_mouth = animation.add_track(Animation.TYPE_VALUE)
#		animation.track_set_path(track_mouth, str(anim_root.get_path_to(anim_mouthSprite))+':texture')
	
#	for line in lipsync_table:
#		#[Time in seconds, mouth_shape]
#		var sample :PoolStringArray= line.split("	", false, 2)
##		print(sample)
#		if sample.size() < 2:
#			print('lipsync sample not valid')
#			return
#		var mouth_shape :StreamTexture= get_prestonblair_mouthtexture(sample[1])
#		if mouth_shape == null:
#			return
#		animation.track_insert_key(track_mouth, float(sample[0]), mouth_shape)
	
	#Find audio start point and end point
#	var track_audio_keycount :int= animation.track_get_key_count(track_audio)
#	print('audio has ', track_audio_keycount, ' keys')
#	if track_audio_keycount == 0:
#		print("Couldn't generate lipflap animation, audio track found but has no audio key")
#		queue_free()
#		return
#	var audio_key :Array= []
#	audio_key.append(
#		{'id': animation.audio_track_get_key_stream(track_audio, 0),
#		'start_offset': animation.audio_track_get_key_start_offset(track_audio, 0),
#		'end_offset': animation.audio_track_get_key_end_offset(track_audio, 0),
#		'stream': animation.audio_track_get_key_stream(track_audio, 0).data}
#	)
#	print('audio key array =', audio_key)
#	var stream_length = audio_key[0].stream
#	print('audio stream size =', str(audio_key[0].stream.size()))
	
#	var d = Dire
	
	
#	if is_queued_for_deletion():
#		queue_free()
#		return
#	queue_free()

