extends Control
@export var anim: AnimationPlayer
@export var bg: TextureRect
@export var navy_rect: ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg.texture = preload("res://assets/start_screen/start_screen1.png")
	navy_rect.show()
	anim.play("open")
	await anim.animation_finished
	anim.play("motion")
	navy_rect.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		start_game()

func start_game():
	bg.texture = preload("res://assets/start_screen/start_screen_play.png")
	anim.play("begin")
	navy_rect.show()
	await anim.animation_finished
	get_tree().change_scene_to_file("res://scenes/main.tscn")
