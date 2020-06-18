tool
extends Button

const LINK_ISSUES_GITHUB :String= "https://github.com/AniMesuro/rhubarb-lipsync-tp-integration-godot/issues"

func _ready() -> void:
	connect("pressed", self, "_on_pressed")
	

func _on_pressed():
	OS.shell_open(LINK_ISSUES_GITHUB)
