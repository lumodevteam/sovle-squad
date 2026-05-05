extends Node2D

@onready var raycast: RayCast2D = $PlayerRayCast

var identifier: String
var is_interacting: bool = false

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
@export var dmg: int = 40 # enemy damage
@export var def: float = 0.0 # how much defense the player has

@warning_ignore("integer_division")
var moves: Dictionary = {
	1: {
		"name" : "basic attack",
		"dmg" : (dmg / 3) * lvl
	},
	2: {
		"name" : "less basic attack",
		"dmg" : (dmg / 2) * lvl
	},
	3: {
		"name" : "even less basic attack",
		"dmg" : dmg * lvl
	}
}

func _ready() -> void:
	lvl = GlobalSprites.sprites["player"]["sprite"].lvl + randi_range(-2, 2)
	Battle.setup_battle.connect(_on_setup_battle)
	Battle.end_battle.connect(_on_end_battle)
	Gui.conversation_over.connect(_on_conversation_over)
	
func update_stats() -> void:
	dmg = (randi() % 20) * lvl + 20
	health = (randi() % 20) * lvl + 100
	def = randf_range(0.01, 0.10) + 0.05 * lvl

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
	if player_in_range != null and event.is_action_pressed("interact") and defeated and not is_interacting:
		interact()
		
func interact() -> void:
	is_interacting = true
	Gui.dialogue_started.emit(dialogue)
	
func _on_conversation_over(_node_key) -> void:
	is_interacting = false

func collision(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = body
		Battle.start_battle.emit(player_in_range, self)
	
func attack() -> Dictionary:
	atk = randi() % (moves.size() - 1) + 1
	return moves[atk]
	
func _on_setup_battle() -> void:
	update_stats()
	$Sprite2D.flip_h = true
	raycast.enabled = false
	
func _on_end_battle(_player_won) -> void:
	$Sprite2D.flip_h = false
	if not defeated:
		raycast.enabled = true
