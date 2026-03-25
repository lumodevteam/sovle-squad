extends Node2D

var isDragging = false # state management
var mouseOffset #center's the mouse on click
var delay = 0

@export var animated_sprite: AnimatedSprite2D
@export var sprite: Sprite2D
@export var clickable_area: CollisionShape2D

var id: int

var mouse_in_clickable_area: bool = false

func _ready() -> void:
	NumberLine.body_entered.connect(_on_body_entered)
	
func _on_body_entered(body_position: Vector2, id: int) -> void:
	if self.id == id:
		isDragging = false
		animated_sprite.selected = false
		self.global_position = body_position

func change_state(state: int) -> void:
	animated_sprite.frame = state

func _physics_process(delta):
	if isDragging:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", get_global_mouse_position(), delay * delta)
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if mouse_in_clickable_area:
				isDragging = true
				animated_sprite.selected = true
			else:
				animated_sprite.selected = false
		else:
			isDragging = false
	
func _on_character_body_2d_mouse_entered() -> void:
	mouse_in_clickable_area = true
	
func _on_character_body_2d_mouse_exited() -> void:
	mouse_in_clickable_area = false
