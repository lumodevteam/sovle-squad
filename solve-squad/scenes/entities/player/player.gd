extends CharacterBody2D

enum State { # player states
	IDLE,
	IDLE_AWAY,
	IDLE_TOWARD,
	WALK,
	WALK_AWAY,
	WALK_TOWARD,
	ATTACK,
	DEAD
}

@export_category("Stats")
@export var speed: int = 150 # base movement speed of the player
@export var sprint_speed: int = 200 # sprint speed of the player
@export var current_speed: int # speed of the player
@export var max_health: int = 100 # max health of the player
@export var health: int = 100 # health of the player
@export var lvl: int = 1 # lvl of the player
@warning_ignore("shadowed_global_identifier")
@export var exp: int = 0
@export var dmg: int = 60 # dmg of the player
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
	},
	4: {
		"name" : "back",
	}
}

var state: State = State.IDLE # current state of the player
var move_direction: Vector2 = Vector2.ZERO # direction the player is moving
var facing: String = "right" # what direction the player is facing
var atk: int # what attack will the player use

var identifier: String

var in_conversation: bool = false
var level_up_text: String = "Level up! Player leveled up to lvl "

@onready var animation_tree: AnimationTree = $AnimationTree # reference to the AnimationTree node
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"] # reference to the state machine playback
@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	Battle.setup_battle.connect(_on_setup_battle)
	Battle.end_battle.connect(_on_end_battle)
	Battle.gain_exp.connect(_on_gain_exp)
	Gui.dialogue_started.connect(_on_dialogue_started)
	Gui.conversation_over.connect(_on_conversation_over)

func exp_gained() -> void:
	if exp >= 100:
		lvl += floor(float(exp) / 100)
		exp %= 100
		update_stats()
		
func update_stats() -> void:
	max_health += 10
	dmg += 10
	def += 0.05
	
func _on_setup_battle() -> void:
	animation_tree.active = false
	$Sprite2D.frame = 0
	$Sprite2D.flip_h = false
	
func _on_end_battle(player_won) -> void:
	animation_tree.active = true
	if player_won:
		health = max_health
	
func _on_gain_exp(enemy_lvl) -> void:
	if enemy_lvl == lvl:
		exp += 40 + randi() % 20
	elif enemy_lvl > lvl:
		exp += (50 + randi() % 30) * (enemy_lvl - lvl)
	else:
		exp += (35 + randi() % 10) / (lvl - enemy_lvl)
	exp_gained()

func _physics_process(_delta: float) -> void: # called every physics frame
	if not Battle.battling and not in_conversation:
		movement_loop() # handle player movement
		

func movement_loop() -> void: # handles player movement input and movement
	move_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")) # get horizontal input
	move_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up")) # get vertical input
	
	if Input.is_action_pressed("sprint"):
		current_speed = sprint_speed
	else:
		current_speed = speed
	
	var motion: Vector2 = move_direction.normalized() * current_speed # calculate motion vector
	set_velocity(motion) # set the player's velocity
	move_and_slide() # move the player based on velocity
	
	if move_direction.x != 0:
		state = State.WALK
		if move_direction.x < 0:
			$Sprite2D.flip_h = true
			facing = "left"
		elif move_direction.x > 0:
			$Sprite2D.flip_h = false
			facing = "right"
		update_animation()
	elif move_direction.y != 0:
		if move_direction.y > 0:
			state = State.WALK_TOWARD
			facing = "toward"
		elif move_direction.y < 0:
			state = State.WALK_AWAY
			facing = "away"
		update_animation()
	else:
		if facing == "toward":
			state = State.IDLE_TOWARD
		elif facing == "away":
			state = State.IDLE_AWAY
		else:
			state = State.IDLE
		update_animation()

func update_animation() -> void: # updates the animation based on the current state
	match state:
		State.IDLE:
			animation_playback.travel("idle")
		State.IDLE_AWAY:
			animation_playback.travel("idle_away")
		State.IDLE_TOWARD:
			animation_playback.travel("idle_toward")
		State.WALK:	
			animation_playback.travel("walk")
		State.WALK_AWAY:	
			animation_playback.travel("walk_away")
		State.WALK_TOWARD:	
			animation_playback.travel("walk_toward")
		State.ATTACK:
			animation_playback.travel("attack")
		State.DEAD:
			animation_playback.travel("dead")
	
func _on_dialogue_started(_dialogue_tree):
	in_conversation = true
	if facing == "left":
		$Sprite2D.flip_h = true
		state = State.IDLE
	elif facing == "right":
		$Sprite2D.flip_h = false
		state = State.IDLE
	elif facing == "away":
		state = State.IDLE_AWAY
	elif facing == "toward":
		state = State.IDLE_TOWARD
	update_animation()
	
func _on_conversation_over() -> void:
	in_conversation = false
	
