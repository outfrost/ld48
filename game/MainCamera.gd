extends Camera2D

const DEFAULT_HEIGHT: float = 360.0

func _ready() -> void:
	on_viewport_resized()
	get_viewport().connect("size_changed", self, "on_viewport_resized")

func on_viewport_resized() -> void:
	zoom = Vector2.ONE * (DEFAULT_HEIGHT / get_viewport_rect().size.y)
