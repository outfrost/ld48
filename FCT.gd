extends Label

func _show_value(value, travel, duration, spread, size=12, color=null):

	text = value
	var movement = travel.rotated(rand_range(-spread/2, spread/2))
	var react_pivot_offset = rect_size / 2

	$Tween.interpolate_property(self, "rect_position",
			rect_position, rect_position + movement,
			duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a",
			1.0, 0.0, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

	if color:
		match color:
			"RED":
				modulate = Color(1.0,0.2,0.4)
			"GREEN":
				modulate = Color(0.2,1.0,0.4)
			"YELLOW":
				modulate = Color(1.0,1.0,0.4)
			_:
				modulate = Color(1.0,1.0,1.0)


	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()

