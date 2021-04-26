extends Area2D

onready var panel: Panel = $CanvasLayer/ResearchPanel

var character: Node2D = null

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	if body.has_method("entered_interactive_range"):
		character = body
		body.entered_interactive_range(self)

func on_body_exited(body):
	if body.has_method("exited_interactive_range"):
		if body == character:
			character = null
		body.exited_interactive_range(self)

func interact():
	if !character || !is_instance_valid(character):
		character = null
		return
	character.set_process_input(false)
	character.set_physics_process(false)
	panel.show()

func done_interacting():
	panel.hide()
	if !character || !is_instance_valid(character):
		character = null
		return
	character.set_process_input(true)
	character.set_physics_process(true)
