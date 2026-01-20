extends CharacterBody2D

@export_category("Stats")
@export var speed: int = 400 # movement speed of the player

var move_direction: Vector2 = Vector2.ZERO # direction the player is moving

func _physics_process(_delta: float) -> void: # called every physics frame
	movement_loop() # handle player movement

func movement_loop() -> void: # handles player movement input and movement
	move_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")) # get horizontal input
	move_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up")) # get vertical input

	var motion: Vector2 = move_direction.normalized() * speed # calculate motion vector
	set_velocity(motion) # set the player's velocity
	move_and_slide() # move the player based on velocity
