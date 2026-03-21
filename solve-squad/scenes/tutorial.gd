extends Node2D

const player_scene = preload("res://scenes/entities/player/player.tscn")
const enemy_scene = preload("res://scenes/entities/enemy/enemy.tscn")
const npc_scene = preload("res://scenes/entities/npc/npc.tscn")

const player_starting_pos: Vector2 = Vector2(0, 0)
const enemy_starting_pos: Vector2 = Vector2(-200, -320)
const npc_starting_pos: Vector2 = Vector2(200, -120)

func _ready() -> void:
	spawn_sprite(player_starting_pos, player_scene)
	spawn_sprite(enemy_starting_pos, enemy_scene)
	spawn_sprite(npc_starting_pos, npc_scene)
	
func spawn_sprite(pos: Vector2, sprite: PackedScene) -> void:
	print("Spawning %s at: %s" % [sprite, pos])
	var new_sprite = sprite.instantiate()
	new_sprite.position = pos
	add_child(new_sprite)
