extends Area2D


func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	if body.name == "PlayerCharacter":
		for child in get_children():
			if child.has_method("set_target"):
				child.set_target(body)
	
func on_body_exited(body):
	if body.name == "PlayerCharacter":
		for child in get_children():
			if child.has_method("set_target"):
				child.set_target(null)
