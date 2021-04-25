extends Camera2D

onready var default_height = get_viewport_rect().size.y

func _ready() -> void:
	print(default_height)
	get_viewport().connect("size_changed", self, "on_viewport_resized")

func on_viewport_resized() -> void:
	zoom = Vector2.ONE * (default_height / get_viewport_rect().size.y)
	print(zoom)
