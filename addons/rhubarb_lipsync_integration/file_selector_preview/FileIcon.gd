tool
extends VBoxContainer

signal file_selected (filepath)
var filepath :String

func _ready() -> void:
	var preview :TextureButton= $Preview
	
	preview.connect("pressed", self, "_on_Preview_pressed")

func _on_Preview_pressed():
	
	emit_signal("file_selected", filepath)
