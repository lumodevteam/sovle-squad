extends Sprite2D

enum State { #different parts of line and numbers
	middle,
	right,
	left,
}

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
	print("tets")
	print(body.get_parent().name)
	if body.get_parent().name == "number":
		print("buttercup")
		NumberLine.body_entered.emit(self.position, body.get_parent().get_parent().id)
