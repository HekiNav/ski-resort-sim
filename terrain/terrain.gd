@tool
extends StaticBody3D
class_name Terrain
@onready var mesh_instance: MeshInstance3D = %MeshInstance3D
@onready var collision_shape: CollisionShape3D = %CollisionShape3D

var array_mesh

@export var size := 64.0:
	set(new_size):
		size = new_size
		update_mesh()

@export_range(4, 65536, 4) var resolution := 32:
	set(new_res):
		resolution = new_res
		update_mesh()
@export var noise: Noise:
	set(new_noise):
		noise = new_noise
		update_mesh()
		if noise:
			noise.changed.connect(update_mesh)
			
@export_range(4, 64, 1) var height := 4:
	set(new_height):
		height = new_height
		update_mesh()

func get_height(x: float, y: float):
	return noise.get_noise_2d(x,y) * pow(height,2) *0.1

func get_normal(x: float, y: float):
	var epsilon = size / resolution
	var normal = Vector3(
		(get_height(x + epsilon,y) - get_height(x-epsilon, y) / (2.0 * epsilon)),
		1.0,
		(get_height(x,y + epsilon) - get_height(x, y - epsilon) / (2.0 * epsilon)),
	)
	return normal.normalized()

func update_mesh():
	var plane := PlaneMesh.new()
	plane.subdivide_depth = resolution
	plane.subdivide_width = resolution
	plane.size = Vector2(size, size)
	
	var plane_arrays := plane.get_mesh_arrays()
	
	var vertex_arr:PackedVector3Array = plane_arrays[ArrayMesh.ARRAY_VERTEX]
	var normal_arr:PackedVector3Array = plane_arrays[ArrayMesh.ARRAY_NORMAL]
	var tangent_arr:PackedFloat32Array = plane_arrays[ArrayMesh.ARRAY_TANGENT]
	
	for i: int in vertex_arr.size():
		var vertex = vertex_arr[i]
		var normal = Vector3.UP #normal_arr[i]
		var tangent = Vector3.RIGHT #tangent_arr[i]
		
		if noise:
			vertex.y = get_height(vertex.x, vertex.z)
			normal = get_normal(vertex.x, vertex.z)
			tangent = normal.cross(Vector3.UP)
		vertex_arr[i] = vertex
		normal_arr[i] = normal
		tangent_arr[4*i] = tangent.x
		tangent_arr[4*i+1] = tangent.y
		tangent_arr[4*i+2] = tangent.z
	array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, plane_arrays)
	
	
	if mesh_instance:
		apply_mesh()

func _ready() -> void:
	apply_mesh()

func apply_mesh():
	mesh_instance.mesh = array_mesh
	
	var collision_mesh = mesh_instance.mesh.create_trimesh_shape()
	
	collision_shape.shape = collision_mesh
	
	mesh_instance.material_override.set_shader_parameter("height",0.5)
