extends Control

@export var anim: AnimationPlayer
@export var music: AudioStreamPlayer

# regular pattern
var pattern = [0, 60, 62, 64, 65, 64, 62]
var counter = 1;
var current_veggie: String
var beat_length = 0.5
var nearest_beat_time = 0.0
var nearest_beat_number = 0
var secs_per_beat = 1.0
var error_allowed = 0.15
var current_time: float
var current_note

# wipe mechanic
var recent_notes = []
var wipe_pattern = [60, 59, 57, 55, 53]
var time_allowed_between = 0.5
var elapsed_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_veggie = "carrot"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_time = music.get_playback_position()
	nearest_beat_number = round(current_time / secs_per_beat)
	nearest_beat_time = nearest_beat_number * secs_per_beat
	if counter < 7:
		match pattern[counter]:
			53:
				current_note = "F"
			55:
				current_note = "G"
			57:
				current_note = "A"
			59:
				current_note = "B"
			60:
				current_note = "C"
			62:
				current_note = "D"
			64:
				current_note = "E"
			65:
				current_note = "F^"
	else:
		current_note = "WIPE"
	if abs(current_time - nearest_beat_time) < 0.25:
		print("showing text")
		print(current_note)
		KeyBg.set_label(current_note)
	if counter >= 7:
		elapsed_time += delta

func _input(event):
	if event is InputEventMIDI:
		if event.message == MIDI_MESSAGE_NOTE_ON:
			if elapsed_time > time_allowed_between:
				recent_notes = []
			elapsed_time = 0
			check_note(event.pitch)
			print("received" + str(event.pitch))
			print(counter)
			print("elapsed time: " + str(elapsed_time) + " time_allowed " + str(time_allowed_between))
			if counter >= 7 && elapsed_time < time_allowed_between:
				print("checking wipe")
				print(recent_notes)
				recent_notes.append(event.pitch)
				if recent_notes.size() > 5:
					recent_notes.remove_at(0)
				if recent_notes == wipe_pattern:
					wipe()

func check_note(pitch: int):
	print("difference number" + str(current_time - nearest_beat_time))
	print("nearest beat number" + str(nearest_beat_number))
	print("nearest beat time" + str(nearest_beat_time))
	var time_error = abs(current_time - nearest_beat_time)
	print(time_error)
	print(counter)
	if counter < 7 && pitch == pattern[counter] && time_error <= error_allowed:
		print("success")
		success_cut()
	else:
		print("failed")

func success_cut():
	if counter < 7:
		anim.play("Slice" + str(counter))
		counter += 1;
	
func wipe():
	print("works")
	anim.play("remove_" + current_veggie)
