extends Node2D

const player_scene: PackedScene = preload("res://scenes/entities/player/player.tscn")
const enemy_scene: PackedScene = preload("res://scenes/entities/npcs/enemy/enemy.tscn")
const npc_scene: PackedScene = preload("res://scenes/entities/npcs/npc/npc.tscn")
const number_line_scene: PackedScene = preload("res://scenes/entities/numberLine/numberLine.tscn")

@onready var player_starting_pos: Vector2 = $PlayerPlaceholder.position
@onready var enemy1_starting_pos: Vector2 = $Enemy1Placeholder.position
@onready var enemy2_starting_pos: Vector2 = $Enemy2Placeholder.position
@onready var npc_starting_pos: Vector2 = $NPCPlaceholder.position
@onready var number_line_starting_pos: Vector2 = $NumberLinePlaceholder.position

var player: Node2D
var enemy1: Node2D
var enemy2: Node2D
var npc: Node2D
var number_line: Node2D

var number_line_exists: bool = false

func _ready() -> void:
	TutorialQuests.quest_started.connect(_on_quest_started)
	if Navigation.tutorial_scene not in Navigation.visited_before:
		Navigation.visited_before.append(Navigation.tutorial_scene)
		player = spawn_sprite(player_starting_pos, player_scene)
		player.identifier = "player"
		GlobalSprites.sprites[player.identifier] = {
			"sprite" : player,
			"position" : player_starting_pos,
			"health" : player.max_health,
			"inventory" : []
		}
		enemy1 = spawn_sprite(enemy1_starting_pos, enemy_scene)
		enemy1.identifier = "enemy1"
		GlobalSprites.sprites[enemy1.identifier] = {
			"sprite" : enemy1,
			"position" : enemy1_starting_pos
		}
		enemy2 = spawn_sprite(enemy2_starting_pos, enemy_scene)
		enemy2.identifier = "enemy2"
		GlobalSprites.sprites[enemy2.identifier] = {
			"sprite" : enemy2,
			"position" : enemy2_starting_pos
		}
		npc = spawn_sprite(npc_starting_pos, npc_scene)
		npc.identifier = "npc"
		GlobalSprites.sprites[npc.identifier] = {
			"sprite" : npc,
			"position" : npc_starting_pos
		}
	else:
		if number_line_exists:
			number_line = GlobalSprites.sprites["number_line"]["sprite"]
			number_line.position = GlobalSprites.sprites["number_line"]["position"]
		player = GlobalSprites.sprites["player"]["sprite"]
		player.position = GlobalSprites.sprites["player"]["position"]
		enemy1 = GlobalSprites.sprites["enemy1"]["sprite"]
		enemy1.position = GlobalSprites.sprites["enemy1"]["position"]
		enemy2 = GlobalSprites.sprites["enemy2"]["sprite"]
		enemy2.position = GlobalSprites.sprites["enemy2"]["position"]
		npc = GlobalSprites.sprites["npc"]["sprite"]
		npc.position = GlobalSprites.sprites["npc"]["position"]
	
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
	number_line.create_number_line()
	number_line.identifier = "number_line"
	GlobalSprites.sprites[number_line.identifier] = {
			"sprite" : number_line,
			"position" : number_line_starting_pos
		}
