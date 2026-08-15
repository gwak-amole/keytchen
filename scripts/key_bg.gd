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

func set_double_label(text1: String, text2: String):
	label.text = text1 + " " + text2
	label.show()

func beat():
	label.pivot_offset = label.size / 2
	var tween = create_tween()
	tween.tween_property(label, "scale", Vector2(1.15, 1.15), 0.05)
	tween.tween_property(label, "scale", Vector2.ONE, 0.05)
