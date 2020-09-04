tool
extends HBoxContainer

func _ready() -> void:
	$LineEdit.connect("text_entered", self, "_on_text_entered")

func _on_text_entered(new_text :String):
	var Dir :Directory= Directory.new()
	if Dir.file_exists(owner.current_dir + new_text):
		if new_text.get_extension() in owner.filters:
			owner.current_file = new_text
		else:
			print(new_text,' is ',new_text.get_extension(),' not in ',owner.filters)
	else:
		$LineEdit.text = owner.current_file
