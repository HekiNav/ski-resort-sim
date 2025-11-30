extends Node2D
class_name CanvasLayerCustom

var paths = []


func update_paths(new_paths):
	paths = new_paths
	queue_redraw()


func _draw() -> void:
	var size = get_viewport_rect().size
	for path in paths:
		var flatPath = path.map(func(v3: Vector3): return Vector2(
			(v3.x)*8+(size.x*0.5),
			(v3.z)*8+(size.x*0.5)
			)
		)
		
		draw_polyline(flatPath,Color(0.13, 0.13, 0.13, 1.0),16,true)
	
