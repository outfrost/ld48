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

var run_speed: float = 50.0

var nearest_player = null
onready var home = self.position

var walk_sound_timer: float = 0.0

func take_damage(dmg: float, fire_dmg: float, ice_dmg: float, wind_dmg: float):

	health -= (1.0 - resist_base) * dmg
	health -= (1.0 - resist_fire) * fire_dmg
	health -= (1.0 - resist_ice) * ice_dmg
	health -= (1.0 - resist_wind) * wind_dmg

	if health <= 0.0:
		queue_free()

func set_target(player: KinematicBody2D):
	nearest_player = player

func _physics_process(delta:float):
	walk_sound_timer += delta

	if nearest_player:

		attack_timer += delta

		var towardsplayer = ((nearest_player.global_position - self.global_position).normalized() * self.run_speed)
		move_and_slide(towardsplayer)
		try_play_walk_sound()

		var collision = move_and_collide((nearest_player.global_position - self.global_position).normalized() * self.attack_range,true,true,true)

		if collision && collision.collider.has_method("take_damage") && attack_timer >= basic_attack_cooldown :
			attack_timer = 0.0
			if swing_sounds.size() > 0:
				get_node(swing_sounds[randi() % swing_sounds.size()]).play()
			hit(collision.collider)

	else:
		var towardshome = ((home - self.position).normalized() * self.run_speed)
		move_and_slide(towardshome)
		if (home - self.position).length_squared() > 4.0:
			try_play_walk_sound()
		else:
			walk_sound_timer = 0.0

func hit(other: CollisionObject2D):
	yield(get_tree().create_timer(attack_hit_delay), "timeout")
	if !is_instance_valid(other):
		return
	if hit_sounds.size() > 0:
		get_node(hit_sounds[randi() % hit_sounds.size()]).play()

	other.take_damage(basic_attack_dmg * basic_attack_multiplier,0,0,0)


func _process(delta:float):
	if nearest_player:
		DebugLabel.display(self, nearest_player.position)
		DebugLabel.display(self, ((nearest_player.position - self.position).normalized() * self.run_speed))
	else:
		pass

func try_play_walk_sound():
	if walk_sound_timer > walk_sound_interval:
		walk_sound_timer = 0.0
		if walk_sounds.size() > 0:
			get_node(walk_sounds[randi() % walk_sounds.size()]).play()
