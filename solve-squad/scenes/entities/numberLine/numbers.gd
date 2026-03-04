extends Sprite2D
var isDragging = false # state management
var mouseOffset #center's the mouse on click
var delay = 15
enum State { #different parts of line and numbers
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
	point,
}

func change_state(state) -> void:
	$sprite.set_frame(state)

@onready var originSprite = $sprite

func _physics_process(delta):
	if isDragging == true:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", get_global_mouse_position(), delay * delta)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if get_rect().has_point(to_local(event.position)):
				print('clicked')
				isDragging = true
		else:
			isDragging = false
"""
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			
"""
