extends Control

@export var anim: AnimationPlayer
@export var music: AudioStreamPlayer

# patterns + initialization
var pattern: Array[int] = []
var carrot_pattern: Array[int] = [0, 60, 62, 64, 65, 64, 62]
var zucchini_pattern: Array[int] = [0, 60, 64, 60, 64, 60, 64]

# set counter for which slice
var counter = 1;

# veggie selection
var current_veggies: Array[String] = ["carrot", "potato", "zucchini"]
var current_veggie: String

# music timing
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
var bypass_wipe = false

# mode set
var potato_mode = false
var potato_smash: Array[int] = [60, 64]
var potato_smash2: Array[int] = [64, 60]

func reset():
	current_veggie = current_veggies.pick_random()
	if current_veggie == "carrot":
		print("carrot")
		pattern = carrot_pattern
		time_allowed_between = 0.5
	elif current_veggie == "zucchini":
		print("zucchini")
		pattern = zucchini_pattern
		time_allowed_between = 0.5
	elif current_veggie == "potato":
		print("potato")
		potato_mode = true
		pattern = potato_smash
		time_allowed_between = 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()
	KeyBg.show()
	current_veggie = "carrot"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_time = music.get_playback_position()
	nearest_beat_number = round(current_time / secs_per_beat)
	nearest_beat_time = nearest_beat_number * secs_per_beat
	if (counter < 7 and !potato_mode) || (counter < 2 and potato_mode):
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
	add_beat()
	if counter >= 7:
		elapsed_time += delta

func _input(event):
	if bypass_wipe:
		wipe()
	if event is InputEventMIDI:
		if event.message == MIDI_MESSAGE_NOTE_ON:
			if elapsed_time > time_allowed_between:
				recent_notes = []
			elapsed_time = 0
			check_note(event.pitch)
			print("received" + str(event.pitch))
			print(counter)
			print("elapsed time: " + str(elapsed_time) + " time_allowed " + str(time_allowed_between))
			if potato_mode:
				recent_notes.append(event.pitch)
				
			elif counter >= 7 && elapsed_time < time_allowed_between:
				print("checking wipe")
				print(recent_notes)
				recent_notes.append(event.pitch)
				if recent_notes.size() > 5:
					recent_notes.remove_at(0)
				if recent_notes == wipe_pattern:
					wipe()
	if event.is_action_pressed("ui_accept"):
		if counter < 7:
			check_note(pattern[counter])
		else:
			bypass_wipe = true

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

func add_beat():
	var time_error = abs(current_time - nearest_beat_time)
	var cooldown = false
	if time_error < 0.01 && !cooldown:
		KeyBg.beat()
		KeyBg.set_label(current_note)
		cooldown = true
		await get_tree().create_timer(0.1).timeout
		cooldown = false
