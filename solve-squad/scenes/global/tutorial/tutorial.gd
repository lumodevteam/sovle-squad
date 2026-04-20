extends Node2D

const player_scene: PackedScene = preload("res://scenes/entities/player/player.tscn")
const enemy_scene: PackedScene = preload("res://scenes/entities/npcs/enemy/enemy.tscn")
const npc_scene: PackedScene = preload("res://scenes/entities/npcs/npc/npc.tscn")
const number_line_scene: PackedScene = preload("res://scenes/entities/numberLine/numberLine.tscn")

const player_starting_pos: Vector2 = Vector2(0, 0)
const enemy1_starting_pos: Vector2 = Vector2(-200, -320)
const enemy2_starting_pos: Vector2 = Vector2(-400, -320)
const npc_starting_pos: Vector2 = Vector2(200, -120)
const number_line_starting_pos: Vector2 = Vector2(0, 0)

signal quest_started
signal quest_completed
signal gain_exp(gained_exp: int)
signal gain_item(item: String)

var player: Node2D
var enemy1: Node2D
var enemy2: Node2D
var npc: Node2D
var number_line: Node2D

var number_line_exists: bool = false

func _ready() -> void:
	quest_started.connect(_on_quest_started)
	if Navigation.tutorial_scene not in Navigation.visited_before:
		Navigation.visited_before.append(Navigation.tutorial_scene)
		player = spawn_sprite(player_starting_pos, player_scene)
		player.identifier = "player"
		GlobalSprites.sprites[player.identifier] = player
		enemy1 = spawn_sprite(enemy1_starting_pos, enemy_scene)
		enemy1.identifier = "enemy1"
		GlobalSprites.sprites[enemy1.identifier] = enemy1
		enemy2 = spawn_sprite(enemy2_starting_pos, enemy_scene)
		enemy2.identifier = "enemy2"
		GlobalSprites.sprites[enemy2.identifier] = enemy2
		npc = spawn_sprite(npc_starting_pos, npc_scene)
		npc.identifier = "npc"
		GlobalSprites.sprites[npc.identifier] = npc
	else:
		if number_line_exists:
			number_line = GlobalSprites.sprites["number_line"]
			number_line.position = npc_starting_pos
		player = GlobalSprites.sprites["player"]
		player.position = player_starting_pos
		enemy1 = GlobalSprites.sprites["enemy1"]
		enemy1.position = enemy1_starting_pos
		enemy2 = GlobalSprites.sprites["enemy2"]
		enemy2.position = enemy2_starting_pos
		npc = GlobalSprites.sprites["npc"]
		npc.position = npc_starting_pos
	
func spawn_sprite(pos: Vector2, sprite: PackedScene) -> Node2D:
	var new_sprite = sprite.instantiate()
	new_sprite.position = pos
	add_child(new_sprite)
	return new_sprite
	
func _on_quest_started() -> void:
	if not number_line_exists:
		number_line_exists = true
		spawn_number_line()
	
func spawn_number_line() -> void:
	number_line = spawn_sprite(number_line_starting_pos, number_line_scene)
	number_line.identifier = "number_line"
	GlobalSprites.sprites[number_line.identifier] = number_line
