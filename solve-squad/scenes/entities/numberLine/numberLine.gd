extends Sprite2D
enum State { #different parts of line and numbers
	middle,
	right,
	left,
}

func change_state(state) -> void:
	self.set_frame(state)

@onready var originSprite = self


func _input(event) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		var clone = originSprite.duplicate()
		add_child(clone)
		clone.position = Vector2(32, 0) # sets location of next part of number line number line
		clone.scale = Vector2(1, 1)
 
