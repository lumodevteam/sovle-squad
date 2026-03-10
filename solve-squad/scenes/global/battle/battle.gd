extends Node2D

signal start_battle(player: CharacterBody2D, enemy: CharacterBody2D)
signal battle_over

var battling: bool = false # is there a battle happening
var rng = RandomNumberGenerator.new()
var weights = PackedFloat32Array([0.5, 0.7, 1, 0.7, 0.5])

func _ready():
	start_battle.connect(_on_start_battle)

func _on_start_battle(player, enemy) -> void: # battle function
	battling = true
	var battle_player = player
	var battle_enemy = enemy
	print(battle_player, battle_enemy)
	print(battle_player.moves)
