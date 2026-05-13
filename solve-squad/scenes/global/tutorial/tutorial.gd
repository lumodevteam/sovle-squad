extends Node2D

const player_scene: PackedScene = preload("res://scenes/entities/player/player.tscn")
const enemy_scene: PackedScene = preload("res://scenes/entities/npcs/enemy/enemy.tscn")
const npc1_scene: PackedScene = preload("res://scenes/entities/npcs/npc1/npc1.tscn")
const npc2_scene: PackedScene = preload("res://scenes/entities/npcs/npc2/npc2.tscn")
const number_line_scene: PackedScene = preload("res://scenes/entities/numberLine/numberLine.tscn")
const fountain_scene: PackedScene = preload("res://scenes/entities/objects/fountain.tscn")

@onready var player_starting_pos: Vector2 = $PlayerPlaceholder.position
@onready var player_respawn_point: Vector2 = $PlayerRespawnPoint.position
@onready var enemy1_starting_pos: Vector2 = $Enemy1Placeholder.position
@onready var enemy2_starting_pos: Vector2 = $Enemy2Placeholder.position
@onready var enemy3_starting_pos: Vector2 = $Enemy3Placeholder.position
@onready var enemy4_starting_pos: Vector2 = $Enemy4Placeholder.position
@onready var enemy5_starting_pos: Vector2 = $Enemy5Placeholder.position
@onready var enemy6_starting_pos: Vector2 = $Enemy6Placeholder.position
@onready var enemy7_starting_pos: Vector2 = $Enemy7Placeholder.position
@onready var enemy8_starting_pos: Vector2 = $Enemy8Placeholder.position
@onready var enemy9_starting_pos: Vector2 = $Enemy9Placeholder.position
@onready var npc1_starting_pos: Vector2 = $NPC1Placeholder.position
@onready var npc2_starting_pos: Vector2 = $NPC2Placeholder.position
@onready var number_line_starting_pos: Vector2 = $NumberLinePlaceholder.position
@onready var fountain_starting_pos: Vector2 = $FountainPlaceholder.position

var player: Node2D
var enemy1: Node2D
var enemy2: Node2D
var enemy3: Node2D
var enemy4: Node2D
var enemy5: Node2D
var enemy6: Node2D
var enemy7: Node2D
var enemy8: Node2D
var enemy9: Node2D
var npc1: Node2D
var npc2: Node2D
var number_line: Node2D
var fountain: Node2D

var number_line_exists: bool = false

func _ready() -> void:
	TutorialEvents.quest_started.connect(_on_quest_started)
	if Navigation.tutorial_scene not in Navigation.visited_before:
		Navigation.visited_before.append(Navigation.tutorial_scene)
		create_player()
		enemy1 = spawn_sprite(enemy1_starting_pos, enemy_scene, "enemy1")
		enemy2 = spawn_sprite(enemy2_starting_pos, enemy_scene, "enemy2")
		enemy3 = spawn_sprite(enemy3_starting_pos, enemy_scene, "enemy3")
		enemy4 = spawn_sprite(enemy4_starting_pos, enemy_scene, "enemy4")
		enemy5 = spawn_sprite(enemy5_starting_pos, enemy_scene, "enemy5")
		enemy6 = spawn_sprite(enemy6_starting_pos, enemy_scene, "enemy6")
		enemy7 = spawn_sprite(enemy7_starting_pos, enemy_scene, "enemy7")
		enemy8 = spawn_sprite(enemy8_starting_pos, enemy_scene, "enemy8")
		enemy9 = spawn_sprite(enemy9_starting_pos, enemy_scene, "enemy9")	
		npc1 = spawn_sprite(npc1_starting_pos, npc1_scene, "npc1")
		npc2 = spawn_sprite(npc2_starting_pos, npc2_scene, "npc2")
		fountain = spawn_sprite(fountain_starting_pos, fountain_scene, "fountain")
	else:
		if number_line_exists:
			number_line = respawn_sprite("number_line")
		player = respawn_sprite("player")
		enemy1 = respawn_sprite("enemy1")
		enemy2 = respawn_sprite("enemy2")
		enemy3 = respawn_sprite("enemy3")
		enemy4 = respawn_sprite("enemy4")
		enemy5 = respawn_sprite("enemy5")
		enemy6 = respawn_sprite("enemy6")
		enemy7 = respawn_sprite("enemy7")
		enemy8 = respawn_sprite("enemy8")
		enemy9 = respawn_sprite("enemy9")
		npc1 = respawn_sprite("npc1")
		npc2 = respawn_sprite("npc2")
		fountain = respawn_sprite("fountain")
		
func respawn_sprite(id: String) -> Node2D:
	var sprite = GlobalSprites.sprites[id]["sprite"]
	sprite.position = GlobalSprites.sprites[id]["position"]
	return sprite
		
func create_player() -> void:
	player = spawn_sprite(player_starting_pos, player_scene, "player")
	GlobalSprites.sprites[player.identifier].merge({
		"max_health" : player.max_health,
		"current_health" : player.health,
		"inventory" : []
	})
	
func spawn_sprite(pos: Vector2, sprite: PackedScene, id: String) -> Node2D:
	var new_sprite = sprite.instantiate()
	new_sprite.position = pos
	add_child(new_sprite)
	new_sprite.identifier = id
	GlobalSprites.sprites[id] = {
		"sprite" : new_sprite,
		"position" : pos
	}
	
	return new_sprite
	
func _on_quest_started() -> void:
	if not number_line_exists:
		number_line_exists = true
		spawn_number_line()
	
func spawn_number_line() -> void:
	number_line = spawn_sprite(number_line_starting_pos, number_line_scene, "number_line")
	number_line.create_number_line()
