extends Node

var player_in_range: Node2D = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("player is in range")
		player_in_range = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player_in_range:
		player_in_range = null
		
func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		interact()
		
func interact() -> void:
	print("hello")
