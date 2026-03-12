extends Node2D

signal start_battle(player: CharacterBody2D, enemy: CharacterBody2D)
signal battle_over
signal instantiate_battle_gui
signal instantiate_battle

var battling: bool = false # is there a battle happening
var rng = RandomNumberGenerator.new()
var weights = PackedFloat32Array([0.5, 0.7, 1, 0.7, 0.5])

func _ready():
	start_battle.connect(_on_start_battle)
	instantiate_battle.connect(_on_instantiate_battle)
	instantiate_battle_gui.connect(_on_instantiate_battle_gui)	

func _on_start_battle(player, enemy) -> void: # battle function
	battling = true
	var battle_player = player
	var battle_enemy = enemy
	
func _on_instantiate_battle() -> void:
	var battle_scene = preload("res://scenes/global/battle/battle.tscn")
	var battle_instance = battle_scene.instantiate()
	
	
func _on_instantiate_battle_gui() -> void:
	var battle_gui_scene = preload("res://scenes/global/battle/battle_gui.tscn")
	var battle_gui_instance = battle_gui_scene.instantiate()
	add_child(battle_gui_instance)
	var battle_menu = battle_gui_instance.battle_menu
	battle_menu.position = Vector2(0, 0)
