tool
extends VBoxContainer
#meio inutil, vou ter que mudar a textura de qualquer jeito
export (String) var mouth_shape = "rest" setget _set_mouth_shape
export (int) var default_mouth = 0 setget _set_default_mouth

var mouthFrames :Control
var textureButton :TextureButton

func _ready() -> void:
	if get_tree().edited_scene_root == self:
		return
	
	textureButton = $Texture
	
	mouthFrames = get_parent()
	if !is_inside_tree():
		yield(self, "tree_entered")
	if !is_instance_valid(mouthFrames):
		return
	if mouthFrames.name != "MouthFrames":
		mouthFrames = get_parent().get_parent()
		if mouthFrames.name != "MouthFrames":
			print("Rhubarb Lip Sync TPI: mouthFrames Container not found.")
			return
	
#	if mouthFrames.get('mouthDB') == null:
#		return
#	mouthFrames.mouthDB[mouth_shape] = textureButton.texture_normal
#	mouthFrames.mouthIconDB[mouth_shape] = self
#	print('mouthframes =',mouthFrames.has_method('_on_MouthIcon_pressed'))
	
#	textureButton.connect("pressed", mouthFrames, "_on_MouthIcon_pressed")#, [self])
	textureButton.connect("pressed", self, "_on_MouthIcon_pressed")#, [self])

var frameSelectorPopup :PopupPanel
func _on_MouthIcon_pressed():
	if is_instance_valid(frameSelectorPopup):
		frameSelectorPopup.queue_free()
	frameSelectorPopup = mouthFrames.SCN_FrameSelectorPopup.instance()
	owner.pluginInstance.add_child(frameSelectorPopup)
	frameSelectorPopup.connect("frame_selected", self, "_on_frame_selected")
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
	
	if !is_inside_tree():
		return
#		if is_instance_valid(self):
#			yield(self, "tree_entered")
		
	
	default_mouth = new_frame
	textureButton = $Texture
#	textureButton.texture_normal = new_frame # get_frame()
	
