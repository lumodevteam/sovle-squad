extends Node2D

signal start_battle(player: CharacterBody2D, enemy: CharacterBody2D)
signal end_battle(player_won: bool)
signal instantiate_battle_gui
signal move_selected(move_index: int)
signal setup_battle
signal gain_exp(gained_exp: int)
signal ask_question
signal question_answered(question_correct: bool)
signal instantiate_question

var battling: bool = false # is there a battle happening
var rng = RandomNumberGenerator.new()
var weights = PackedFloat32Array([0.5, 0.7, 1, 0.7, 0.5])
var battle_player
var battle_enemy
var player_moves: Dictionary = {}

func _ready():
	start_battle.connect(_on_start_battle)
	instantiate_battle_gui.connect(_on_instantiate_battle_gui)	
	move_selected.connect(_on_move_selected)
	setup_battle.connect(_on_setup_battle)
	instantiate_question.connect(_on_instantiate_question)
	ask_question.connect(_on_ask_question)
	question_answered.connect(_question_answered)

func _on_start_battle(player, enemy) -> void: # battle function
	battling = true
	battle_player = player
	battle_enemy = enemy
	GlobalSprites.hide_sprites([battle_player.identifier, battle_enemy.identifier])
	
func _on_setup_battle() -> void:
	var battle_scene = get_tree().get_root().get_node("BattleScene")
	battle_player.reparent(battle_scene)
	battle_enemy.reparent(battle_scene)
	battle_player.position = Vector2(476, 0)
	battle_enemy.position = Vector2(676, 0)
	
func show_sprites(visible: bool) -> void:
	battle_player.visible = visible
	battle_enemy.visible = visible
	
func _on_instantiate_battle_gui() -> void:
	var battle_gui = get_battle_gui()
	show_battle_gui(true)
	battle_gui.populate_moves(battle_player.moves)
	battle_gui.setup_health_bars(battle_player, battle_enemy)
	
func show_battle_gui(visible: bool) -> void:
	get_battle_gui().canvas_layer.visible = visible
		
func get_battle_gui():
	return get_tree().get_root().get_node("BattleScene/CanvasLayer/BattleGui")
	
func _on_instantiate_question() -> void:
	show_question(false)
	
func _on_ask_question() -> void:
	Transition.transition()
	await Transition.on_transition_finished
	show_battle_gui(false)
	show_question(true)
	show_sprites(false)
	
func _question_answered(_correct) -> void:
	Transition.transition()
	await Transition.on_transition_finished
	show_sprites(true)
	show_question(false)
	show_battle_gui(true)

func get_question() -> Control:
	return get_tree().get_root().get_node("BattleScene/CanvasLayer/Question")
	
func show_question(visible: bool) -> void:
	get_question().canvas_layer.visible = visible
	
func _on_move_selected(move_index: int) -> void:
	player_turn(move_index)
	
func player_turn(move_index: int) -> void:
	ask_question.emit()
	var move = battle_player.moves[move_index]
	var correct = await question_answered
	await get_tree().create_timer(1.0).timeout
	if correct:
		var damage = move["dmg"]
		var actual_damage = roundi(damage * (1.0 - battle_enemy.def))
		battle_enemy.health -= actual_damage
		if actual_damage < 0:
			actual_damage = 0
		await get_battle_gui().add_log("Player used %s for %d damage!" % [move["name"], actual_damage])
	else:
		await get_battle_gui().add_log("Player tried to use %s but missed!" % [move["name"]])
	update_gui()
	if battle_enemy.health <= 0:
		await get_battle_gui().add_log("Enemy was defeated!")
		battle_over(true)
	else:
		await enemy_turn()
		disable_menu(false)

func enemy_turn() -> void:
	var move = battle_enemy.attack()
	var damage = move["dmg"]
	var actual_damage = roundi(damage * (1.0 - battle_player.def))
	if actual_damage < 0:
		actual_damage = 0
	battle_player.health -= actual_damage
	await get_battle_gui().add_log("Enemy used %s for %d damage!" % [move["name"], actual_damage])
	update_gui()
	if battle_player.health <= 0:
		await get_battle_gui().add_log("You were defeated!")
		battle_over(false)
		
func battle_over(player_won: bool) -> void:
	battling = false
	if player_won:
		await get_battle_gui().add_log("You gained exp!")
		var old_player_lvl = battle_player.lvl
		var gained_exp: int = 0
		if battle_enemy.lvl == battle_player.lvl:
			gained_exp += 40 + randi() % 20
		elif battle_enemy.lvl > battle_player.lvl:
			gained_exp += (50 + randi() % 30) * (battle_enemy.lvl - battle_player.lvl)
		else:
			gained_exp += (35 + randi() % 10) / (battle_player.lvl - battle_enemy.lvl)
		gain_exp.emit(gained_exp)
		if battle_player.lvl > old_player_lvl:
			await get_battle_gui().add_log("You leveled up! " + str(old_player_lvl) + " -> " + str(battle_player.lvl))
		battle_enemy.defeated = true
	end_battle.emit(player_won)
	
func update_gui() -> void:
	get_battle_gui().update_health_bars(battle_player.health, battle_enemy.health)
	
func disable_menu(disabled: bool) -> void:
	get_battle_gui().disable_menu(disabled)
