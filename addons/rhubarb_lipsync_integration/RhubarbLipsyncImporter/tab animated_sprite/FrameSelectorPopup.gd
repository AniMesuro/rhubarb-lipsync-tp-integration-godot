extends PopupPanel

signal frame_selected (id)
# PopupPanel that allow user to select the desired frame from an AnimatedSprite
# animation to represent a mouthshape in the output lipsync animation

var animSprite :AnimatedSprite
var anim :String
var frame_id :int

onready var marginContainer :MarginContainer= $ScrollContainer/MarginContainer


func _ready() -> void:
	if !is_instance_valid(animSprite):
		queue_free()
		return
	if !is_instance_valid(animSprite.frames):
		queue_free()
		return
	var spriteFrames :SpriteFrames= animSprite.frames
	
	if !spriteFrames.has_animation(anim):
		queue_free()
		return
	
	if spriteFrames.get_frame_count(anim) == 0:
		queue_free()
		return
	
	for i in spriteFrames.get_frame_count(anim):
		var frameTexture :TextureButton= TextureButton.new()
		frameTexture.texture_normal = spriteFrames.get_frame(anim, i)
#		frameTexture.rect_min_size = Vector2(24,24)
		marginContainer.add_child(frameTexture)
		frameTexture.connect("pressed", self, "_on_FrameTexture_pressed", [i])

func _on_FrameTexture_pressed(id :int):
	emit_signal("frame_selected", id)
