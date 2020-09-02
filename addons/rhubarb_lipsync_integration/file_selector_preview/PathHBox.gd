tool
extends HBoxContainer

func _ready() -> void:
	$ReturnButton.connect("pressed",self,"_on_ReturnButton_pressed")

func _on_ReturnButton_pressed():
	print(owner.current_dir,owner.dir_folders,owner.dir_files)
	pass
