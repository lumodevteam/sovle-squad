extends Sprite2D
var isDragging = false # state management
var mouseOffset #center's the mouse on click
var delay = 15

func change_state(state) -> void:
	self.set_frame(state)

@onready var originSprite = self

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
