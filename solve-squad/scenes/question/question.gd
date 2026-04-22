extends Control
@onready var question_area: Label = $"Question Area"
@onready var option_area: ItemList = $"Option Area"
@onready var bar_graph: Control = $"Panel/BarGraph"
@onready var bar_container: HBoxContainer = $"Panel/BarGraph/HBoxContainer" 
@onready var slider_label: Label = $Panel/BarGraph/SliderLabel
@onready var submit_button: Button = $Panel/BarGraph/SubmitButton
@onready var v_slider: VSlider = $Panel/BarGraph/VSlider
@onready var grid_container: GridContainer = $Panel/GridContainer




var questions = {}
var current_strand = ""
var current_answer: int = 0
var max_height = 200
var is_bar_question = false
var current_bar_data = {}

func _ready():
	option_area.select_mode = ItemList.SELECT_SINGLE
	option_area.item_selected.connect(_on_option_area_item_selected)
	v_slider.min_value = 0
	v_slider.max_value = 100
	v_slider.step = 1
	v_slider.value = 50
	v_slider.value_changed.connect(_on_slider_changed)
	submit_button.pressed.connect(_on_submit_pressed)
	generate_questions()
	set_strand("Data")
	show_question()

	print(questions)

func set_strand(strand: String):
	current_strand = strand

func show_question():
	var strand = questions[current_strand]
	var entry = strand[randi() % strand.size()]
	#var algebra = questions["Algebra"]
	#var entry = algebra[randi() % algebra.size()]
	question_area.text = entry["question"]
	current_answer = entry["answer"]
	
	if entry.has("bar_data"):
		bar_graph.visible = true
		draw_bars(entry["bar_data"], int(v_slider.value))
		
		option_area.visible = false
		current_bar_data = entry["bar_data"]
		v_slider.value = 50
		slider_label.text = "50"
		slider_label.add_theme_color_override("font_color", Color())
		draw_bars(current_bar_data, int(v_slider.value))
		if entry.has("table_headers"):
			grid_container.visible = true
			draw_table(entry["table_headers"],entry["table_rows"])
	else:
		is_bar_question = false
		bar_graph.visible = false
		option_area.visible = true
		grid_container.visible = false
	answers(current_answer)
	
func draw_bars(data: Dictionary, slider_val:int):
	for child in bar_container.get_children():
		child.queue_free()
	var max_value = 0
	
	for i in data:
		if data[i] != null and data[i] > max_value:
			max_value = data[i]
	
	if current_answer > max_value:
		max_value = current_answer
	for j in data:
		var value = data[j]
		var column = VBoxContainer.new()
		column.custom_minimum_size = Vector2(60, 20)
		column.alignment = BoxContainer.ALIGNMENT_END
		
		if value == null:
			var bar_height = int((float(slider_val)/ float(max_value)) * max_height)
			var top_space = Control.new()
			var val_label = Label.new()
			var slider_bar = ColorRect.new()
			
			val_label.text = str(slider_val)
			val_label.add_theme_color_override("font_color", Color())
			val_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			column.add_child(val_label)
			
			top_space.custom_minimum_size = Vector2(0, bar_height)
			column.add_child(top_space)
			
			slider_bar.custom_minimum_size = Vector2(60, bar_height)
			slider_bar.color = Color(0.743, 0.002, 0.942, 0.8)
			column.add_child(slider_bar)
			
		else:
			var bar_height = int((float(value)/float(max_value))* max_height)
			
			var value_label = Label.new()
			value_label.text = str(value)
			value_label.add_theme_color_override("font_color", Color())
			value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			column.add_child(value_label)
			
			var spacer = Control.new()
			spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
			column.add_child(spacer)
			
			var bar = ColorRect.new()
			bar.custom_minimum_size = Vector2(60,bar_height)
			bar.color = Color(0.2,0,6,1.0)
			column.add_child(bar)
			
		var name_label = Label.new()
		name_label.text = j
		name_label.add_theme_color_override("font_color", Color())
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		column.add_child(name_label)
		bar_container.add_child(column)
func _on_slider_changed(value:float):
	slider_label.text = str(int(value))
	slider_label.add_theme_color_override("font_color", Color())
	draw_bars(current_bar_data, int(value))
	
func _on_submit_pressed():
	var player_guess = int(v_slider.value)
	if abs(player_guess - current_answer) == 0:
		question_area.text = "g"
	else:
		question_area.text = "n"
		
func draw_table(headers: Array, rows: Array):
	
	for child in grid_container.get_children():
		child.queue_free()
		
	grid_container.columns = headers.size()
	
	for header in headers:
		var header_label = Label.new()
		header_label.add_theme_color_override("font_color", Color.YELLOW)
		grid_container.add_child(header_label)
		
	for row in rows:
		for cell in row:
			var cell_label = Label.new()
			cell_label.text = str(cell)
			cell_label.add_theme_color_override("font_color", Color())
			grid_container.add_child(cell_label)
func answers(correct_answer: int):
	option_area.clear()
	
	var wrong_answers = []
	while wrong_answers.size() < 3:
		var wrong = correct_answer + randi_range(-15,15)
		if wrong != correct_answer and wrong not in wrong_answers:
			wrong_answers.append(wrong)
			
	var all_answers = wrong_answers
	all_answers.append(correct_answer)
	
	all_answers.shuffle()
	for answer in all_answers:
		option_area.add_item(str(answer))
		
func _on_option_area_item_selected(index: int) -> void:
	var selected_text = option_area.get_item_text(index)
	if int(selected_text) == current_answer:
		print("g")
	else:
		print("n")
func generate_questions():
	#questions["Algebra"] = generate_algebra_questions()
	questions["Data"] = generate_data_questions()
	'''
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
	
	for i in 4:
		var x = randi_range(20, 100)
		var b = randi_range(20, 100)
		result.append({
			"question": "Solve for x.\nx + %d = %d" % [x + b, b],
			"answer": b - (x+b)
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
	for i in 4:
		var multiplier = randi_range(2,5)
		
		var x = randi_range (2,5)
		var y = x * multiplier
		var z = y * multiplier
		var w = z * multiplier
		var v = w * multiplier
		
		result.append({
			"question": "What is the multiplier on the pattern given\n %d, %d, %d, %d, %d" % [x,y,z,w,v],
			"answer": multiplier
		})
	
	for i in 4:
		
		var addition = randi_range(-20,20)
		
		var x = randi_range(2,15)
		var y = x + addition
		var z = y + addition
		var w = z + addition
		var v = w + addition
		
		result.append({
			"question": "What is the pattern of the set of numbers given\n %d, %d, %d, %d, %d" %[x,y,z,w,v],
			"answer": addition
		})

	for i in 4:
		
		var subtraction = randi_range(-15,-2)
		
		var x = randi_range(2,80)
		var y = x + subtraction
		var z = y + subtraction
		var w = z + subtraction
		var v = w + subtraction
		
		result.append({
			"question": "What is the pattern of the set of numbers given\n %d, %d, %d, %d, %d" %[x,y,z,w,v],
			"answer": subtraction
		})
	for  i in 4:
		
		var division = randi_range(2,4)
		var x = randi_range(2,20)
		var y = x * division
		var z = y * division
		var w = z * division
		var v = w * division
		result.append({
			"question": "What is the divisor this set of numbers given\n %d, %d, %d, %d, %d" %[v,w,z,y,x],
			"answer": division
		})
		
	for i in 4:
		var multiplier = randi_range(2,5)
		
		var x = randi_range (2,5)
		var y = x * multiplier
		var z = y * multiplier
		var w = z * multiplier
		var v = w * multiplier
		
		result.append({
			"question": "What is the next term given\n %d, %d, %d, %d, %d" % [x,y,z,w,v],
			"answer": v * multiplier
		})
	
	for i in 4:
		
		var addition = randi_range(-20,20)
		
		var x = randi_range(2,15)
		var y = x + addition
		var z = y + addition
		var w = z + addition
		var v = w + addition
		
		result.append({
			"question": "What is the next term given\n %d, %d, %d, %d, %d" %[x,y,z,w,v],
			"answer": v + addition
		})

	for i in 4:
		
		var subtraction = randi_range(-15,-2)
		
		var x = randi_range(2,80)
		var y = x + subtraction
		var z = y + subtraction
		var w = z + subtraction
		var v = w + subtraction
		
		result.append({
			"question": "What is the next term given\n %d, %d, %d, %d, %d" %[x,y,z,w,v],
			"answer": v + subtraction
		})
	for  i in 4:
		
		var division = randi_range(2,4)
		var u = randi_range(2,20)
		var x = u * division
		var y = x * division
		var z = y * division
		var w = z * division
		var v = w * division
		result.append({
			"question": "What is the next term given\n %d, %d, %d, %d, %d" %[v,w,z,y,x],
			"answer": u
		})
	
	
	
	for i in 4:
		var y = randi_range(20,30)
		var z = randi_range(20,30)
		var v = randi_range(20,30)
		var x = z + v + y
		result.append({
			"question": "Evan went to the mall. He spent $%d on Hollister, $%d on food and $%d for a gift for Maria\n How much did Evan spend at the mall?" %[y,z,v,],
			"answer": x
	
		})

	for i in 4:
		var y = randi_range(20,30)
		var z = randi_range(20,30)
		var v = randi_range(20,30)
		var x = randi_range(100,150)
		
		var a = x - y - z - v
		result.append({
			"question": "Nih brought $%d to spend on groceries. He spends $%d on meats, \n$%d on vegetables and fruits and finally $%d on candy.\nHow much does he have left?" %[x,y,z,v],
			"answer": a
		})
		
	for i in 4:
		var y = randi_range(20,30)
		var v = randi_range(20,30)
		var x = randi_range(100,150)
		var z = x - y - v
		result.append({
			"question": "Dih went on a shopping haul she spent $%d. She had bought 3 things.\n She spent $%d on Jewlery, $%d on clothes the rest she spent on shoes.\n How much did she spend on shoes?" %[x,y,v],
			"answer": z
		})
	
	for i in 4:
		var total = randi_range(400,500)
		var x = randi_range(50,100)
		var y = randi_range(100,110)
		var z = randi_range(90,100)
		var a = total - (x + y + z)
		
		result.append({
			"question": "John Pork is driving all the way to British Colombia. It will take %d Km. The trip took 4 days, The first day he drove %d Km. The second he drove %d Km and the third day he drove %d Km.\nHow many kilometers did John Pork on the last day?" %[total,x,y,z],
			"answer": a
		})
	
	return result
'''
func generate_data_questions() -> Array:
	var result = []
	for i in 4:
		var labels = ["Mon", "Tue", "Wed", "Thu", "Fri"]
		var data = {}
		for label in labels:
			data[label] = randi_range(10, 100)
	
		var missing_key = labels[randi() % labels.size()]
		var missing_value = data[missing_key]
		data[missing_key] = null
	
		var table_rows = []
		for label in labels:
			if data[label] != null:
				table_rows.append([label, data[label]])
			else:
				table_rows.append([label, missing_value])
	
		result.append({
			"question": "Slide the bar to the correct height!",
			"answer": missing_value,
			"bar_data": data,
			"table_headers": ["Day", "Value"],
			"table_rows": table_rows })
	return result
'''
	
	for i in 4:
		var w = randi_range(20, 30)
		var v = randi_range(20,30)
		var x = randi_range(20,30)
		var y = randi_range(20,30)
		var z = randi_range(20,30)
		
		var total = w + v + x + y + z
		z -= total % 5 
	
		@warning_ignore("integer_division")
		result.append({
			"question":"Find the mean of the given set of numbers.\n(%d, %d, %d, %d, %d)" %[w,v,x,y,z],
			"answer": total / 5
		})
	
	for i in 4:
		
		var list = []
		
		var t = randi_range(20,30)
		list.append(t)
		
		var u = randi_range(20,30)
		list.append(u)
		
		var w = randi_range(20,30)
		list.append(w)
		
		var v = randi_range(20,30)
		list.append(v)
		
		var x = randi_range(20,30)
		list.append(x)
		
		var y = randi_range(20,30)
		list.append(y)
		
		var z = randi_range(20,30)
		list.append(z)
		
		list.sort()
		result.append({
			"question":"Find the median of the given set of numbers.\n(%d, %d, %d, %d, %d, %d, %d)" %[t,u,w,v,x,y,z],
			"answer": list[3]})
		
	for i in 4:
		
		var list = []
		
		var t = randi_range(20,30)
		list.append(t)
		
		var u = randi_range(20,30)
		list.append(u)
		
		var w = randi_range(20,30)
		list.append(w)
		
		var v = randi_range(20,30)
		list.append(v)
		
		var x = randi_range(20,30)
		list.append(x)
		
		var y = randi_range(20,30)
		list.append(y)
		
		var z = randi_range(20,30)
		list.append(z)
		
		var j = randi_range(1,7)-1
		
		var a = list[j]
		
		list.sort()
		result.append({
			"question":"Find the mode of the given set of numbers.\n(%d, %d, %d, %d, %d, %d, %d)" %[t,u,w,v,x,y,z],
			"answer": a })
		
	for i in 4:
		
		var list = []
		
		var t = randi_range(20,30)
		list.append(t)
		
		var u = randi_range(20,30)
		list.append(u)
		
		var w = randi_range(20,30)
		list.append(w)
		
		var v = randi_range(20,30)
		list.append(v)
		
		var x = randi_range(20,30)
		list.append(x)
		
		var y = randi_range(20,30)
		list.append(y)
		
		var z = randi_range(20,30)
		list.append(z)
		
		list.sort()
		var d = list[6] - list[0]
		result.append({
			"question":"Find the range of the given set of numbers.\n(%d, %d, %d, %d, %d, %d, %d)" %[t,u,w,v,x,y,z],
			"answer": d })

return result

func generate_Spatial_questions() -> Array:
	var result = []
	
	return result

func generate_Financial_questions() -> Array:
	var result = []
	
	return result
'''
