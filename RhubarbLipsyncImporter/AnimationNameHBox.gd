tool
extends HBoxContainer

const STR_ANIMATIONPLAYER_SELECTED :String = "Please select an Animation from AnimationPlayer"
const STR_ANIMATIONPLAYER_NOT_SELECTED :String = "Please select an AnimationPlayer above before selecting animation."

#const TEX_icon_not :StreamTexture= preload("res://addons/rhubarb_lipsync_importer/assets/icons/icon_not.png")
#const TEX_icon_yes :StreamTexture= preload("res://addons/rhubarb_lipsync_importer/assets/icons/icon_yes.png")

onready var warningIcon :TextureRect= $WarningIcon
onready var menuButton :MenuButton= $MenuButton
var popupMenu :PopupMenu
#func _on_LineEdit_text_entered(new_text: String) -> void:

#func validate_animation(enable :bool):
	
func _ready() -> void:
	menuButton.text = STR_ANIMATIONPLAYER_NOT_SELECTED
	popupMenu = menuButton.get_popup()
	menuButton.connect( "pressed", self, "_on_MenuButton_pressed")
	popupMenu.connect( "id_pressed", self, "_on_PopupMenu_item_selected")
	owner.connect("updated_reference", self, "_on_owner_reference_updated")
	if popupMenu.get_current_index() == -1:
		enable_warning("No AnimationPlayer node selected. Can't proceed")
	
	

func _on_MenuButton_pressed():
	var animPlayer :AnimationPlayer= owner.anim_animationPlayer
	if !is_instance_valid(animPlayer):
		return
	
	popupMenu.clear()
	for animation in animPlayer.get_animation_list():
		popupMenu.add_item(animation)
	

func _on_PopupMenu_item_selected(id :int):
	if id != -1:
		disable_warning()
	owner.anim_name = popupMenu.get_item_text(id)
	menuButton.icon = owner.pluginInstance.get_editor_interface().get_inspector().get_icon("Animation", "EditorIcons")
	menuButton.text = owner.anim_name
	owner.emit_signal("updated_reference", 'anim_name')
	print('owneranimname ',owner.anim_name)

#func _on_LineEdit_text_changed(new_text: String) -> void:
#	check_if_valid(new_text)

func _on_owner_reference_updated(owner_reference :String):
	if owner_reference != 'anim_animationPlayer':
		return
	if !is_instance_valid(owner.anim_animationPlayer):
		menuButton.text = STR_ANIMATIONPLAYER_NOT_SELECTED
		enable_warning("Selected AnimationPlayer isn't valid or failed to be called.")
		return
	menuButton.text = STR_ANIMATIONPLAYER_SELECTED
	enable_warning("No Animation selected.")
	
#		print('owner is ',owner_reference)
#	check_if_valid($LineEdit.text)

func enable_warning(message :String):
	warningIcon.visible = true
	warningIcon.hint_tooltip = message

func disable_warning():
	warningIcon.visible = false
	
#var editedSceneRoot
#func check_if_valid(new_text :String):
#	editedSceneRoot = get_tree().edited_scene_root
#	var aniPlayer :AnimationPlayer= owner.anim_animationPlayer
#	if !is_instance_valid(aniPlayer):
##		print('aniplayer not valid')
#		return
#	if aniPlayer.has_animation(new_text):
#		owner.anim_name = new_text
#		validIcon.texture = TEX_icon_yes
##		print('has animation ',new_text)
#	else:
#		validIcon.texture = TEX_icon_not
##		print('has not animation ',new_text)
