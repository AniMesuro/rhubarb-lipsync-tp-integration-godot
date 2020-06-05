tool
extends VBoxContainer
#meio inutil, vou ter que mudar a textura de qualquer jeito
export (String) var mouth_shape = "rest" setget _set_mouth_shape
export (StreamTexture) var default_mouth setget _set_default_mouth

var mouthTextures :Node
var textureButton :TextureButton

func _ready() -> void:
	
	textureButton = $Texture
#	print(self, ' ready called')
	
	mouthTextures = get_parent()
	if !is_inside_tree():
		yield(self, "tree_entered")
#		return
	if !is_instance_valid(mouthTextures):
		return
	if mouthTextures.name != "MouthTextures":
		mouthTextures = get_parent().get_parent()
		if mouthTextures.name != "MouthTextures":
			print("MouthTextures Container not found.")
			return
	
	if mouthTextures.get('mouthDB') == null:
		return
	mouthTextures.mouthDB[mouth_shape] = textureButton.texture_normal
	mouthTextures.mouthIconDB[mouth_shape] = self
	textureButton.connect("pressed", mouthTextures, "_on_MouthIcon_pressed", [self])

func _set_mouth_shape(value):
	mouth_shape = value
	$Label.text = value

func _set_default_mouth(value :StreamTexture):
#	print(mouth_shape,' ',value)
	if value == null:
		return
	
	if !is_inside_tree():
		if is_instance_valid(self):
#			print(self,' is valid')
			yield(self, "tree_entered")
		
#	yield(get_tree(), "idle_frame")
	
	default_mouth = value
	textureButton = $Texture
	textureButton.texture_normal = value
	
