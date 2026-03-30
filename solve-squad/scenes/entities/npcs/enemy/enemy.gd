extends Node2D

@onready var raycast: RayCast2D = $PlayerRayCast

var identifier: String

var dialogue: Dictionary = {
	"start" : {
		"text" : ["You already beat me!", "Go find other enemies to beat!"],
		"options" : []
	}
}

var player_in_range: Node2D = null # whether the player is in range or not
var defeated: bool = false:
	set(value):
		defeated = value
		if defeated:
			_on_defeated()
			
func _on_defeated() -> void:
	raycast.enabled = false

var atk: int # which attack the npc will use

@export_category("Stats")
@export var health: int = 100 # enemy health
@export var lvl: int = 1 # enemy lvl
@export var dmg: int = randi() % 10 + 1 # enemy damage
@export var def: int = 0 # how much defense the player has

var moves: Dictionary = {
	1: {"name" : "basic attack",
	"spd" : randi() % 10 + 1,
	"dmg" : dmg / 2}
}

func _ready() -> void:
	Battle.setup_battle.connect(_on_setup_battle)
	Battle.end_battle.connect(_on_end_battle)

func _physics_process(_delta: float) -> void:
	if raycast.is_colliding() and not Battle.battling:
		collision(raycast.get_collider())
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player_in_range:
		player_in_range = null
		
func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact") and defeated:
		interact()
		
func interact() -> void:
	Gui.dialogue_started.emit(dialogue)

func collision(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = body
		Battle.start_battle.emit(player_in_range, self)
	
func attack() -> Dictionary:
	atk = 1
	return moves[atk]
	
func _on_setup_battle() -> void:
	$Sprite2D.flip_h = true
	raycast.enabled = false
	
func _on_end_battle(_player_won) -> void:
	$Sprite2D.flip_h = false
