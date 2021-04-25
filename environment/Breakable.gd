extends StaticBody2D

var health: float = 100.0
onready var home = self.position

func take_damage(dmg: float):
	health -= dmg
	if health <= 0.0:
		queue_free()
