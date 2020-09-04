tool
extends HBoxContainer

func _ready() -> void:
	$ReturnButton.connect("pressed",self,"_on_ReturnButton_pressed")
	$LineEdit.connect("text_entered", self, "_on_text_entered")

func _on_ReturnButton_pressed():
	var a:String
	var subdir :PoolStringArray= owner.current_dir.get_base_dir().rsplit('/', false)
	print('[subdir]=',subdir)
#	print("CURRENTDIR ",owner.current_dir,' ',owner.current_dir.get_base_dir())
	
	if subdir.size() <= 1: # If current_dir is root dir
		return
	
	var suffix :String= owner.current_dir.right(owner.current_dir.find_last(subdir[subdir.size()-1]))
	print('suffix ',suffix)
	owner.current_dir = owner.current_dir.trim_suffix(suffix)#subdir[subdir.size()-1]+'/')
	print("currentdir return: ",owner.current_dir)#,owner.dir_folders,owner.dir_files)
	

func _on_text_entered(new_text :String):
	var Dir :Directory= Directory.new()
	if Dir.open(new_text) == OK:
		var subdir :PoolStringArray= new_text.rsplit("/", false)
		
		match subdir[0]:
			'res:':
				if owner.filesystem_access == FileDialog.ACCESS_RESOURCES:
					owner.current_dir = new_text
				else:
					$LineEdit.text = owner.current_dir
			'user:':
				if owner.filesystem_access == FileDialog.ACCESS_USERDATA:
					owner.current_dir = new_text
				else:
					$LineEdit.text = owner.current_dir
			_:
				if owner.filesystem_access == FileDialog.ACCESS_USERDATA:
					owner.current_dir = new_text
				else:
					$LineEdit.text = owner.current_dir
				
		
		print("<SUBDIR> = ",subdir)
#		match owner.filesystem_access:
#			FileDialog.ACCESS_FILESYSTEM:
				
		
	else:
		$LineEdit.text = owner.current_dir
