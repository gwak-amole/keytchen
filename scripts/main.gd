extends Control

@export var pot_pan_choice: Panel
@export var pot_choice: TextureButton
@export var pan_choice: TextureButton
@export var stove1: TextureButton
@export var stove2: TextureButton
@export var pot_on_stove1: TextureRect
@export var pan_on_stove1: TextureRect
@export var pot_on_stove2: TextureRect
@export var pan_on_stove2: TextureRect
var is_stove1 = true;
var stove1_occupied = false
var stove2_occupied = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pot_pan_choice.hide()
	stove1.grab_focus()
	pot_on_stove1.hide()
	pot_on_stove2.hide()
	pan_on_stove1.hide()
	pan_on_stove2.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") && pot_pan_choice.visible:
		print("detected cancel")
		pot_pan_choice.hide()
		if is_stove1:
			stove1.grab_focus()
		else:
			stove2.grab_focus()


func _on_stovetop_1_pressed(arg: bool) -> void:
	pass
	


func _on_potchoice_pressed() -> void:
	if is_stove1:
		pot_on_stove1.show()
		stove1_occupied = true
		stove1.grab_focus()
	else:
		pot_on_stove2.show()
		stove2_occupied = true
		stove2.grab_focus()
	pot_pan_choice.hide()

func _on_stovetop_pressed(arg: bool) -> void:
	if arg:
		is_stove1 = true
	else:
		is_stove1 = false
	if (is_stove1 && stove1_occupied) || (!is_stove1 && stove2_occupied):
		return
	pot_pan_choice.show();
	pot_choice.grab_focus()


func _on_panchoice_pressed() -> void:
	if is_stove1:
		pan_on_stove1.show()
		stove1_occupied = true
		stove1.grab_focus()
	else:
		pan_on_stove2.show()
		stove2_occupied = true
		stove2.grab_focus()
	pot_pan_choice.hide()
