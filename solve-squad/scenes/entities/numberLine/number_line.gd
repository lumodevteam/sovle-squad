extends Node2D

signal body_entered(body_position: Vector2, id: int)

const line_scene = preload("res://scenes/entities/numberLine/line.tscn")
const number_scene = preload("res://scenes/entities/numberLine/number.tscn")

func _ready() -> void:
	create_number_line()

func create_number_line() -> void:
	var line = line_scene.instantiate()
	line.position = Vector2(8*32, 100)
	add_child(line)
	var line2 = line_scene.instantiate()
	line2.position = Vector2(8*2*32, 100)
	add_child(line2)
	var line3 = line_scene.instantiate()
	line3.position = Vector2(8*32*3, 100)
	add_child(line3)
	for i in range(10):
		var num_1 = number_scene.instantiate()
		num_1.change_state(i)
		num_1.position = Vector2(32*8*i + 32*8, 150)
		num_1.id = i
		add_child(num_1)
