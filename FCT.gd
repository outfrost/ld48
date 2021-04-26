extends Label

func _show_value(value, travel, duration, spread):
	
	text = value
	var movement = travel.rotated(rand_range(-spread/2, spread/2))
	var react_pivot_offset = rect_size / 2
	
	$Tween.interpolate_property(self, "rect_position",
			rect_position, rect_position + movement,
			duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a",
			1.0, 0.0, duration,Tween.TRANS_BACK,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			
	$Tween.start()
	yield($Tween, "tween_all_completed")
	queue_free()
	
