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
@export var health: int = 100 # health of the player
@export var lvl: int = 1 # lvl of the player
@export var dmg: int = 10 # dmg of the player
@export var atk_spd: int = 5 # how fast the player attacks
@export var def: int = 0 # how much defense the player has

var state: State = State.IDLE # current state of the player
var move_direction: Vector2 = Vector2.ZERO # direction the player is moving
var facing: String = "right" # what direction the player is facing

@onready var animation_tree: AnimationTree = $AnimationTree # reference to the AnimationTree node
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"] # reference to the state machine playback

func _physics_process(_delta: float) -> void: # called every physics frame
	if not battle.battling:
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
			
func attack() -> void: # player is attacking enemy
	pass
