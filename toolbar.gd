extends BoxContainer
class_name ToolBar

@export var button_group: ButtonGroup

@onready var tool_buttons = get_toolbar_buttons()

func get_toolbar_buttons():
	var children = get_children()
	return children.filter(func(c):
		return c is Button && c.button_group == button_group
	)
enum ToolBarButtonType{
	PATH,
	BUILD
}
func get_tool_mode() -> ToolBarButtonType:
	return tool_buttons.find_custom(func(b: Button):
		return b.button_pressed
	)
