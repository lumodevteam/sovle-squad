extends AnimatedSprite2D
var selected = false
func _input(event):
	if selected:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			if frame == 9:
				frame = 0
			else:
				frame += 1
