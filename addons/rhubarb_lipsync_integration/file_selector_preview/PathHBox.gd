tool
extends HBoxContainer

func _ready() -> void:
	$ReturnButton.connect("pressed",self,"_on_ReturnButton_pressed")

func _on_ReturnButton_pressed():
	var a:String
	var subdir :PoolStringArray= owner.current_dir.get_base_dir().rsplit('/', false)
	print('[subdir]=',subdir)
#	print("CURRENTDIR ",owner.current_dir,' ',owner.current_dir.get_base_dir())
	owner.current_dir = owner.current_dir.trim_suffix(subdir[subdir.size()-1]+'/')
	print("currentdir return: ",owner.current_dir)#,owner.dir_folders,owner.dir_files)
	pass
