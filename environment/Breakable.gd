extends StaticBody2D

var health: float = 100.0
export var resist_base: float = 0.00
export var resist_fire: float = 0.00
export var resist_ice: float = 0.00
export var resist_wind: float = 0.00
onready var home = self.position

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
