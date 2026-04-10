extends Node

signal body_entered(body_position: Vector2, id: int)
signal all_correct

var occupied_slots: Dictionary = {}

var slot_mapping: Dictionary = {}
var total: int = 10
var _correct: int = 0
var correct: int: #amount of slots correct
	set(value):
		_correct = value
		if _correct == total:
			all_correct.emit()
	get:
		return _correct
		
var complete: bool = false # checks if all inputs are correct

func try_occupy(snap_pos: Vector2, node: Node2D) -> bool:
	if occupied_slots.has(snap_pos):
		return false  # already taken
	occupied_slots[snap_pos] = node
	return true
	
func release(snap_pos: Vector2, node):
	if occupied_slots.get(snap_pos) == node:
		occupied_slots.erase(snap_pos)

func is_occupied(snap_pos: Vector2) -> bool:
	return occupied_slots.has(snap_pos)
	
func num_in_right_place(snap_pos: Vector2) -> bool:
	return occupied_slots[snap_pos].id == slot_mapping[snap_pos]
	
