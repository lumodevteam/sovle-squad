extends Area2D

@onready var line: Sprite2D = get_parent()

func _on_body_entered(body: Node2D) -> void:
	line.number_snapped.emit(body, self)
