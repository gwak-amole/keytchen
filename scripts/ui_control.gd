extends Node
@export var stove1: TextureButton
var not_released = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("I exist bro")
	OS.open_midi_inputs()

func _input(event: InputEvent) -> void:
	if event is InputEventMIDI:
		var is_pressed = (event.message == MIDI_MESSAGE_NOTE_ON)
		var is_released = (event.message == MIDI_MESSAGE_NOTE_OFF)
		if is_pressed or is_released:
			match event.pitch:
				48: # the C (first button on the nanoKEY2 :D)
					ui_action("ui_left", is_pressed)
				49: # C#
					ui_action("ui_cancel", is_pressed)
				50: # the D
					ui_action("ui_right", is_pressed)
				51: # the D# or Eb whatever
					ui_action("ui_accept", is_pressed)
				
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func ui_action(action: String, is_pressed: bool):
	print(action)
	if is_pressed:
		print("simulating")
		var event = InputEventAction.new()
		event.action = action
		event.pressed = is_pressed
		print("pressed")
		Input.parse_input_event(event)
	else:
		var event = InputEventAction.new()
		event.action = action
		event.pressed = is_pressed
		print("released")
		Input.parse_input_event(event)
