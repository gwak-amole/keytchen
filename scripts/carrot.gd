extends Node2D

@export var anim: AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func slice1():
	anim.play("Slice1")
	
func slice2():
	anim.play("Slice2")

func slice3():
	anim.play("Slice3")

func slice4():
	anim.play("Slice4")

func slice5():
	anim.play("Slice5")

func slice6():
	anim.play("Slice6")
	
func remove():
	anim.play("remove")
	
func reset():
	anim.play("RESET")
