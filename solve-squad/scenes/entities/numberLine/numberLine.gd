extends Node

enum State { #different parts of line and numbers
	middle,
	right,
	left,
	numOne,
	numTwo,
	numThree,
	numFour,
	numFive,
	numSix,
	numSeven,
	numEight,
	numNine,
	numZero,
}

func change_state(state) -> void:
	$sprite.set_frame(state)

@onready var originSprite = $sprite

func ready() -> void:
	var clone = originSprite.duplicate()
	add_child(clone)
	clone.position = Vector2(32,0) # sets location of number line
