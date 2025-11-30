extends Node3D

var paths = []

@export var player: SpectatorPlayer
@export var toolbar: ToolBar
@export var terrain: Terrain
@export var pine_tree_filler: PineTreeFiller

enum ToolBarButtonType{
	PATH,
	BUILD
}

func _on_gui_input(event: InputEvent) -> void:
	var tool_mode = toolbar.get_tool_mode()
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed and tool_mode == ToolBarButtonType.PATH:
			paths.append([])
		elif event.button_index == 1 and tool_mode == ToolBarButtonType.PATH:
			pine_tree_filler.update_paths(paths)
	if event is InputEventMouseMotion:
		var pos = player.get_mouse()
		if event.button_mask == 1 and tool_mode == ToolBarButtonType.PATH:
			if len(paths):
				if not pos:
					if len(paths.back()): paths.append([])
					return
				paths[len(paths)-1].append(pos)
				update_paths()
		elif tool_mode == ToolBarButtonType.BUILD:
			pass
		

func update_paths():
	terrain.update_paths(paths)
