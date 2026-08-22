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
var nearest_beat_time = 0.0
var nearest_beat_number = 0
var secs_per_beat = 0.5
var error_allowed = 0.15
var current_time: float
var current_note
var last_shown_beat := -1

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
	# reset function to determine what veggie is being cut
	current_veggie = current_veggies.pick_random()
	if current_veggie == "carrot":
		print("carrot")
		pattern = carrot_pattern
		time_allowed_between = 0.5
		potato_mode = false
	elif current_veggie == "zucchini":
		print("zucchini")
		pattern = zucchini_pattern
		time_allowed_between = 0.5
		potato_mode = false
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
	# finding the current time each process frame
	current_time = get_time()
	
	# measuring closest beat & its corresponding time
	# this is to judge time error later
	nearest_beat_number = round(current_time / secs_per_beat)
	nearest_beat_time = nearest_beat_number * secs_per_beat
	
	# this section's to match current notes from integer values to letter notes
	# if neither then it's a wipe event
	if (counter < 7 and !potato_mode) || (counter < 2 and potato_mode):
		match pattern[counter]:
			53: current_note = "F"
			55: current_note = "G"
			57: current_note = "A"
			59: current_note = "B"
			60: current_note = "C"
			62: current_note = "D"
			64: current_note = "E"
			65: current_note = "F^"
	else:
		current_note = "WIPE"
		
	# if it's a new beat, trigger beat functions :D
	# the beat functions are just for aesthetics
	var current_beat = floori(current_time / secs_per_beat)
	if current_beat != last_shown_beat:
		last_shown_beat = current_beat
		if potato_mode:
			add_potato_beat()
		else:
			add_beat()
	
	# to give wipe visual
	if counter >= 7 && elapsed_time < time_allowed_between:
		KeyBg.wipe_prompt = true
		KeyBg.wipeshow()
	
	# measuring time
	elapsed_time += delta

func _input(event):
	if bypass_wipe:
		wipe()
	if event is InputEventMIDI:
		if event.message == MIDI_MESSAGE_NOTE_ON:
			if elapsed_time > time_allowed_between:
				# if the time allowed between inputs is large enough just reset the array
				recent_notes = []
			
			# reset the time elapsed if input is detected
			elapsed_time = 0
			
			# if the counter is larger than 7 then make time_allowed_between 0.5
			# this is to change it to 0.5 if it's in potato mode
			# because wipe needs to have a time_allowed_between of 0.5 :DDD
			if counter >= 7: 
				time_allowed_between = 0.5
				
			# if the current veggie is potato add input notes to notes array
			# and check if timing is right using the function
			if potato_mode:
				recent_notes.append(event.pitch)
				check_potato_smash(recent_notes)
			# to determine that it's time for a wipe sequence instead
			elif counter >= 7 && elapsed_time < time_allowed_between:
				recent_notes.append(event.pitch)
				print(recent_notes)
				# if recent_notes is too crowded just get rid of the first element
				if recent_notes.size() > 5:
					recent_notes.remove_at(0)
					
				# if the recent_notes matches the wipe_pattern then execute wipe()!
				if recent_notes == wipe_pattern:
					wipe()
			else:
				# if it's not potato mode or wipe time just check if note is right + timing
				check_note(event.pitch)
	# if i don't have my midi with me i just skip everything with this lol
	if event.is_action_pressed("ui_accept"):
		if potato_mode:
			check_potato_smash([60, 64])
		elif counter < 7:
			check_note(pattern[counter])
		else:
			bypass_wipe = true

func check_note(pitch: int):
	# get time_error to check timing
	var time_error = abs(current_time - nearest_beat_time)
	if (counter < 7 && pitch == pattern[counter])&& time_error <= error_allowed:
		# if success
		print("success")
		success_cut()
	elif (counter < 7 && pitch != pattern[counter]):
		# if key is wrong
		wrong(pitch)
	elif time_error > error_allowed:
		# if timing is wrong
		print("timing is wrong")
		wrong(pitch)
	else:
		# both key and timing is wrong
		print("for some other reason??")
		print("time_error: " + str(time_error) + " error allowed: " + str(error_allowed))

func success_cut():
	# progress for the next slice
	if counter < 7:
		anim.play("Slice" + str(counter))
		counter += 1;
	
func wipe():
	# wipe success function
	anim.play("remove_" + current_veggie)
	await anim.animation_finished
	KeyBg.wipe_prompt = false

func add_beat():
	# visual beat controller for regular veggies
	KeyBg.being_wrong = false
	KeyBg.beat()
	KeyBg.set_label(current_note)
	match current_note:
		"C": KeyBg.ckey.show()
		"D": KeyBg.dkey.show()
		"E": KeyBg.ekey.show()
		"F^": KeyBg.fkey.show()
		"F": KeyBg.flowkey.show()
		"G": KeyBg.gkey.show()
		"A": KeyBg.akey.show()
		"B": KeyBg.bkey.show()

func add_potato_beat():
	# visual beat controller for the potato
	KeyBg.beat()
	KeyBg.set_double_label(potato_smash)
	KeyBg.ckey.show()
	KeyBg.ekey.show()
		
func check_potato_smash(notes: Array):
	# check if notes for potato smash are correct
	var time_error = abs(current_time - nearest_beat_time)
	if (notes == potato_smash || notes == potato_smash2) && time_error <= error_allowed:
		success_cut()
	# if cut more than 7 times move onto the wipe thingy
	if counter >= 7:
		potato_mode = false
	# reset the notes array to be empty
	notes = []
	
func wrong(pitch: int):
	# general function to turn labels and notes red if something is wrong
	KeyBg.turn_red()
	KeyBg.being_wrong = true;
	match pitch:
		53: 
			KeyBg.flowkey.show()
			KeyBg.flowkey.texture = load("res://assets/key_guide/key_wrong.png")
		55:
			KeyBg.gkey.show()
			KeyBg.gkey.texture = load("res://assets/key_guide/key_wrong.png")
		57:
			KeyBg.akey.show()
			KeyBg.akey.texture = load("res://assets/key_guide/key_wrong.png")
		59:
			KeyBg.bkey.show()
			KeyBg.bkey.texture = load("res://assets/key_guide/key_wrong.png")
		60:
			KeyBg.ckey.show()
			KeyBg.ckey.texture = load("res://assets/key_guide/key_wrong.png")
		62:
			KeyBg.dkey.show()
			KeyBg.dkey.texture = load("res://assets/key_guide/key_wrong.png")
		64:
			KeyBg.ekey.show()
			KeyBg.ekey.texture = load("res://assets/key_guide/key_wrong.png")
		65:
			KeyBg.fkey.show()
			KeyBg.fkey.texture = load("res://assets/key_guide/key_wrong.png")

func get_time():
	# general function to get very accurate time (thanks godot)
	var time
	time = music.get_playback_position()
	time += AudioServer.get_time_since_last_mix()
	time -= AudioServer.get_output_latency()
	return time
	
