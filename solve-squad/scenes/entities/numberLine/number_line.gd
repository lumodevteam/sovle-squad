extends Node2D

const line_scene = preload("res://scenes/entities/numberLine/line.tscn")
const number_scene = preload("res://scenes/entities/numberLine/number.tscn")

var starting_index: int = 0
var identifier: String

var numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

func _ready() -> void:
	randomize()
	numbers.shuffle()

func create_number_line(starting_pos: Vector2) -> void:
	var line1 = line_scene.instantiate()
	line1.position = Vector2(8*32, 0)
	starting_index = line1.map_slots(starting_index, line1.position + starting_pos)
	add_child(line1)
	var line2 = line_scene.instantiate()
	line2.position = Vector2(8*32*2, 0)
	starting_index = line2.map_slots(starting_index, line2.position + starting_pos)
	add_child(line2)
	var line3 = line_scene.instantiate()
	line3.position = Vector2(8*32*3, 0)
	starting_index = line3.map_slots(starting_index, line3.position + starting_pos)
	add_child(line3)
	
	
	for i in range(10):
		var num = number_scene.instantiate()
		var state = numbers[i]
		num.change_state(state)
		num.position = Vector2(32*2*i, 125)
		num.id = state
		add_child(num)
