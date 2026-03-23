extends Node2D

var isDragging = false # state management
var mouseOffset #center's the mouse on click
var delay = 15

@export var animated_sprite: AnimatedSprite2D
@export var sprite: Sprite2D

var id: int

func _ready() -> void:
	NumberLine.body_entered.connect(_on_body_entered)
	
func _on_body_entered(body_position: Vector2, id: int) -> void:
	if self.id == id and isDragging == false:
		animated_sprite.selected = false
		sprite.position = body_position

func change_state(state: int) -> void:
	animated_sprite.frame = state

func _physics_process(delta):
	if isDragging == true:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", get_global_mouse_position(), delay * delta)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if sprite.get_rect().has_point(to_local(event.position)):
				print('clicked')
				isDragging = true
				animated_sprite.selected = true
			else:
				animated_sprite.selected = false
		else:
			isDragging = false
