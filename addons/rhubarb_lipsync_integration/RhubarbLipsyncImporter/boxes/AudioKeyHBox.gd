tool
extends HBoxContainer

#AudioKeyHBox

const STR_ANIMATIONPLAYER_SELECTED :String = "Please select an Animation from AnimationPlayer"
const STR_ANIMATIONPLAYER_NOT_SELECTED :String = "Please select an AnimationPlayer above before selecting animation."
const STR_AUDIOPLAYER_SELECTED :String = "Please select an Audio Clip Keyframe from Audio track."
const STR_AUDIOPLAYER_NOT_SELECTED :String = "Please select an AudioStreamPlayer above before selecting animation."
const TEX_IconExpand :StreamTexture= preload("res://addons/rhubarb_lipsync_integration/assets/icons/icon_expand.png")

var is_safe_to_load :bool= false
var clip_path :PoolStringArray= []

var last_index :int= -1

onready var button :MenuButton= $Button
onready var popupMenu :PopupMenu
onready var warningIcon :TextureRect= $WarningIcon

func _ready() -> void:
	popupMenu = button.get_popup()
	if last_index == -1:
		enable_warning("No AnimationPlayer node selected.")
	
	owner.connect("updated_reference", self, "_on_owner_reference_updated")
	popupMenu.connect("id_pressed", self, '_on_PopupMenu_item_selected')
	button.connect( "pressed", self, "_on_Button_pressed")
	

func _on_PopupMenu_item_selected(id :int):
	if id != -1:
		disable_warning()
	var item_name :String= popupMenu.get_item_text(id)
	var item_path :String= clip_path[id]
	button.text = item_name
	button.icon = owner.pluginInstance.get_editor_interface().get_inspector().get_icon("AudioStreamSample", "EditorIcons")
	
	if !is_safe_to_load:
		return
	
	var animPlayer :AnimationPlayer= owner.anim_animationPlayer
	var anim :Animation= owner.anim_animationPlayer.get_animation(owner.anim_name)
	var animAudio :AudioStreamPlayer= owner.anim_audioPlayer
	var animRoot :Node= animPlayer.get_node(animPlayer.root_node)
	var tr_audio :int= anim.find_track(animRoot.get_path_to(animAudio))
	
	owner.anim_audiokey = {
		'time': anim.track_get_key_time(tr_audio, id),
		'stream': load(item_path),
		'start_offset': anim.audio_track_get_key_start_offset(tr_audio, id),
		'end_offset': anim.audio_track_get_key_end_offset(tr_audio, id)
	}
	
	owner.emit_signal("updated_reference", 'anim_audiokey')

func _clear_clip_path_array():
	for i in clip_path.size():
		clip_path.remove(0)

func _on_Button_pressed():
	popupMenu.clear()
	if !clip_path.empty():
		_clear_clip_path_array()
	
	if !is_safe_to_load:
		return
	
	var animPlayer :AnimationPlayer= owner.anim_animationPlayer
	var anim :Animation= owner.anim_animationPlayer.get_animation(owner.anim_name)
	var animAudio :AudioStreamPlayer= owner.anim_audioPlayer
	var animRoot = animPlayer.get_node(animPlayer.root_node)
	
	var tr_audio = anim.find_track(animRoot.get_path_to(animAudio))
	
	clip_path.resize(anim.track_get_key_count(tr_audio))
	for clip_id in anim.track_get_key_count(tr_audio):
		var clip :AudioStream= anim.audio_track_get_key_stream(tr_audio, clip_id)
		
		var _time_sec :float= stepify(anim.track_get_key_time(tr_audio, clip_id), .01)
		var _count_min :int= floor(_time_sec / 60)
		var _count_sec :int= int(_time_sec) % 60
		var key_timeformatted :String= str(_count_min)+":"+str(_count_sec)
		popupMenu.add_item("["+str(key_timeformatted)+"] " +clip.resource_path.get_file())
		clip_path[clip_id] = clip.resource_path

func enable_warning(message :String):
	warningIcon = $WarningIcon
	warningIcon.visible = true
	warningIcon.hint_tooltip = message

func disable_warning():
	warningIcon.visible = false

func _on_owner_reference_updated(owner_reference :String):
#	ERROR CHECKING
	if !is_instance_valid(button):button = $Button
	if!(owner_reference == 'anim_animationPlayer'
	or  owner_reference == 'anim_name'
	or  owner_reference == 'anim_audioPlayer'):
		return
		
	if !is_instance_valid(owner.anim_animationPlayer):
		button.text = STR_ANIMATIONPLAYER_NOT_SELECTED
		button.icon = TEX_IconExpand
		enable_warning("Selected AnimationPlayer isn't valid or failed to be called.")
		if is_safe_to_load: is_safe_to_load = false
		return
	if !owner.anim_animationPlayer.has_animation(owner.anim_name):
		button.text = STR_ANIMATIONPLAYER_SELECTED
		enable_warning('Animation with name "'+owner.anim_name+'" not found at AnimationPlayer.')
		if is_safe_to_load: is_safe_to_load = false
		return
	if !is_instance_valid(owner.anim_audioPlayer):
		button.text = STR_AUDIOPLAYER_NOT_SELECTED
		enable_warning("Selected AudioPlayer isn't valid or failed to be called.")
		if is_safe_to_load: is_safe_to_load = false
		return
		
	var anim :Animation= owner.anim_animationPlayer.get_animation(owner.anim_name)
	var anim_root :Node= owner.anim_animationPlayer.get_node(owner.anim_animationPlayer.root_node)
	var tr_audio :int= anim.find_track(anim_root.get_path_to(owner.anim_audioPlayer))
	if tr_audio == -1:
		button.text = "Audio track not found at Animation."
		enable_warning("Can't procceed. Please add an 'Audio Playback Track' and insert an AudioStream to the selected Animation.")
		if is_safe_to_load: is_safe_to_load = false
		return
	
	if anim.track_get_key_count(tr_audio) == 0:
		button.text = "No audio keys found at Audio track."
		enable_warning("Can't procceed. Please insert an AudioStream key to the selected audio track.")
		if is_safe_to_load: is_safe_to_load = false
		return
	
	button.text = STR_AUDIOPLAYER_SELECTED
	
	disable_warning()
	if !is_safe_to_load: is_safe_to_load = true
#	Error checking end.
	
