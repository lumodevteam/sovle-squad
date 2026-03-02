extends Node

var player_in_range: Node2D = null # whether the player is in range or not
var move_direction: Vector2 = Vector2.ZERO # direction the enemy is moving

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		interact()
		
func interact() -> void:
	print("bye")
	
