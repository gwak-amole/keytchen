extends CanvasLayer

@export var label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_label(label_text: String):
	label.text = label_text
	print("looks" + label.text)
	label.show()
