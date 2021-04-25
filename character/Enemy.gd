extends KinematicBody2D

var health = 100.0

var attack_range: float = 30.0
var basic_attack_dmg: float = 2.00
var basic_attack_multiplier: float = 3.00
var basic_attack_cooldown: float = 5.00
var attack_timer: float = 0.00

var run_speed: float = 50.0

var nearest_player = null
onready var home = self.position

func take_damage(dmg: float):
	health -= dmg
	if health <= 0.0:
		queue_free()

func set_target(player: KinematicBody2D):
	nearest_player = player
	
func _physics_process(delta:float):		
	
	
	if nearest_player:
		
		attack_timer += delta	
		
		var towardsplayer = ((nearest_player.global_position - self.global_position).normalized() * self.run_speed)
		move_and_slide(towardsplayer)
		
		var collision = move_and_collide((nearest_player.global_position - self.global_position).normalized() * self.attack_range,true,true,true)
		
		if collision && collision.collider.has_method("take_damage") && attack_timer >= basic_attack_cooldown :
			collision.collider.take_damage(basic_attack_dmg * basic_attack_multiplier)
			attack_timer = 0.00
			
		
	else:
		var towardshome = ((home - self.position).normalized() * self.run_speed)
		move_and_slide(towardshome)
		
		
func _process(delta:float):
	if nearest_player:
		DebugLabel.display(self, nearest_player.position)
		DebugLabel.display(self, ((nearest_player.position - self.position).normalized() * self.run_speed))
	else:
		pass
