extends FreeLookCamera

@onready var camera = %Camera3D
@onready var ray = %RayCast3D
func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return
	var ray_length = 1000
	
	var from = camera.project_ray_origin(event.position)
	var to = from + camera.project_ray_normal(event.position) * ray_length
	
	ray.target_position = to_local(to)
	
