extends Node

var player_in_range: Node2D = null # whether the player is in range or not

@export_category("Stats")
@export var health: int = 100 # enemy health
@export var lvl: int = 1 # enemy lvl
@export var dmg: int = randi() % 10 + 1 # enemy damage
@export var atk_speed: int = randi() % 10 + 1 # how fast the enemy attacks

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = body
		interact()
		
func interact() -> void:
	print("battling")
	battle.battle(player_in_range, self)
	
