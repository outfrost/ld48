extends AudioStreamPlayer

func _ready() -> void:
	connect("finished", self, "go")

func go():
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene("res://game/Game.tscn")
