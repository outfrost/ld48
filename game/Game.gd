class_name Game
extends Node

export var starting_level: PackedScene
export var player_character: PackedScene

onready var main_menu: Control = $MenuLayer/UI/MainMenu
onready var transition_screen: TransitionScreen = $MenuLayer/UI/TransitionScreen
onready var main_camera = $MainCamera
onready var level_container = $LevelContainer

var debug: Reference
var level: Node2D
var character: KinematicBody2D
#var camera_offset: Vector2 = Vector2.ZERO

enum MusicTrack {
	MENU = 2,
	CAMP = 3,
	EXPL = 4,
	COMBAT = 5,
}

var prev_music_track = MusicTrack.MENU
var current_music_track = MusicTrack.MENU
var music_time: float = 50.0
const CROSSFADE_TIME: float = 2.0

onready var base_vol: Dictionary = {
	MusicTrack.MENU: db2linear(AudioServer.get_bus_volume_db(MusicTrack.MENU)),
	MusicTrack.CAMP: db2linear(AudioServer.get_bus_volume_db(MusicTrack.CAMP)),
	MusicTrack.EXPL: db2linear(AudioServer.get_bus_volume_db(MusicTrack.EXPL)),
	MusicTrack.COMBAT: db2linear(AudioServer.get_bus_volume_db(MusicTrack.COMBAT)),
}

func _ready() -> void:
	for track in MusicTrack.values():
		if track != current_music_track:
			AudioServer.set_bus_volume_db(track, linear2db(0.0))

	if OS.has_feature("debug"):
		var debug_script = load("res://debug.gd")
		if debug_script:
			debug = debug_script.new(self)
			debug.startup()

	main_menu.connect("start_game", self, "on_start_game")

func _process(delta: float) -> void:
	DebugLabel.display(self, "fps %d" % Performance.get_monitor(Performance.TIME_FPS))
#	DebugLabel.display(self, "menu %f" % AudioServer.get_bus_volume_db(MusicTrack.MENU))
#	DebugLabel.display(self, "camp %f" % AudioServer.get_bus_volume_db(MusicTrack.CAMP))
#	DebugLabel.display(self, "expl %f" % AudioServer.get_bus_volume_db(MusicTrack.EXPL))
#	DebugLabel.display(self, "combat %f" % AudioServer.get_bus_volume_db(MusicTrack.COMBAT))

	for track in MusicTrack.values():
		if track != prev_music_track && track != current_music_track:
			AudioServer.set_bus_volume_db(track, linear2db(0.0))

	music_time += delta
	if prev_music_track != current_music_track:
		var crossfade_t = clamp(music_time, 0.0, CROSSFADE_TIME) / CROSSFADE_TIME
		AudioServer.set_bus_volume_db(prev_music_track, linear2db((1.0 - crossfade_t) * base_vol[prev_music_track]))
		AudioServer.set_bus_volume_db(current_music_track, linear2db((crossfade_t) * base_vol[current_music_track]))
		if crossfade_t >= 1.0:
			prev_music_track = current_music_track

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
	set_music_track(MusicTrack.CAMP)

func back_to_menu() -> void:
	character = null
	level_container.remove_child(level)
	level.queue_free()
	level = null
	main_menu.show()
	set_music_track(MusicTrack.MENU)

func spawn_player() -> void:
	if !level:
		return
	character = player_character.instance()
	character.game_controller = self
	character.position = (level.get_node(@"SpawnPoint") as Node2D).position
	level.get_node(@"YSort").add_child(character)

func set_music_track(track):
	if track != current_music_track:
		if track == prev_music_track:
			prev_music_track = current_music_track
			music_time = CROSSFADE_TIME - music_time
		else:
			music_time = 0.0
		current_music_track = track
