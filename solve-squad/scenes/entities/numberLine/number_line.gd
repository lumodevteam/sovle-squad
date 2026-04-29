extends Node2D

const line_scene = preload("res://scenes/entities/numberLine/line.tscn")
const number_scene = preload("res://scenes/entities/numberLine/number.tscn")

var starting_index: int = 0
var identifier: String

var numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

func _ready() -> void:
	randomize()
	numbers.shuffle()

func create_number_line(pos: Vector2) -> void:
	for i in range(3):
		pos = create_line(i, pos)
	for i in range(10):
		var num = number_scene.instantiate()
		var state = numbers[i]
		num.change_state(state)
		num.position = Vector2(32*2*i + 32*5, 125)
		num.id = state
		add_child(num)
		
func create_line(num: int, pos: Vector2) -> Vector2:
	var line = line_scene.instantiate()
	line.position = Vector2(8*32*num, 0)
	starting_index = line.map_slots(starting_index, line.position + pos)
	add_child(line)
	var new_pos_x = pos.x + line.position.x
	pos.x = new_pos_x
	return pos
