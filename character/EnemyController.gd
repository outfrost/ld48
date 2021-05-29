extends Area2D

var enemies_alive: int = 0

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

	for enemy in get_children():
		if enemy.has_signal("died"):
			enemies_alive += 1
			enemy.connect("died", self, "on_enemy_died")

func on_body_entered(body):
	if body.name == "PlayerCharacter" and enemies_alive != 0:
		get_tree().get_root().find_node("Game", true, false).set_music_track(Game.MusicTrack.COMBAT)
		for child in get_children():
			if child.has_method("set_target"):
				child.set_target(body)

func on_body_exited(body):
	if body.name == "PlayerCharacter" and enemies_alive != 0:
		get_tree().get_root().find_node("Game", true, false).set_music_track(Game.MusicTrack.EXPL)
		for child in get_children():
			if child.has_method("set_target"):
				child.set_target(null)

func on_enemy_died():
	enemies_alive -= 1

	if enemies_alive == 0:
		get_tree().get_root().find_node("Game", true, false).set_music_track(Game.MusicTrack.EXPL)
