extends KinematicBody2D

export var run_speed: float = 50.0
export var attack_range: float = 32.0

onready var sprite: AnimatedSprite = $AnimatedSprite

var inventory: Dictionary = {}

var game_controller: Game = null
var current_lootable: Lootable = null
var last_movement_dir: Vector2 = Vector2.DOWN
onready var home = self.position

var health: float = 100.00

var basic_attack_dmg: float = 40.0

func _ready() -> void:
	$AnimatedSprite.playing = true

func _physics_process(delta: float) -> void:
	var direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).clamped(1.0)
	var moving: bool = !direction.is_equal_approx(Vector2.ZERO)

	if moving:
		last_movement_dir = direction.normalized()
	move_and_slide(direction * run_speed)
#	game_controller.camera_offset = direction * run_speed * 0.5

	var angle = direction.angle() if moving else last_movement_dir.angle()
	# right
	if angle > -0.1875 * TAU && angle < 0.1875 * TAU:
		if moving:
			sprite.play("run_right")
		else:
			sprite.play("idle_right")
	# left
	elif angle < -0.3125 * TAU || angle > 0.3125 * TAU:
		if moving:
			sprite.play("run_left")
		else:
			sprite.play("idle_left")
	# down
	elif angle > 0.0:
		if moving:
			sprite.play("run_down")
		else:
			sprite.play("idle_down")
	# up
	else:
		if moving:
			sprite.play("run_up")
		else:
			sprite.play("idle_up")

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

func take_damage(dmg: float):
	health -= dmg
	if health <= 0.0:
		self.position = home
		self.health = 75

func exited_lootable_range(lootable):
	if lootable == current_lootable:
		current_lootable = null

func print_inventory():
	print("Inventory:")
	for entry in inventory:
		print("%s (%d)" % [Item.type_str(entry), inventory[entry]])

func _process(delta):
	DebugLabel.display(self, self.health)
