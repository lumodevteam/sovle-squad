extends Node2D

const player_scene = preload("res://scenes/entities/player/player.tscn")
const enemy_scene = preload("res://scenes/entities/npcs/enemy/enemy.tscn")
const npc_scene = preload("res://scenes/entities/npcs/npc/npc.tscn")

const player_starting_pos: Vector2 = Vector2(0, 0)
const enemy1_starting_pos: Vector2 = Vector2(-200, -320)
const npc_starting_pos: Vector2 = Vector2(200, -120)

var player: Node2D
var enemy1: Node2D
var enemy2: Node2D
var npc: Node2D

func _ready() -> void:
	if Navigation.tutorial_scene not in Navigation.visited_before:
		Navigation.visited_before.append(Navigation.tutorial_scene)
		player = spawn_sprite(player_starting_pos, player_scene)
		player.identifier = "player"
		GlobalSprites.sprites[player.identifier] = player
		enemy1 = spawn_sprite(enemy1_starting_pos, enemy_scene)
		enemy1.identifier = "enemy1"
		GlobalSprites.sprites[enemy1.identifier] = enemy1
		npc = spawn_sprite(npc_starting_pos, npc_scene)
		npc.identifier = "npc"
		GlobalSprites.sprites[npc.identifier] = npc
	else:
		player = GlobalSprites.sprites["player"]
		enemy1 = GlobalSprites.sprites["enemy1"]
		npc = GlobalSprites.sprites["npc"]
		player.position = player_starting_pos
		enemy1.position = enemy1_starting_pos
		npc.position = npc_starting_pos
	
func spawn_sprite(pos: Vector2, sprite: PackedScene) -> Node2D:
	var new_sprite = sprite.instantiate()
	new_sprite.position = pos
	add_child(new_sprite)
	return new_sprite
