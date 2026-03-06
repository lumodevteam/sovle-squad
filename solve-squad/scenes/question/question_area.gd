extends Label

@onready var question_area: Label = self

var question_list = [[1,2,3,4,5,6],[1,2,3,4,5,6],[1,2,3,4,5,6],[1,2,3,4,5,6],[1,2,3,4,5,6]]
var rng = RandomNumberGenerator.new()
var strand = question_list[rng.randi_range(0,question_list.size() - 1)]
var question = strand[rng.randi_range(0,strand.size() - 1)]

func _ready():
	print(strand)
	print(question)
	question_area.text = str(strand[question])

func randomstrand():
	strand = rng.randi_range(1,question_list.size())

#func randomquestion():
	#question = rng.randi_range(1,(strand.size()))
#func _on_line_edit_text_submitted(new_text: String) -> void:
	#print(new_text)
