extends Node2D

@onready var raycast: RayCast2D = $PlayerRayCast

var player_in_range: Node2D = null # whether the player is in range or not
var defeated: bool = false
var atk: int # which attack the npc will use

@export_category("Stats")
@export var health: int = 100 # enemy health
@export var lvl: int = 1 # enemy lvl
@export var dmg: int = randi() % 10 + 1 # enemy damage

var moves: Dictionary = {
	1: {"name" : "basic attack",
	"spd" : randi() % 10 + 1,
	"dmg" : dmg / 2}
}

func _physics_process(_delta: float) -> void:
	if raycast.is_colliding():
		if defeated:
			print("you already beat me!")
		else:
			collision(raycast.get_collider())
	if battle.battling:
		$Sprite2D.flip_h = true
		raycast.enabled = false

func collision(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = body
		interact()
		
func interact() -> void:
	print("battling")
	battle.battle(player_in_range, self)
	
func attack() -> int:
	atk = 1
	print(moves[atk]["name"])
	return moves[atk]["dmg"]
	
