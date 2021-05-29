extends AnimatedSprite

func _ready() -> void:
	connect("animation_finished", self, "play", ["idle"])
