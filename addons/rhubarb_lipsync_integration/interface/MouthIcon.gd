tool
extends VBoxContainer
#meio inutil, vou ter que mudar a textura de qualquer jeito
export (String) var mouth_shape = "rest" setget _set_mouth_shape
export (StreamTexture) var default_mouth setget _set_default_mouth

var mouthTextures :Node
var textureButton :TextureButton

func _ready() -> void:
	
	textureButton = $Texture
	
	mouthTextures = get_parent()
	if !is_inside_tree():
		yield(self, "tree_entered")
	if !is_instance_valid(mouthTextures):
		return
	if mouthTextures.name != "MouthTextures":
		mouthTextures = get_parent().get_parent()
		if mouthTextures.name != "MouthTextures":
			print("Rhubarb Lipsync TPI: MouthTextures Container not found.")
			return
	
	textureButton.hint_tooltip = "Click to change the " + mouth_shape+" mouthshape texture"
	if mouthTextures.get('mouthDB') == null:
		return
	mouthTextures.mouthDB[mouth_shape] = textureButton.texture_normal
	mouthTextures.mouthIconDB[mouth_shape] = self
	textureButton.connect("pressed", mouthTextures, "_on_MouthIcon_pressed", [self])

func _set_mouth_shape(value):
	mouth_shape = value
	$Label.text = value

func _set_default_mouth(value :StreamTexture):
	if value == null:
		return
	
	if !is_inside_tree():
		if is_instance_valid(self):
			yield(self, "tree_entered")
		
	
	default_mouth = value
	textureButton = $Texture
	textureButton.texture_normal = value
	
