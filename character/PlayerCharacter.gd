extends KinematicBody2D

export var run_speed: float = 50.0

var current_lootable: Lootable = null

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	move_and_slide(direction * run_speed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use"):
		if current_lootable:
			print("%s (%d)" % [Item.type_str(current_lootable.loot1), current_lootable.loot1_amount])
			print("%s (%d)" % [Item.type_str(current_lootable.loot2), current_lootable.loot2_amount])
		get_tree().set_input_as_handled()

func entered_lootable_range(lootable):
	print_debug(lootable)
	current_lootable = lootable

func exited_lootable_range(lootable):
	if lootable == current_lootable:
		current_lootable = null
