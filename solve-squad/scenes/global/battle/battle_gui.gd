extends Control

@onready var battle_menu: Panel = $Battle_Menu
@onready var menu: GridContainer = $Battle_Menu/Menu
@onready var moves: GridContainer = $Battle_Menu/Moves

@onready var enemy_health_bar: ProgressBar = $Enemy_Info/Enemy_Health
@onready var enemy_name_label: Label = $Enemy_Info/Enemy_Name
@onready var player_health_bar: ProgressBar = $Player_Info/Player_Health
@onready var player_name_label: Label = $Player_Info/Player_Name

var move_buttons: Array = []

func _ready() -> void:
	move_buttons = moves.get_children()
	for i in range(move_buttons.size()):
		var button = move_buttons[i]
		if button.text != "Back":
			var move_index = i + 1  # moves dictionary is 1-indexed
			button.pressed.connect(func(): _on_move_pressed(move_index))

func populate_moves(player_moves: Dictionary) -> void:
	for i in range(move_buttons.size()):
		if move_buttons[i].text == "Back":
			continue
		var move_index = i + 1  # convert 0-based loop to 1-based dictionary key
		if player_moves.has(move_index):
			move_buttons[i].text = player_moves[move_index]["name"]
			move_buttons[i].disabled = false
		else:
			move_buttons[i].text = ""
			move_buttons[i].disabled = true
			
func _on_move_pressed(move_index: int) -> void:
	toggle_visibility(moves)
	toggle_visibility(menu)
	Battle.move_selected.emit(move_index)
			
func toggle_visibility(object) -> void:
	object.visible = !object.visible

func _on_attack_pressed() -> void:
	toggle_visibility(menu)
	toggle_visibility(moves)

func _on_back_pressed() -> void:
	toggle_visibility(moves)
	toggle_visibility(menu)
	
func setup_health_bars(player, enemy) -> void:
	player_health_bar.max_value = player.health
	player_health_bar.value = player.health
	player_name_label.text = "Player"
	enemy_health_bar.max_value = enemy.health
	enemy_health_bar.value = enemy.health
	enemy_name_label.text = "Enemy"

func update_health_bars(player_hp: int, enemy_hp: int) -> void:
	player_health_bar.value = player_hp
	enemy_health_bar.value = enemy_hp
	
