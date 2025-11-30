extends Node3D
class_name BuildingCollection

var building = preload("res://building.tscn")
@onready var preview_building = building.instantiate()

@export var terrain: Terrain

func _ready() -> void:
	add_child(preview_building)

var paths = []

func update_paths(new_paths):
	paths = new_paths
	
func update_preview(mouse_pos):
	var closest_point = closest_point_on_polylines(mouse_pos,paths)
	var distance_from_road = 3
	
	var point1: Vector3 = closest_point.point + closest_point.dir * 5
	var point2: Vector3 = closest_point.point + closest_point.dir * -5
	var pos = point1 if point1.distance_squared_to(mouse_pos) < point2.distance_squared_to(mouse_pos) else point2
	preview_building.position = Vector3(pos.x,terrain.get_height(pos.x,pos.z), pos.z)
	
	
func show_preview():
	preview_building.visible = true
func hide_preview():
	preview_building.visible = false
func place_building(from_preview=true, pos = Vector3.ZERO):
	var new_building = building.instantiate()
	add_child(new_building)
	var position = preview_building.position if from_preview else pos
	new_building.position = position
	return [position, position]

func closest_point_on_polylines(point: Vector3, polylines: Array):
	var closest := Vector3.INF
	var min_dist := INF
	var dir = Vector3.ZERO

	for polyline in polylines:
		if polyline.size() < 2:
			continue
		var candidate = closest_point_on_polyline(point, polyline)
		var dist = point.distance_to(candidate.point)

		if dist < min_dist:
			min_dist = dist
			closest = candidate.point
			dir = candidate.dir

	return {"point":closest,"dir": dir}


func closest_point_on_polyline(point: Vector3, polyline: Array) -> Dictionary:
	var closest_point := Vector3.INF
	var dir = Vector3.ZERO
	var min_dist := INF

	for i in range(polyline.size() - 1):
		var a: Vector3 = polyline[i]
		var b: Vector3 = polyline[i + 1]

		var seg_closest = closest_point_on_segment(point, a, b)
		var dist = point.distance_to(seg_closest)

		if dist < min_dist:
			min_dist = dist
			closest_point = seg_closest
			var temp_dir = (Vector2(b.x,b.z) - Vector2(a.x,a.z)).normalized()
			dir = Vector3(temp_dir.x, 0, temp_dir.y).rotated(Vector3(0,1,0),PI*0.5)
			
	return {"point":closest_point,"dir": dir}

	
func closest_point_on_segment(p: Vector3, a: Vector3, b: Vector3) -> Vector3:
	var ab = b - a
	var t = (p - a).dot(ab) / ab.length_squared()

	t = clamp(t, 0.0, 1.0)
	return a + ab * t
