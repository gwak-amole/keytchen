extends CanvasLayer

@export var label: Label
@export var ckey: TextureRect
@export var dkey: TextureRect
@export var ekey: TextureRect
@export var fkey: TextureRect
@export var gkey: TextureRect
@export var akey: TextureRect
@export var bkey: TextureRect
@export var flowkey: TextureRect
var wipe_prompt = false
var being_wrong = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	ckey.hide()
	dkey.hide()
	ekey.hide()
	fkey.hide()
	flowkey.hide()
	gkey.hide()
	akey.hide()
	bkey.hide()

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
	if !wipe_prompt && !being_wrong:
		ckey.hide()
		dkey.hide()
		ekey.hide()
		fkey.hide()
		flowkey.hide()
		gkey.hide()
		akey.hide()
		bkey.hide()
	flowkey.texture = load("res://assets/key_guide/key_highlight.png")
	gkey.texture = load("res://assets/key_guide/key_highlight.png")
	akey.texture = load("res://assets/key_guide/key_highlight.png")
	bkey.texture = load("res://assets/key_guide/key_highlight.png")
	ckey.texture = load("res://assets/key_guide/key_highlight.png")
	dkey.texture = load("res://assets/key_guide/key_highlight.png")
	ekey.texture = load("res://assets/key_guide/key_highlight.png")
	fkey.texture = load("res://assets/key_guide/key_highlight.png")

func wipeshow():
	if wipe_prompt:
		ckey.show()
		dkey.show()
		ekey.show()
		fkey.show()
		flowkey.show()
		gkey.show()
		akey.show()
		bkey.show()
