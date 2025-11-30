@tool
extends Node3D
class_name PineTreeFiller

const PINE_TREE = preload("res://trees/pine_tree.tscn")

const MIN_DISTANCE = pow(2 ,2)

var tree_positions = SpatialHash.new(8.0)

@export_tool_button("Reload", "Reload") var reload_action = fill_pine_trees

@export var terrain: Terrain:
	set(new_terr):
		terrain = new_terr
		fill_pine_trees()

func update_paths(paths: Array):
	for tree in get_children():
		var nearbyPath = paths.find_custom(func(path):
			return path.find_custom(func(pos):
				return tree.global_position.distance_squared_to(pos) < pow(4,2)
			) >= 0
		)
		if (nearbyPath >= 0):
			tree.visible = false

func place_tree_or_not_if_feeling_like_it():
	var minPos = terrain.size * -0.5 
	var maxPos = terrain.size * 0.5 
	var random_pos = Vector3(lerpf(minPos, maxPos, randf()),0, lerpf(minPos, maxPos, randf()))
	
	var tree_pos = Vector3(
		random_pos.x,
		terrain.get_height(random_pos.x, random_pos.z),
		random_pos.z
	)
	
	if not can_place_tree(tree_pos):
		return false
	
	var new_tree = PINE_TREE.instantiate()
	
	tree_positions.add(tree_pos)
	add_child(new_tree)
	new_tree.position = tree_pos
	return true
func can_place_tree(pos: Vector3):

	var nearby = tree_positions.get_nearby(pos)
	
	for tree in nearby:
		if pos.distance_squared_to(tree) < MIN_DISTANCE:
			return false
	return true
func fill_pine_trees():
	tree_positions.clear()
	# Remove children
	for n in get_children():
		n.queue_free() 
	
	if not terrain:
		return
	var i = 0
	while i < 50:
		var success = place_tree_or_not_if_feeling_like_it()
		if success:
			i = 0
		else:
			i += 1
