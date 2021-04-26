class_name Game
extends Node

export var starting_level: PackedScene
export var player_character: PackedScene

onready var main_menu: Control = $UILayer/UI/MainMenu
onready var transition_screen: TransitionScreen = $UILayer/UI/TransitionScreen
onready var main_camera = $MainCamera
onready var level_container = $LevelContainer

var debug: Reference
var level: Node2D
var character: KinematicBody2D
#var camera_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	if OS.has_feature("debug"):
		var debug_script = load("res://debug.gd")
		if debug_script:
			debug = debug_script.new(self)
			debug.startup()

	main_menu.connect("start_game", self, "on_start_game")

func _process(delta: float) -> void:
	DebugLabel.display(self, "fps %d" % Performance.get_monitor(Performance.TIME_FPS))

	if character:
		main_camera.position = character.position #+ camera_offset

	else:
		main_camera.position = Vector2(640.0, 360.0)

	if Input.is_action_just_pressed("menu"):
		back_to_menu()

func on_start_game() -> void:
	main_menu.hide()
	level = starting_level.instance()
	level_container.add_child(level)
	spawn_player()

func back_to_menu() -> void:
	level_container.remove_child(level)
	level.queue_free()
	level = null
	main_menu.show()

func spawn_player() -> void:
	if !level:
		return
	character = player_character.instance()
	character.game_controller = self
	character.position = (level.get_node(@"SpawnPoint") as Node2D).position
	level.get_node(@"YSort").add_child(character)
