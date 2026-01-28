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

var moving = [State.WALK, State.WALK_AWAY, State.WALK_TOWARD]

@export_category("Stats")
@export var speed: int = 400 # movement speed of the player

var state: State = State.IDLE # current state of the player
var move_direction: Vector2 = Vector2.ZERO # direction the player is moving

@onready var animation_tree: AnimationTree = $AnimationTree # reference to the AnimationTree node
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"] # reference to the state machine playback

func _physics_process(_delta: float) -> void: # called every physics frame
	movement_loop() # handle player movement

func movement_loop() -> void: # handles player movement input and movement
	move_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")) # get horizontal input
	move_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up")) # get vertical input

	var motion: Vector2 = move_direction.normalized() * speed # calculate motion vector
	set_velocity(motion) # set the player's velocity
	move_and_slide() # move the player based on velocity
	
	
	if state == State.WALK or state == State.IDLE:
		if motion.x > 0.01:
			$Sprite2D.flip_h = false
		elif motion.x < -0.01:
			$Sprite2D.flip_h = true
	
	if motion.x != 0 and state not in moving:
		state = State.WALK
		update_animation()
	elif motion.y != 0 and state not in moving:
		if move_direction.y > 0.01:
			state = State.WALK_AWAY
		elif move_direction.y < -0.01:
			state = State.WALK_TOWARD
		update_animation()
	elif motion == Vector2.ZERO and state in moving:
		if state == State.WALK:
			state = State.IDLE
		elif state == State.WALK_AWAY:
			state = State.IDLE_AWAY
		elif state == State.WALK_TOWARD:
			state = State.IDLE_TOWARD
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
