extends Panel

@export var menu: GridContainer
@export var moves: GridContainer

func change_labels(buttons, new_labels) -> void:
	var i: int = 0
	
	for button in buttons:
		button.label = new_labels[i]["name"]
		i += 1

func toggle_visibility(object) -> void:
	if object.visible:
		object.visible = false
	else:
		object.visible = true

func _on_attack_pressed() -> void:
	toggle_visibility(menu)
	toggle_visibility(moves)

func _on_back_pressed() -> void:
	toggle_visibility(moves)
	toggle_visibility(menu)
	
