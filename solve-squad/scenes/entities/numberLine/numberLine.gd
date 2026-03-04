extends Sprite2D
enum State { #different parts of line and numbers
	middle,
	right,
	left,
}


func change_state(state) -> void:
	$sprite.set_frame(state)

@onready var originSprite = $sprite

func ready() -> void:
	var clone = originSprite.duplicate()
	add_child(clone)
	clone.position = Vector2(32,0) # sets location of next part of number line number line
