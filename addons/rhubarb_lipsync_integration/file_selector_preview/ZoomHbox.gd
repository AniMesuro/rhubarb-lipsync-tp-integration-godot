tool
extends HBoxContainer

var hSlider :HSlider

func _ready() -> void:
	hSlider = $HSlider
	var filePanel :Panel= $"../FilePanel"
	
	filePanel.connect("resized", self, "_on_FilePanel_resized")
	hSlider.connect( "value_changed", self, "_on_value_changed")
#	call_deferred("_update_FileIcon_sizes")
	
func _on_value_changed(value :float):
	_update_FileIcon_sizes()

func _on_FilePanel_resized():
	_update_FileIcon_sizes()

func _update_FileIcon_sizes():
	var fileContainer :GridContainer= $"../FilePanel/ScrollContainer/FileContainer"
	var filePanel :Panel= $"../FilePanel"
	
	var fileIcons :Array= fileContainer.get_children() 
	if fileIcons == []:
		return
	
	for fileIcon in fileIcons:
		var preview :TextureButton= fileIcon.get_node('Preview') 
		
		var zoomed_size :int= hSlider.value * 8
		fileIcon.rect_min_size = Vector2(zoomed_size, zoomed_size)
	#	Still glitches sometimes, but it's better than the previous one.
	var new_columns :int= floor(filePanel.rect_size.x / (fileIcons[0].rect_size.x + 2))
	if new_columns > 0:
		fileContainer.columns =  new_columns