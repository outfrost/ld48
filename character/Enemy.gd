extends KinematicBody2D

var health = 100.0

func take_damage(dmg: float):
	health -= dmg
	if health <= 0.0:
		queue_free()
