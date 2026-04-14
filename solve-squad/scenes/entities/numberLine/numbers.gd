extends Node2D

var isDragging = false
var mouseOffset
var delay = 10
@export var animated_sprite: AnimatedSprite2D
@export var sprite: Sprite2D
@export var clickable_area: CollisionShape2D
var id: int
var mouse_in_clickable_area: bool = false
var body_position: Vector2
var snapping: bool = false
var current_snap: Vector2 = Vector2.INF
var tween: Tween  # store tween so we can kill it before making a new one
var in_right_position: bool = false

func _ready() -> void:
	SnapManager.body_entered.connect(_on_body_entered)
	SnapManager.all_correct.connect(_on_all_correct)
	
func _on_all_correct() -> void:
	Tutorial.quest_completed.emit()

func _on_body_entered(body_position: Vector2, id: int) -> void:
	if self.id == id:
		if not SnapManager.is_occupied(body_position) or SnapManager.occupied_slots[body_position] == self:
			# Release old snap slot, claim new one
			if current_snap != Vector2.INF:
				SnapManager.release(current_snap, self)
			SnapManager.try_occupy(body_position, self)
			current_snap = body_position

			isDragging = false
			self.body_position = body_position
			snapping = true
			in_right_position = SnapManager.num_in_right_place(body_position)
			if in_right_position:
				SnapManager.correct += 1

func change_state(state: int) -> void:
	animated_sprite.frame = state

func _physics_process(delta):
	if isDragging:
		position = position.lerp(get_global_mouse_position(), delta * delay)
	elif snapping:
		position = body_position
		snapping = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if mouse_in_clickable_area:
				snapping = false
				isDragging = true
				# Release snap slot when picked up
				if current_snap != Vector2.INF:
					SnapManager.release(current_snap, self)
					current_snap = Vector2.INF
					if in_right_position:
						in_right_position = false
						SnapManager.correct -= 1
				get_viewport().set_input_as_handled()
		else:
			isDragging = false

func _on_character_body_2d_mouse_entered() -> void:
	mouse_in_clickable_area = true

func _on_character_body_2d_mouse_exited() -> void:
	mouse_in_clickable_area = false
