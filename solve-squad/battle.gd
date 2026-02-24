extends Node

@onready var camera: Camera2D = $Camera2D # camera for battle scene

var battling: bool = false # is there a battle happening
var rng = RandomNumberGenerator.new()
var weights = PackedFloat32Array([0.5, 0.7, 1, 0.7, 0.5])

func battle(player, enemy) -> void: # battle function
	battling = true
	get_tree().change_scene_to_file('res://scenes/battle.tscn')
	
	var mid: int = player.lvl
	var enemy_lvls: Array = [mid - 2, mid - 1, mid, mid + 1, mid + 2]
	
	enemy.lvl = enemy_lvls[rng.rand_weighted(weights)] # picks a random lvl for the enemy
	
	if enemy.lvl <= 0:
		enemy.lvl = 1
	
	# while player.health > 0 and enemy.health > 0:
