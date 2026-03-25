extends Sprite2D

@onready var area: Area2D = $Area2D

enum State { #different parts of line and numbers
	middle,
	right,
	left,
}

func _ready() -> void:
	print(area.global_position)

func change_state(state) -> void:
	self.set_frame(state)

#@onready var originSprite = self
#
#
#func _ready() -> void:
	#if self != originSprite:
		#return
	#else:
		#var clone = originSprite.duplicate()
		#add_child(clone)
		#clone.position = Vector2(32, 0) # sets location of next part of number line number line
		#clone.scale = Vector2(1, 1)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_parent().name == "number":
		NumberLine.body_entered.emit(area.global_position, body.get_parent().get_parent().id)
