extends Control

@onready var battle_menu: Panel = $Battle_Menu
@onready var menu: GridContainer = $Battle_Menu/Menu
@onready var moves: GridContainer = $Battle_Menu/Moves

func _ready() -> void:
	# var move_buttons = moves.get_children()
	print("Children of self:", get_children())
	print("Battle_Menu exists?", $Battle_Menu)
	print("Moves exists?", $Battle_Menu.get_node("Moves") if $Battle_Menu else null)

func _populate_moves(moves) -> void:
	for i in range(self.move_buttons.size()):
		if i < moves.size():
			self.move_buttons[i].text = moves[i]["name"]
			self.move_buttons[i].disabled = false
		else:
			self.move_buttons[i].text = ""
			self.move_buttons[i].disabled = true
			
func toggle_visibility(object) -> void:
	object.visible = !object.visible

func _on_attack_pressed() -> void:
	toggle_visibility(menu)
	toggle_visibility(moves)

func _on_back_pressed() -> void:
	toggle_visibility(moves)
	toggle_visibility(menu)
	
