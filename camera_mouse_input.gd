extends FreeLookCamera

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return
	print(event.global_position)
	
