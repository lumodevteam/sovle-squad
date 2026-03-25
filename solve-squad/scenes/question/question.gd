extends Control
@onready var question_area: Label = $"Question Area"
@onready var option_area: ItemList = $"Option Area"

var questions = {}
var current_answer: int = 0

func _ready():
	generate_questions()
	show_question()
	print(questions)

func show_question():
	var algebra = questions["Algebra"]
	var entry = algebra[randi() % algebra.size()]
	question_area.text = entry["question"]

func answered_question():
	var _wrong_answers = []
	current_answer = questions["answer"]
	
	

func generate_questions():
	questions["Numbers"] = generate_number_questions(10)
	questions["Algebra"] = generate_algebra_questions()

# Numbers

func generate_number_questions(count: int) -> Array:
	var result = []
	for i in count:
		var a = randi_range(15, 100)
		var b = randi_range(15, 100)
		result.append({"question": "%d + %d" % [a, b], "answer": a + b})
	return result

#Algebra

func generate_algebra_questions() -> Array:
	var result = []

	# Solve for x addition
	for i in 4:
		var x = randi_range(20, 100)
		var b = randi_range(20, 100)
		result.append({
			"question": "Solve for x.\nx + %d = %d" % [b, x + b],
			"answer": x
		})
	#Solve for x subtraction
	for i in 4:
		var x = randi_range(20, 100)
		var b = randi_range(1, x)
		result.append({
			"question": "Solve for x.\nx - %d = %d" % [b, x - b],
			"answer": x
		})

	# Solve for x multiplication
	for i in 4:
		var a = randi_range(2, 9)
		var x = randi_range(2, 12)
		result.append({
			"question": "Solve for x.\n%dx = %d" % [a, a * x],
			"answer": x
		})

	# Solve for x divisiton
	for i in 4:
		var answer = randi_range(2, 12)   # this is x
		var divisor = randi_range(2, 9)
		var dividend = answer * divisor   # this is to guarentee a whole number
		result.append({
			"question": "Solve for x.\nx ÷ %d = %d" % [divisor, answer],
			"answer": dividend
		})

	# Solve for x 2 - step
	for i in 4:
		var a = randi_range(2, 6)
		var x = randi_range(15, 100)
		var b = randi_range(15, 100)
		result.append({
			"question": "Solve for x.\n%dx + %d = %d" % [a, b, a * x + b],
			"answer": x
		})

	# Solve for x 2 - step
	for i in 4:
		var a = randi_range(2, 6)
		var x = randi_range(3, 12)
		var b = randi_range(1, a * x - 1)
		result.append({
			"question": "Solve for x.\n%dx - %d = %d" % [a, b, a * x - b],
			"answer": x
		})

	#Formula questions 

	# x + y = z find z
	for i in 3:
		var x = randi_range(1, 100)
		var y = randi_range(1, 50)
		result.append({
			"question": "Using this formula x + y = z\nGiven x = %d and y = %d. What is z?" % [x, y],
			"answer": x + y
		})

	# x + y = z find x
	for i in 3:
		var x = randi_range(1, 50)
		var y = randi_range(1, 100)
		result.append({
			"question": "Using this formula x + y = z\nGiven y = %d and z = %d. What is x?" % [y, x + y],
			"answer": x
		})

	# m - n = p find p
	for i in 3:
		var m = randi_range(10, 100)
		var n = randi_range(1, m)
		result.append({
			"question": "Using this formula m - n = p\nGiven m = %d and n = %d. What is p?" % [m, n],
			"answer": m - n
		})

	# m - n = p find m
	for i in 3:
		var n = randi_range(1, 100)
		var p = randi_range(1, 100)
		result.append({
			"question": "Using this formula m - n = p\nGiven n = %d and p = %d. What is m?" % [n, p],
			"answer": n + p
		})

	# a x b = c find c
	for i in 3:
		var a = randi_range(2, 12)
		var b = randi_range(2, 12)
		result.append({
			"question": "Using this formula a × b = c\nGiven a = %d and b = %d. What is c?" % [a, b],
			"answer": a * b
		})

	# a x b = c find b
	for i in 3:
		var b = randi_range(2, 12)        # answer
		var a = randi_range(2, 9)
		var c = a * b                     # guaranteed whole
		result.append({
			"question": "Using this formula a × b = c\nGiven c = %d and a = %d. What is b?" % [c, a],
			"answer": b
		})

	# q ÷ r = s find s
	for i in 3:
		var s = randi_range(2, 12)        # answer
		var r = randi_range(2, 9)
		var q = s * r                     # guaranteed whole
		result.append({
			"question": "Using this formula q ÷ r = s\nGiven q = %d and r = %d. What is s?" % [q, r],
			"answer": s
		})

	# q ÷ r = s find q
	for i in 3:
		var s = randi_range(2, 12)
		var r = randi_range(2, 9)
		var q = s * r
		result.append({
			"question": "Using this formula q ÷ r = s\nGiven s = %d and r = %d. What is q?" % [s, r],
			"answer": q
		})

	# x + y + z = w find w
	for i in 3:
		var x = randi_range(1, 50)
		var y = randi_range(1, 50)
		var z = randi_range(1, 50)
		result.append({
			"question": "Using this formula x + y + z = w\nGiven x = %d, y = %d and z = %d. What is w?" % [x, y, z],
			"answer": x + y + z
		})

	# m - n + p = q find q
	for i in 3:
		var m = randi_range(10, 30)
		var n = randi_range(1, m)
		var p = randi_range(1, 50)
		result.append({
			"question": "Using this formula m - n + p = q\nGiven m = %d, n = %d and p = %d. What is q?" % [m, n, p],
			"answer": m - n + p
		})

	#BEDMAS

	# a × b ÷ c = d find d
	for i in 3:
		var divisor = randi_range(2, 6)
		var quotient = randi_range(2, 10)
		var factor = randi_range(2, 6)
		var product = quotient * divisor  # To get a whole number
		result.append({
			"question": "Using this formula a × b ÷ c = d\nGiven a = %d, b = %d and c = %d. What is d?" % [factor, product, divisor],
			"answer": factor * quotient
		})

	# x + y - z = w find w
	for i in 3:
		var x = randi_range(5, 50)
		var y = randi_range(1, 50)
		var z = randi_range(5, x + y)
		result.append({
			"question": "Using this formula x + y - z = w\nGiven x = %d, y = %d and z = %d. What is w?" % [x, y, z],
			"answer": x + y - z
		})

	# p × q + r = s find s
	for i in 3:
		var p = randi_range(2, 8)
		var q = randi_range(2, 8)
		var r = randi_range(1, 50)
		result.append({
			"question": "Using this formula p × q + r = s\nGiven p = %d, q = %d and r = %d. What is s?" % [p, q, r],
			"answer": p * q + r
		})

	# m ÷ n + o = p find p
	for i in 3:
		var quotient = randi_range(2, 12)  # m ÷ n
		var n = randi_range(2, 9)
		var m = quotient * n               # guaranteed whole
		var o = randi_range(1, 10)
		result.append({
			"question": "Using this formula m ÷ n + o = p\nGiven m = %d, n = %d and o = %d. What is p?" % [m, n, o],
			"answer": quotient + o
		})

	# x × y - z ÷ w = v find v
	for i in 3:
		var x = randi_range(2, 8)
		var y = randi_range(2, 8)
		var w = randi_range(2, 6)
		var zdivw = randi_range(1, 10)    # z ÷ w result
		var z = zdivw * w                 # guaranteed whole
		result.append({
			"question": "Using this formula x × y - z ÷ w = v\nGiven x = %d, y = %d, z = %d and w = %d. What is v?" % [x, y, z, w],
			"answer": x * y - zdivw
		})

	return result


func _on_option_area_item_selected(index: int) -> void:
	pass # Replace with function body.
