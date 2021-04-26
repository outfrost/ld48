extends KinematicBody2D

export var run_speed: float = 50.0
export var attack_range: float = 32.0
export var attack_hit_delay: float = 0.16
export var walk_sounds: Array
export var walk_sound_interval: float = 0.5
export var swing_sounds: Array
export var hit_sounds: Array

onready var sprite: AnimatedSprite = $AnimatedSprite

var inventory: Dictionary = {}

var game_controller: Game = null
var current_lootable: Lootable = null
var current_interactive: Node2D = null
var last_movement_dir: Vector2 = Vector2.DOWN
onready var home = self.position

var health: float = 100.00
var resist_base: float = 0.20
var resist_fire: float = 0.20
var resist_ice: float = 0.20
var resist_wind: float = 0.20

var basic_attack_dmg: float = 40.0

var walk_sound_timer: float = 0.0
var playing_action: bool = false

func _ready() -> void:
	$AnimatedSprite.playing = true

func _physics_process(delta: float) -> void:
	walk_sound_timer += delta

	var direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).clamped(1.0)
	var moving: bool = !direction.is_equal_approx(Vector2.ZERO)

	if moving:
		last_movement_dir = direction.normalized()
		if walk_sound_timer > walk_sound_interval:
			walk_sound_timer = 0.0
			if walk_sounds.size() > 0:
				get_node(walk_sounds[randi() % walk_sounds.size()]).play()
	else:
		walk_sound_timer = 0.0
	move_and_slide(direction * run_speed)

	if playing_action:
		return
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
		get_tree().set_input_as_handled()
		if current_lootable:
			if !is_instance_valid(current_lootable):
				return
			if !inventory.has(current_lootable.loot1):
				inventory[current_lootable.loot1] = 0
			inventory[current_lootable.loot1] += current_lootable.loot1_amount
			if !inventory.has(current_lootable.loot2):
				inventory[current_lootable.loot2] = 0
			inventory[current_lootable.loot2] += current_lootable.loot2_amount
			if !inventory.has(current_lootable.loot3):
				inventory[current_lootable.loot3] = 0
			inventory[current_lootable.loot3] += current_lootable.loot3_amount
#			print("%s (%d)" % [Item.type_str(current_lootable.loot1), current_lootable.loot1_amount])
#			print("%s (%d)" % [Item.type_str(current_lootable.loot2), current_lootable.loot2_amount])
			current_lootable.queue_free()
			print_inventory()
		elif current_interactive:
			if !is_instance_valid(current_interactive):
				return
			if current_interactive.has_method("interact"):
				current_interactive.interact()
	elif event.is_action_pressed("attack"):
		get_tree().set_input_as_handled()
		play_attack_anim(last_movement_dir)

		if swing_sounds.size() > 0:
			get_node(swing_sounds[randi() % swing_sounds.size()]).play()
		var collision = move_and_collide(
			last_movement_dir * attack_range,
			true,
			true,
			true)
		if collision && collision.collider.has_method("take_damage"):
			hit(collision.collider)

func hit(other: CollisionObject2D):
	yield(get_tree().create_timer(attack_hit_delay), "timeout")
	if !is_instance_valid(other):
		return
	other.take_damage(basic_attack_dmg,0,0,0)
	if hit_sounds.size() > 0:
		get_node(hit_sounds[randi() % hit_sounds.size()]).play()

func play_attack_anim(direction: Vector2):
	playing_action = true
	var angle = last_movement_dir.angle()
	var anim: String
	# right
	if angle > -0.1875 * TAU && angle < 0.1875 * TAU:
		anim = "slash_right"
	# left
	elif angle < -0.3125 * TAU || angle > 0.3125 * TAU:
		anim = "slash_left"
	# down
	elif angle > 0.0:
		anim = "slash_down"
	# up
	else:
		anim = "slash_up"

	sprite.play(anim)
	$FxSprite.play(anim + "_red")
	yield(sprite, "animation_finished")
	playing_action = false
	$FxSprite.play("idle")

func take_damage(dmg: float, fire_dmg: float, ice_dmg: float, wind_dmg: float):

	health -= (1.0 - resist_base) * dmg
	health -= (1.0 - resist_fire) * fire_dmg
	health -= (1.0 - resist_ice) * ice_dmg
	health -= (1.0 - resist_wind) * wind_dmg

	if health <= 0.0:
		self.position = home
		self.health = 75.0

func entered_lootable_range(lootable):
	print_debug(lootable)
	current_lootable = lootable

func exited_lootable_range(lootable):
	if lootable == current_lootable:
		current_lootable = null

func entered_interactive_range(interactive):
	print_debug(interactive)
	current_interactive = interactive

func exited_interactive_range(interactive):
	if interactive == current_interactive:
		current_interactive = null

func print_inventory():
	print("Inventory:")
	for entry in inventory:
		print("%s (%d)" % [Item.type_str(entry), inventory[entry]])

func _process(delta):
	DebugLabel.display(self, self.health)
