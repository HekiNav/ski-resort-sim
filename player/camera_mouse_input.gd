extends FreeLookCamera

@onready var camera = %Camera3D
@onready var ray = %RayCast3D

var mousePos = null

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return
	var ray_length = 1000
	
	var from = camera.project_ray_origin(event.position)
	var to = from + camera.project_ray_normal(event.position) * ray_length
	
	ray.target_position = to_local(to)
	
	mousePos = ray.get_collision_point() if ray.is_colliding() else null
	
func get_mouse():
	return mousePos
