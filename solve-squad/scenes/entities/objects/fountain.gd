extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $FountainNode/animationFountain

var is_interacting: bool = false
var player_in_range: Node2D = null
var identifier: String

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player_in_range:
		player_in_range = null
		
func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact") and not is_interacting:
		is_interacting = true
		TutorialEvents.interWell.emit()
		animated_sprite.play("fountain_water")
		await animated_sprite.animation_finished
		is_interacting = false
