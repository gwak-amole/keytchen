extends Control

signal go_back

@export var items: HBoxContainer
var is_focused = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	for child in items.get_children():
		child.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.visible:
		if Input.is_action_just_pressed("e") && !is_focused:
			for child in items.get_children():
				if child.visible:
					child.get_child(0).grab_focus()
					is_focused = true;
					break
		elif Input.is_action_just_pressed("e") && is_focused:
			is_focused = false;
			go_back.emit()
