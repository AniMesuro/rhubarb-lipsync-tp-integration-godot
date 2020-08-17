tool
extends Control

signal updated_reference (reference_name)

const STR_ERROR_not_enough_references :String= "Can't proceed. Some references are missing."
const STR_ERROR_plugin_reference_not_valid :String= "Can't proceeed. Rhubarb Lipsync TPI Plugin Reference not valid."

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

# Sprite tab
onready var mouthTextures :VBoxContainer= $Panel/VBox/TabContainer/Sprite.find_node('MouthTextures')
onready var mouthSpriteHBox = $Panel/VBox/TabContainer/Sprite.find_node("MouthSpriteHBox")

onready var animateButton = find_node("AnimateButton")

onready var animationPlayerHBox = find_node("AnimationPlayerHBox")
onready var animationNameHBox = find_node("AnimationNameHBox")
onready var audioTrackHBox = find_node("AudioTrackHBox")
onready var audioKeyHBox = find_node("AudioKeyHBox")

#Change scene in Editor
#Open scene in Editor (executes first than _ready)
func _enter_tree() -> void:
	pluginInstance = _get_pluginInstance()
	pluginInstance.load_settings()
	

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
	if !is_instance_valid(pluginInstance):
		print(STR_ERROR_plugin_reference_not_valid)
		queue_free()
		return
		
#	Makes sure all references are called for importing.
	
	if !is_instance_valid(anim_mouthSprite):
		print(STR_ERROR_not_enough_references)
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
	var path_audioclip = anim_audiokey.stream.resource_path
	pluginInstance.run_rhubarb_lipsync(path_audioclip, false, anim_audiokey.stream.get_length())
	
	
	mouthDB = mouthTextures.mouthDB
	pluginInstance.import_deferred_lipsync(anim_audiokey, anim_mouthSprite, anim_audioPlayer, anim_animationPlayer, anim_name, mouthTextures.mouthDB)
	queue_free()
	return
