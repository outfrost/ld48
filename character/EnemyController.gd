extends Area2D


func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	if body.name == "PlayerCharacter":
		get_tree().get_root().find_node("Game", true, false).set_music_track(Game.MusicTrack.COMBAT)
		for child in get_children():
			if child.has_method("set_target"):
				child.set_target(body)

func on_body_exited(body):
	if body.name == "PlayerCharacter":
		get_tree().get_root().find_node("Game", true, false).set_music_track(Game.MusicTrack.EXPL)
		for child in get_children():
			if child.has_method("set_target"):
				child.set_target(null)
