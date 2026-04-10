extends Control

signal player_acknowledged

@onready var battle_menu: Panel = $CanvasLayer/Battle_Menu
@onready var menu: GridContainer = $CanvasLayer/Battle_Menu/Menu
@onready var moves: GridContainer = $CanvasLayer/Battle_Menu/Moves
@onready var canvas_layer: CanvasLayer = $CanvasLayer

@onready var enemy_health_bar: ProgressBar = $CanvasLayer/Enemy_Info/Enemy_Health
@onready var enemy_name_label: Label = $CanvasLayer/Enemy_Info/Enemy_Name
@onready var player_health_bar: ProgressBar = $CanvasLayer/Player_Info/Player_Health
@onready var player_name_label: Label = $CanvasLayer/Player_Info/Player_Name

@onready var battle_log: RichTextLabel = $CanvasLayer/BattleInfo/BattleLog
@onready var continue_message: RichTextLabel = $CanvasLayer/BattleInfo/BattleLog/ContinueMessage

var continue_message_text: String = "Press any key to continue."

var current_label: RichTextLabel

var move_buttons: Array = []
var menu_buttons: Array = []

var is_typing: bool = false

func _ready() -> void:
	move_buttons = moves.get_children()
	menu_buttons = menu.get_children()
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
	disable_menu(true)
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
	
func disable_menu(disabled: bool) -> void:
	for button in menu_buttons:
		button.disabled = disabled
	for button in move_buttons:
		button.disabled = disabled
		
func add_log(text: String) -> void:
	await type_text(text, battle_log)
	display_continue_message()
	await player_acknowledged
	clear_log(battle_log)
	clear_log(continue_message)
	
func clear_log(label: RichTextLabel) -> void:
	label.clear()
	
func type_text(text: String, label: RichTextLabel) -> void:
	current_label = label
	is_typing = true
	label.append_text(text)
	var full_length = label.get_total_character_count()
	label.visible_characters = full_length - text.length()
	
	var tween = create_tween()
	tween.tween_property(
		label,
		"visible_characters",
		full_length,
		text.length() * 0.01
	)
	await tween.finished
	is_typing = false
	
func display_continue_message() -> void:
	type_text(continue_message_text, continue_message)

func _unhandled_input(_event: InputEvent) -> void:
	if is_typing:
		current_label.visible_characters = current_label.get_total_character_count()
	else:
		player_acknowledged.emit()
