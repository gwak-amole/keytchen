extends CanvasLayer

@export var label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_label(label_text: String):
	if label.text.to_upper() == "WIPE":
		label.add_theme_font_size_override("font_size", 50)
	else:
		label.add_theme_font_size_override("font_size", 120)
	label.text = label_text
	label.show()
