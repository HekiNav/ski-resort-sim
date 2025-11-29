extends Node3D

var paths = []

@export var player: SpectatorPlayer
@export var toolbar: ToolBar
@export var terrain: Terrain

enum ToolBarButtonType{
	PATH,
	BUILD
}

func _on_gui_input(event: InputEvent) -> void:
	var tool_mode = toolbar.get_tool_mode()
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed and tool_mode == ToolBarButtonType.PATH:
			paths.append([])
	if event is InputEventMouseMotion:
		if event.button_mask == 1 and tool_mode == ToolBarButtonType.PATH:
			var pos = player.get_mouse()
			if len(paths):
				paths[len(paths)-1].append(pos)
				update_paths()

func update_paths():
	
	pass
