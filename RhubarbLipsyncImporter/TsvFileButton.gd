tool
extends Button

var lipsync_data :String= ""
func _ready() -> void:
	pass

var fileDialog :FileDialog
func _on_Button_pressed() -> void:
	fileDialog = FileDialog.new()
	print(owner)
	owner.pluginInstance.add_child(fileDialog)
	fileDialog.mode = FileDialog.MODE_OPEN_FILE
	fileDialog.connect("popup_hide", self, "_on_FileDialog_hide")
	fileDialog.filters = PoolStringArray(['*.tsv'])
	fileDialog.rect_min_size = Vector2(400,300)
	fileDialog.resizable = true
	fileDialog.popup()
	
	yield(fileDialog, "file_selected")
	var f = File.new()
	f.open(fileDialog.current_path, File.READ)
	text = fileDialog.current_file
	hint_tooltip = fileDialog.current_path
	lipsync_data = f.get_as_text()
	owner.lipsync_data = lipsync_data
#	print(owner.lipsync_data)
	f.close()

func _on_FileDialog_hide() -> void:
	if !fileDialog.is_queued_for_deletion():
		fileDialog.queue_free()
