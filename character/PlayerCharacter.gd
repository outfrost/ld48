extends KinematicBody2D

export var run_speed: float = 50.0
export var attack_range: float = 32.0

var inventory: Dictionary = {}

var game_controller: Game = null
var current_lootable: Lootable = null
var last_movement_dir: Vector2 = Vector2.DOWN

var basic_attack_dmg: float = 40.0

func _ready() -> void:
	$AnimatedSprite.playing = true

func _physics_process(delta: float) -> void:
	var direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).clamped(1.0)
	if !direction.is_equal_approx(Vector2.ZERO):
		last_movement_dir = direction.normalized()
	move_and_slide(direction * run_speed)
#	game_controller.camera_offset = direction * run_speed * 0.5

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("use"):
		if current_lootable:
			if !inventory.has(current_lootable.loot1):
				inventory[current_lootable.loot1] = 0
			inventory[current_lootable.loot1] += current_lootable.loot1_amount
			if !inventory.has(current_lootable.loot2):
				inventory[current_lootable.loot2] = 0
			inventory[current_lootable.loot2] += current_lootable.loot2_amount
#			print("%s (%d)" % [Item.type_str(current_lootable.loot1), current_lootable.loot1_amount])
#			print("%s (%d)" % [Item.type_str(current_lootable.loot2), current_lootable.loot2_amount])
			current_lootable.queue_free()
			print_inventory()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("attack"):
		var collision = move_and_collide(
			last_movement_dir * attack_range,
			true,
			true,
			true)
		if collision && collision.collider.has_method("take_damage"):
			collision.collider.take_damage(basic_attack_dmg)
		get_tree().set_input_as_handled()

func entered_lootable_range(lootable):
	print_debug(lootable)
	current_lootable = lootable

func exited_lootable_range(lootable):
	if lootable == current_lootable:
		current_lootable = null

func print_inventory():
	print("Inventory:")
	for entry in inventory:
		print("%s (%d)" % [Item.type_str(entry), inventory[entry]])
