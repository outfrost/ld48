extends KinematicBody2D

var current_lootable: Lootable = null

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use"):
		move_and_collide(Vector2.RIGHT * 24.0)
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
