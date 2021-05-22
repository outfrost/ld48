extends Control

signal start_game()

onready var play_button: Button = find_node("PlayButton")
onready var controls_button: Button = find_node("ControlsButton")
onready var credits_button: Button = find_node("CreditsButton")
onready var quit_button: Button = find_node("QuitButton")
onready var credits_popup: Popup = $CreditsPopup
onready var controls_popup: Popup = $ControlsPopup


func _ready() -> void:
	play_button.connect("pressed", self, "on_play_pressed")
	controls_button.connect("pressed", self, "on_controls_pressed")
	credits_button.connect("pressed", self, "on_credits_pressed")
	quit_button.connect("pressed", self, "on_quit_pressed")

func on_play_pressed() -> void:
	emit_signal("start_game")

func on_controls_pressed():
	controls_popup.show()

func on_credits_pressed() -> void:
	credits_popup.show()

func on_quit_pressed() -> void:
	get_tree().quit()
