class_name Game
extends Node

export var starting_level: PackedScene

onready var main_menu: Control = $UI/MainMenu
onready var transition_screen: TransitionScreen = $UI/TransitionScreen
onready var level_container = $LevelContainer

var debug: Reference
var level: Node2D

func _ready() -> void:
	if OS.has_feature("debug"):
		var debug_script = load("res://debug.gd")
		if debug_script:
			debug = debug_script.new(self)
			debug.startup()

	main_menu.connect("start_game", self, "on_start_game")

func _process(delta: float) -> void:
	DebugLabel.display(self, "fps %d" % Performance.get_monitor(Performance.TIME_FPS))

	if Input.is_action_just_pressed("menu"):
		back_to_menu()

func on_start_game() -> void:
	main_menu.hide()
	level = starting_level.instance()
	level_container.add_child(level)

func back_to_menu() -> void:
	level_container.remove_child(level)
	level.queue_free()
	level = null
	main_menu.show()
