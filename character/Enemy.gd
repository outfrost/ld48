extends KinematicBody2D

export var attack_hit_delay: float = 0.16
export var walk_sounds: Array
export var walk_sound_interval: float = 0.5
export var swing_sounds: Array
export var hit_sounds: Array

var health = 100.0
export var resist_base: float = 0.00
export var resist_fire: float = 0.00
export var resist_ice: float = 0.00
export var resist_wind: float = 0.00

var attack_range: float = 30.0
var basic_attack_dmg: float = 2.00
var basic_attack_multiplier: float = 3.00
var basic_attack_cooldown: float = 2.50
var attack_timer: float = 0.00

var run_speed: float = 70.0

var nearest_player = null
onready var home = self.position

onready var sprite = $AnimatedSprite

var walk_sound_timer: float = 0.0
var moving: bool = false
var last_movement_dir: Vector2 = Vector2.DOWN
var playing_action: bool = false

func _ready() -> void:
	sprite.playing = true

func take_damage(dmg: float, fire_dmg: float, ice_dmg: float, wind_dmg: float):

	health -= (1.0 - resist_base) * dmg
	$FCTManager._show_value((1.0 - resist_base) * dmg)
	health -= (1.0 - resist_fire) * fire_dmg
	if ((1.0 - resist_fire) * fire_dmg) != 0:
		$FCTManager._show_value((1.0 - resist_fire) * fire_dmg)
	health -= (1.0 - resist_ice) * ice_dmg
	if ((1.0 - resist_ice) * ice_dmg) != 0:
		$FCTManager._show_value((1.0 - resist_ice) * ice_dmg)
	health -= (1.0 - resist_wind) * wind_dmg
	if ((1.0 - resist_wind) * wind_dmg) != 0:
		$FCTManager._show_value((1.0 - resist_wind) * wind_dmg)

	if health <= 0.0:
		queue_free()

func set_target(player: KinematicBody2D):
	nearest_player = player

func _physics_process(delta:float):
	walk_sound_timer += delta

	if nearest_player:

		attack_timer += delta

		var towardsplayer = ((nearest_player.global_position - self.global_position).normalized() * self.run_speed)
		moving = true
		move_and_slide(towardsplayer)
		animate_movement(towardsplayer)
		last_movement_dir = towardsplayer
		try_play_walk_sound()

		var collision = move_and_collide((nearest_player.global_position - self.global_position).normalized() * self.attack_range,true,true,true)

		if collision && collision.collider.has_method("take_damage") && attack_timer >= basic_attack_cooldown :
			attack_timer = 0.0
			play_attack_anim(last_movement_dir)
			if swing_sounds.size() > 0:
				get_node(swing_sounds[randi() % swing_sounds.size()]).play()
			hit(collision.collider)

	else:
		var towardshome = ((home - self.position).normalized() * self.run_speed)
		if (home - self.position).length_squared() > 8.0:
			moving = true
			move_and_slide(towardshome)
			animate_movement(towardshome)
			last_movement_dir = towardshome
			try_play_walk_sound()
		else:
			moving = false
			animate_movement(last_movement_dir)
			walk_sound_timer = 0.0

func hit(other: CollisionObject2D):
	yield(get_tree().create_timer(attack_hit_delay), "timeout")
	if !is_instance_valid(other):
		return
	if hit_sounds.size() > 0:
		get_node(hit_sounds[randi() % hit_sounds.size()]).play()

	other.take_damage(basic_attack_dmg * basic_attack_multiplier,0,0,0)

func animate_movement(dir: Vector2):
	if playing_action:
		return
	var angle = dir.normalized().angle()
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

func play_attack_anim(direction: Vector2):
	playing_action = true
	var angle = last_movement_dir.normalized().angle()
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

func _process(delta:float):
#	DebugLabel.display(self, last_movement_dir)
#	if nearest_player:
#		DebugLabel.display(self, nearest_player.position)
#		DebugLabel.display(self, ((nearest_player.position - self.position).normalized() * self.run_speed))
#	else:
#		pass
	pass

func try_play_walk_sound():
	if walk_sound_timer > walk_sound_interval:
		walk_sound_timer = 0.0
		if walk_sounds.size() > 0:
			get_node(walk_sounds[randi() % walk_sounds.size()]).play()
