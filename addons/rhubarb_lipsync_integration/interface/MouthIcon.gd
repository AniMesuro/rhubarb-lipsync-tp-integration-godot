@tool
extends VBoxContainer
#meio inutil, vou ter que mudar a textura de qualquer jeito
@export var mouth_shape:String = "rest":
	set = _set_mouth_shape
@export var default_mouth: StreamTexture2D:
	set = _set_default_mouth

const TEX_InvalidIcon :StreamTexture2D= preload("res://addons/rhubarb_lipsync_integration/assets/icons/icon_warning.png")

var mouthTextures :Node
var textureButton :TextureButton

func _ready() -> void:
	
	textureButton = $Texture
	
	mouthTextures = get_parent()
	if !is_inside_tree():
		await tree_entered
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
	textureButton.connect("pressed", mouthTextures._on_MouthIcon_pressed, [self])

func _set_mouth_shape(value):
	mouth_shape = value
	$Label.text = value

func _set_default_mouth(value :StreamTexture2D):
	if value == null:
		return
	
	if !is_inside_tree():
		if is_instance_valid(self):
			await tree_entered
		
	
	default_mouth = value
	textureButton = $Texture
	textureButton.texture_normal = value
	
