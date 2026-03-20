extends Node2D

signal start_battle(player: CharacterBody2D, enemy: CharacterBody2D)
signal end_battle(player_won: bool)
signal instantiate_battle_gui
signal move_selected(move_index: int)

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

func _on_start_battle(player, enemy) -> void: # battle function
	battling = true
	battle_player = player
	battle_enemy = enemy
	player.reparent(self)
	enemy.reparent(self)
	
func _on_instantiate_battle_gui() -> void:
	var battle_scene = get_tree().get_root().get_node("BattleScene")
	battle_player.reparent(battle_scene)
	battle_enemy.reparent(battle_scene)
	
	var battle_gui = get_tree().get_root().get_node("BattleScene/BattleGui")
	battle_gui.visible = true
	battle_gui.populate_moves(battle_player.moves)
	
func _on_move_selected(move_index: int) -> void:
	player_turn(move_index)
	
func player_turn(move_index: int) -> void:
	var move = battle_player.moves[move_index]
	var damage = move["dmg"]
	battle_enemy.health -= damage * (1 - battle_enemy.def)
	print("Player used %s for %d damage! Enemy HP: %d" % [move["name"], damage, battle_enemy.health])

	if battle_enemy.health <= 0:
		battle_over(true)
	else:
		enemy_turn()

func enemy_turn() -> void:
	var move = battle_enemy.attack()
	var damage = move["dmg"]
	battle_player.health -= damage * (1 - battle_player.def)
	print("Enemy attacked for %d damage! Player HP: %d" % [damage, battle_player.health])

	if battle_player.health <= 0:
		battle_over(false)
		
func battle_over(player_won: bool) -> void:
	battling = false
	if player_won:
		battle_enemy.defeated = true
	battle_player.reparent(self)
	battle_enemy.reparent(self)
	end_battle.emit(player_won)
