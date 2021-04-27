extends Area2D

func _ready() -> void:
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	if body.has_method("update_selector"):
		get_tree().get_root().find_node("Game", true, false).set_music_track(Game.MusicTrack.CAMP)

func on_body_exited(body):
	if body.has_method("update_selector"):
		get_tree().get_root().find_node("Game", true, false).set_music_track(Game.MusicTrack.EXPL)
