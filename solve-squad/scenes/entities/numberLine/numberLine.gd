extends Sprite2D

signal number_snapped(body: Node2D)

enum State { #different parts of line and numbers
	middle,
	right,
	left,
}

func _ready() -> void:
	number_snapped.connect(_on_number_snapped)
	

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


func _on_number_snapped(body: Node2D, area: Area2D) -> void:
	if body.get_parent().name == "number":
		SnapManager.body_entered.emit(area.global_position, body.get_parent().get_parent().id)
		
func map_slots(starting_index: int) -> int:
	SnapManager.slot_mapping[$Area2D1.global_position] = starting_index
	SnapManager.slot_mapping[$Area2D2.global_position] = starting_index + 1
	SnapManager.slot_mapping[$Area2D3.global_position] = starting_index + 2
	SnapManager.slot_mapping[$Area2D4.global_position] = starting_index + 3
	
	return starting_index + 4
