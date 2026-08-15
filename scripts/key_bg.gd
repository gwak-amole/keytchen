extends CanvasLayer

@export var label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_label(label_text: String):
	label.text = label_text
	if label.text.to_upper() == "WIPE":
		label.add_theme_font_size_override("font_size", 50)
	else:
		label.add_theme_font_size_override("font_size", 120)
	label.show()

func set_double_label(notes: Array[int]):
	var note1 = notes[0]
	var note2 = notes[1]
	var text1: String
	var text2: String
	match note1:
		60:
			text1 = "C"
		62:
			text1 = "D"
		64:
			text1 = "E"
	match note2:
		60:
			text2 = "C"
		62:
			text2 = "D"
		64:
			text2 = "E"
		
	label.add_theme_font_size_override("font_size", 50)
	label.text = text1 + " " + text2
	label.show()

func beat():
	label.pivot_offset = label.size / 2
	var tween = create_tween()
	tween.tween_property(label, "scale", Vector2(1.15, 1.15), 0.05)
	tween.tween_property(label, "scale", Vector2.ONE, 0.05)
