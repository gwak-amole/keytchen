extends Control

@export var anim: AnimationPlayer
var counter = 1;
var current_veggie: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_veggie = "carrot"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") && counter < 7:
		anim.play("Slice" + str(counter))
		counter += 1;
	elif Input.is_action_just_pressed("ui_accept") && counter == 7:
		anim.play("remove_" + current_veggie)
