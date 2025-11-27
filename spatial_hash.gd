class_name SpatialHash
extends Object

var cell_size: float
var cells := {}

func _init(cell_size: float = 10.0):
	self.cell_size = cell_size

func get_cell_id(pos: Vector3) -> Vector3i:
	return Vector3i(
		int(floor(pos.x / cell_size)),
		int(floor(pos.y / cell_size)),
		int(floor(pos.z / cell_size))
	)
func clear():
	cells = {}
func add(pos: Vector3):
	var id = get_cell_id(pos)
	if not cells.has(id):
		cells[id] = []
	cells[id].append(pos)

func get_nearby(pos: Vector3) -> Array:
	var id = get_cell_id(pos)
	var out := []

	for x in range(id.x - 1, id.x + 2):
		for y in range(id.y - 1, id.y + 2):
			for z in range(id.z - 1, id.z + 2):
				var cid = Vector3i(x, y, z)
				if cells.has(cid):
					out.append_array(cells[cid])

	return out
