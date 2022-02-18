@tool
extends VBoxContainer
#meio inutil, vou ter que mudar a textura de qualquer jeito
@export var mouth_shape:String = "rest":
	set = _set_mouth_shape
@export var default_mouth:int = 0:
	set = _set_default_mouth

const TEX_InvalidFrame :StreamTexture2D= preload("res://addons/rhubarb_lipsync_integration/assets/icons/icon_warning.png")

var mouthFrames :Control
var textureButton :TextureButton

func _ready() -> void:
	if get_tree().edited_scene_root == self:
		return
	
	textureButton = $Texture
	
	mouthFrames = get_parent()
	if !is_inside_tree():
		await tree_entered
	if !is_instance_valid(mouthFrames):
		return
	if mouthFrames.name != "MouthFrames":
		mouthFrames = get_parent().get_parent()
		if mouthFrames.name != "MouthFrames":
			print("[Rhubarb Lip Sync TPI] mouthFrames Container not found.")
			return
	
	mouthFrames.mouthDB[mouth_shape] = default_mouth
	textureButton.hint_tooltip = "Click to change the " + mouth_shape+" mouthshape frame"
	textureButton.connect("pressed", _on_MouthIcon_pressed)
	owner.connect("updated_reference", _on_owner_reference_updated)

var frameSelectorPopup :PopupPanel
func _on_MouthIcon_pressed():
	if is_instance_valid(frameSelectorPopup):
		frameSelectorPopup.queue_free()
	frameSelectorPopup = mouthFrames.SCN_FrameSelectorPopup.instantiate()
	owner.pluginInstance.add_child(frameSelectorPopup)
	frameSelectorPopup.connect("frame_selected", _on_frame_selected)
	frameSelectorPopup.popup(Rect2(get_global_mouse_position(), get_local_mouse_position()))
	frameSelectorPopup.animSprite = owner.anim_mouthAnimSprite
	frameSelectorPopup.anim = owner.anim_mouthAnimSprite_anim
	frameSelectorPopup.begin()

func _on_frame_selected(id :int):
	textureButton.texture_normal = owner.anim_mouthAnimSprite.frames.get_frame(owner.anim_mouthAnimSprite_anim, id)
	frameSelectorPopup.queue_free()
	mouthFrames.mouthDB[mouth_shape] = id

func _set_mouth_shape(value):
	mouth_shape = value
	$Label.text = value

func _set_default_mouth(new_frame :int):
	if new_frame == null:
		return
	
	default_mouth = new_frame
	
func _on_owner_reference_updated(reference :String):
	
	if !is_instance_valid(owner.anim_mouthAnimSprite):
		textureButton.texture_normal = TEX_InvalidFrame
		return
	if !is_instance_valid(owner.anim_mouthAnimSprite.frames):
		textureButton.texture_normal = TEX_InvalidFrame
		return
	if !owner.anim_mouthAnimSprite.frames.has_animation(owner.anim_mouthAnimSprite_anim):
		textureButton.texture_normal = TEX_InvalidFrame
		return
	
	if owner.anim_mouthAnimSprite.frames.get_frame_count(owner.anim_mouthAnimSprite_anim) == 0:
		textureButton.texture_normal = TEX_InvalidFrame
		return
	
	if default_mouth < owner.anim_mouthAnimSprite.frames.get_frame_count(owner.anim_mouthAnimSprite_anim):
		textureButton.texture_normal = owner.anim_mouthAnimSprite.frames.get_frame(owner.anim_mouthAnimSprite_anim, default_mouth)
	else:
		# When there's not enough frames for all mouthshapes, cycle through the first ones.
		var cycled_value :int= default_mouth % owner.anim_mouthAnimSprite.frames.get_frame_count(owner.anim_mouthAnimSprite_anim)
		textureButton.texture_normal = owner.anim_mouthAnimSprite.frames.get_frame(owner.anim_mouthAnimSprite_anim, cycled_value)
		
	
	
