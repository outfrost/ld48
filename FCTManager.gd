extends Node2D

var FCT = preload("res://character/FCT.tscn")

export var travel = Vector2(0, -80)
export var duration = 2
export var spread = PI/2

func _show_value(value, size=12):
	var fct = FCT.instance()
	add_child(fct)
	fct._show_value(str(value), travel, duration, spread, size)
