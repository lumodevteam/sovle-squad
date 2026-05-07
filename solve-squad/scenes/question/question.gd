extends Control

#------------------------------------------Node References---------------------------------------------
@onready var question_area: Label = $"CanvasLayer/Question Area"
@onready var option_area: ItemList = $"CanvasLayer/Option Area"
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var bar_graph: Control = $"CanvasLayer/Panel/BarGraph"
@onready var bar_container: HBoxContainer = $"CanvasLayer/Panel/BarGraph/HBoxContainer" 
@onready var slider_label: Label = $CanvasLayer/Panel/BarGraph/SliderLabel
@onready var submit_button: Button = $CanvasLayer/Panel/BarGraph/SubmitButton
@onready var v_slider: VSlider = $CanvasLayer/Panel/BarGraph/VSlider
@onready var grid_container: GridContainer = $CanvasLayer/Panel/GridContainer
@onready var shape_image: TextureRect = $"CanvasLayer/ShapeImage"

#------------------------------------------Variables---------------------------------------------
var questions = {} # Stores all of the generated questions by strand
var current_strand = "" # Which strand is currently active
var current_answer: int = 0 # The correct answer for the question given
var max_height = 200 # Max heights of the bars for the bar graph
var is_bar_question = false # Changes if the current question is a bar graph question
var current_bar_data = {} # Stores the bar data for the current bar question

func _ready():
	# Connect to the battle signal so questions are shown when asked
	Battle.ask_question.connect(_on_ask_question)
	
	# Set up option area and make sure you can only select one
	option_area.select_mode = ItemList.SELECT_SINGLE
	
	# Gernerate all questions for all strands
	generate_questions()
	
	# Set up slider for bar graph questions
	v_slider.min_value = 0
	v_slider.max_value = 200
	v_slider.step = 1
	v_slider.value = 50
	v_slider.value_changed.connect(_on_slider_changed)
	submit_button.pressed.connect(_on_submit_pressed)
	
	# Hide shape images by default
	shape_image.visible = false
	
	# Set the starting strand
	set_strand()

#------------------------------------------Called When Using Any Attack---------------------------------------------
func _on_ask_question():
	GlobalSprites.hide_sprites([])
	show_question()

#------------------------------------------Sets the current strand randomly---------------------------------------------
func set_strand():
	var list = ["algebra","data","spacial","financial"]
	var i = randi_range(0,len(list)-1)
	current_strand = list[i]

#------------------------------------------Picks and displayes a random question from the current strand---------------------------------------------
func show_question():
	GlobalSprites.hide_sprites([])
	var strand = questions[current_strand]
	var entry = strand[randi() % strand.size()]
	question_area.text = entry["question"]
	current_answer = entry["answer"]
	
	# Loads shape images for spatial questions
	if entry.has("shape"):
		if ResourceLoader.exists(entry["shape"]):
			shape_image.texture = load(entry["shape"])
			shape_image.visible = true
		else:
			print("missing image: ", entry["shape"])
		answers(current_answer,3) # smaller range for spatial questions

# Bar graph questions
	if entry.has("bar_data"):
		bar_graph.visible = true
		draw_bars(entry["bar_data"], int(v_slider.value)) # Set the slider max to match the data range
		v_slider.max_value = entry["slider_max"]
		option_area.visible = false
		current_bar_data = entry["bar_data"]
		v_slider.value = 50
		slider_label.text = "50"
		slider_label.add_theme_color_override("font_color", Color(0.184, 0.078, 0.184, 1.0))
		draw_bars(current_bar_data, int(v_slider.value))
		if entry.has("table_headers"):
			grid_container.visible = true
			draw_table(entry["table_headers"],entry["table_rows"])
	else:
		# Hide bar graph for non bar questions
		is_bar_question = false
		bar_graph.visible = false
		option_area.visible = true
		grid_container.visible = false
		
		# Creates two choice qwuestions for quantitatve vs qualitative
		if entry.has("question_type") and entry["question_type"] == "two_choice":
			option_area.clear()
			for choice in entry ["choices"]:
				option_area.add_item(choice)
		else:
			answers(current_answer, 15)# Different range for everything else
			
#------------------------------------------Draws The Bar Graph---------------------------------------------
func draw_bars(data: Dictionary, slider_val:int):
	# Clear old bars
	for child in bar_container.get_children():
		child.queue_free()
		
	var max_value = 0
	
	# Find the highest value to scale all bars relative to it
	for i in data:
		if data[i] != null and data[i] > max_value:
			max_value = data[i]
	
	# Make sure the corrent answer fits in the scale
	if current_answer > max_value:
		max_value = current_answer
		
	# Draws each bar
	for j in data:
		var value = data[j]
		var column = VBoxContainer.new()
		column.custom_minimum_size = Vector2(60, 20)
		column.alignment = BoxContainer.ALIGNMENT_END
		
		if value == null:
			# Missing bar shows the bar in a different colour
			var bar_height = int((float(slider_val)/ float(max_value)) * max_height)
			var top_space = Control.new()
			var val_label = Label.new()
			var slider_bar = ColorRect.new()
			
			# Value above missing bar
			val_label.text = str(slider_val)
			val_label.add_theme_color_override("font_color", Color(0.184, 0.078, 0.184, 1.0))
			val_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			column.add_child(val_label)
			
			# Space makes the label even
			top_space.custom_minimum_size = Vector2(60, max_height - bar_height)
			column.add_child(top_space)
			
			# The sliding bar
			slider_bar.custom_minimum_size = Vector2(60, bar_height)
			slider_bar.color = Color(0.431, 0.722, 0.659, 1.0)
			column.add_child(slider_bar)
			
		else:
			# Normal bars (shows actual value)
			var bar_height = int((float(value)/float(max_value))* max_height)
			
			# Value above bars
			var value_label = Label.new()
			value_label.text = str(value)
			value_label.add_theme_color_override("font_color", Color(0.184, 0.078, 0.184, 1.0))
			value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			column.add_child(value_label)
			
			# Spacer makes the labels evenly 
			var spacer = Control.new()
			spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
			column.add_child(spacer)
			
			# The bar itself
			var bar = ColorRect.new()
			bar.custom_minimum_size = Vector2(60,bar_height)
			bar.color = Color(0.776, 0.314, 0.353, 1.0)
			column.add_child(bar)
		
		# Each lap under the corresponding bar
		var name_label = Label.new()
		name_label.text = j
		name_label.add_theme_color_override("font_color", Color(0.184, 0.078, 0.184, 1.0))
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		column.add_child(name_label)
		bar_container.add_child(column)

#------------------------------------------Calls every time the sliders moves to redraw the missing bar---------------------------------------------
func _on_slider_changed(value:float):
	slider_label.text = str(int(value))
	slider_label.add_theme_color_override("font_color", Color(0.184, 0.078, 0.184, 1.0))
	if not current_bar_data.is_empty():
		draw_bars(current_bar_data, int(value))

#------------------------------------------Called when user preesses submit on the bar graph questions---------------------------------------------
func _on_submit_pressed():
	var player_guess = int(v_slider.value)
	if abs(player_guess - current_answer) == 0:
		question_area.text = "Correct!"
	else:
		question_area.text = "Wrong! So close you were %d away" % abs(player_guess - current_answer)

#------------------------------------------Draws the data table beside the bar graph---------------------------------------------
func draw_table(headers: Array, rows: Array):
		# Clears the old table
	for child in grid_container.get_children():
		child.queue_free()
		
	# Set columns to mactch numbers of headers
	grid_container.columns = headers.size()
	
	# add header row
	for header in headers:
		var header_label = Label.new()
		header_label.add_theme_color_override("font_color", Color(0.0, 0.0, 0.0, 1.0))
		grid_container.add_child(header_label)
	
	# add data rows
	for row in rows:
		for cell in row:
			var cell_label = Label.new()
			cell_label.text = str(cell)
			cell_label.add_theme_color_override("font_color", Color(0.184, 0.078, 0.184, 1.0))
			grid_container.add_child(cell_label)
			
#------------------------------------------Generates multiple choice wrong answers---------------------------------------------
func answers(correct_answer: int, range_val: int = 15):
	option_area.clear()
	var wrong_answers = []
	
	# Keep generating wrong answers until there are 3
	while wrong_answers.size() < 3:
		var wrong = correct_answer + randi_range(-range_val, range_val)
		# Checks to ensure the wrong answer isn't the correct or duplicates
		if wrong != correct_answer and wrong not in wrong_answers:
			wrong_answers.append(wrong)
	
	# Add correct answers and shuffle so it is in a random spot
	var all_answers = wrong_answers
	all_answers.append(correct_answer)
	all_answers.shuffle()
	
	for answer in all_answers:
		option_area.add_item(str(answer))

#------------------------------------------Called when user selects an answer---------------------------------------------
func _on_option_area_item_selected(index: int) -> void:
	var selected_text = option_area.get_item_text(index)
	if int(selected_text) == current_answer:
		Battle.question_answered.emit(true)
	else:
		Battle.question_answered.emit(false)

#------------------------------------------Generates all questions for all strands---------------------------------------------
func generate_questions():
	questions["algebra"] = generate_algebra_questions()
	questions["data"] = generate_data_questions()
	questions["spacial"] = generate_Spatial_questions()
	questions["financial"] = generate_Financial_questions()


#------------------------------------------Algebra Questions---------------------------------------------
func generate_algebra_questions() -> Array:
	var result = []
#------------------------------------------Solving for missing variable---------------------------------------------
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

#------------------------------------------Formula Questions---------------------------------------------

	# x + y = z find z
	for i in 4:
		var x = randi_range(1, 100)
		var y = randi_range(1, 50)
		result.append({
			"question": "Using this formula x + y = z\nGiven x = %d and y = %d. What is z?" % [x, y],
			"answer": x + y
		})

	# x + y = z find x
	for i in 4:
		var x = randi_range(1, 50)
		var y = randi_range(1, 100)
		result.append({
			"question": "Using this formula x + y = z\nGiven y = %d and z = %d. What is x?" % [y, x + y],
			"answer": x
		})

	# m - n = p find p
	for i in 4:
		var m = randi_range(10, 100)
		var n = randi_range(1, m)
		result.append({
			"question": "Using this formula m - n = p\nGiven m = %d and n = %d. What is p?" % [m, n],
			"answer": m - n
		})

	# m - n = p find m
	for i in 4:
		var n = randi_range(1, 100)
		var p = randi_range(1, 100)
		result.append({
			"question": "Using this formula m - n = p\nGiven n = %d and p = %d. What is m?" % [n, p],
			"answer": n + p
		})

	# a x b = c find c
	for i in 4:
		var a = randi_range(2, 12)
		var b = randi_range(2, 12)
		result.append({
			"question": "Using this formula a × b = c\nGiven a = %d and b = %d. What is c?" % [a, b],
			"answer": a * b
		})

	# a x b = c find b
	for i in 4:
		var b = randi_range(2, 12)        # answer
		var a = randi_range(2, 9)
		var c = a * b                     # guaranteed whole
		result.append({
			"question": "Using this formula a × b = c\nGiven c = %d and a = %d. What is b?" % [c, a],
			"answer": b
		})

	# q ÷ r = s find s
	for i in 4:
		var s = randi_range(2, 12)        # answer
		var r = randi_range(2, 9)
		var q = s * r                     # guaranteed whole
		result.append({
			"question": "Using this formula q ÷ r = s\nGiven q = %d and r = %d. What is s?" % [q, r],
			"answer": s
		})

	# q ÷ r = s find q
	for i in 4:
		var s = randi_range(2, 12)
		var r = randi_range(2, 9)
		var q = s * r
		result.append({
			"question": "Using this formula q ÷ r = s\nGiven s = %d and r = %d. What is q?" % [s, r],
			"answer": q
		})

	# x + y + z = w find w
	for i in 4:
		var x = randi_range(1, 50)
		var y = randi_range(1, 50)
		var z = randi_range(1, 50)
		result.append({
			"question": "Using this formula x + y + z = w\nGiven x = %d, y = %d and z = %d. What is w?" % [x, y, z],
			"answer": x + y + z
		})

	# m - n + p = q find q
	for i in 4:
		var m = randi_range(10, 30)
		var n = randi_range(1, m)
		var p = randi_range(1, 50)
		result.append({
			"question": "Using this formula m - n + p = q\nGiven m = %d, n = %d and p = %d. What is q?" % [m, n, p],
			"answer": m - n + p
		})

	#BEDMAS

	# a × b ÷ c = d find d
	for i in 4:
		var divisor = randi_range(2, 6)
		var quotient = randi_range(2, 10)
		var factor = randi_range(2, 6)
		var product = quotient * divisor  # To get a whole number
		result.append({
			"question": "Using this formula a × b ÷ c = d\nGiven a = %d, b = %d and c = %d. What is d?" % [factor, product, divisor],
			"answer": factor * quotient
		})

	# x + y - z = w find w
	for i in 4:
		var x = randi_range(5, 50)
		var y = randi_range(1, 50)
		var z = randi_range(5, x + y)
		result.append({
			"question": "Using this formula x + y - z = w\nGiven x = %d, y = %d and z = %d. What is w?" % [x, y, z],
			"answer": x + y - z
		})

	# p × q + r = s find s
	for i in 4:
		var p = randi_range(2, 8)
		var q = randi_range(2, 8)
		var r = randi_range(1, 50)
		result.append({
			"question": "Using this formula p × q + r = s\nGiven p = %d, q = %d and r = %d. What is s?" % [p, q, r],
			"answer": p * q + r
		})

	# m ÷ n + o = p find p
	for i in 4:
		var quotient = randi_range(2, 12)  # m ÷ n
		var n = randi_range(2, 9)
		var m = quotient * n               # guaranteed whole
		var o = randi_range(1, 10)
		result.append({
			"question": "Using this formula m ÷ n + o = p\nGiven m = %d, n = %d and o = %d. What is p?" % [m, n, o],
			"answer": quotient + o
		})

	# x × y - z ÷ w = v find v
	for i in 4:
		var x = randi_range(2, 8)
		var y = randi_range(2, 8)
		var w = randi_range(2, 6)
		var zdivw = randi_range(1, 10)    # z ÷ w result
		var z = zdivw * w                 # guaranteed whole
		result.append({
			"question": "Using this formula x × y - z ÷ w = v\nGiven x = %d, y = %d, z = %d and w = %d. What is v?" % [x, y, z, w],
			"answer": x * y - zdivw
		})
	
#------------------------------------------Patterns---------------------------------------------
	
	# Find the multiplier
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
	
	# Find the addition pattern
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
	# Find the subtraction patter
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
	# Find the divisor
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
	# Next term (multiplication)
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
	# Next term (addition)
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
	# Next term (subtraction)
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
	# Next term (division)
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

#------------------------------------------Word Problems---------------------------------------------
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
#------------------------------------------Data Questions---------------------------------------------
func generate_data_questions() -> Array:
	var result = []
	
	# bar graph
	for i in 4:
		var labels = ["Lap 1", "Lap 2", "Lap 3", "Lap 4", "Lap 5"]
		var data = {}
		for label in labels:
			data[label] = randi_range(80, 200)
	
		var missing_key = labels[randi() % labels.size()]
		var missing_value = data[missing_key]
		data[missing_key] = null
	
		var table_rows = []
		for label in labels:
			if data[label] != null:
				table_rows.append([label, "|" + str(data[label]) + " km/h"])
			else:
				table_rows.append([label, "|" + str(missing_value) + " km/h"])
	
		result.append({
			"question": "Lightning McQueen drove these speeds each lap.\nWhat was the missing lap speed in km/h?  ",
			"answer": missing_value,
			"bar_data": data,
			"slider_max": 200,
			"table_headers": ["Lap", "Speed"],
			"table_rows": table_rows })
	
	# Mean
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
	
	# Median
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

	# Mode
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
	# Range
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
			"question":"Find the range of the given set of numbers.\n(%d, %d, %d, %d, %d, %d, %d)" %[t,u,w,v,x,y,z],
			"answer": list[6] - list[0] })
			
		result.append({
			"question": "Is the number of students in a class quantitative or qualitative?",
			"answer": 0,
			"question_type": "two_choice",
			"choices":["Quantitative","Qualitative"]
		})
		result.append({
			"question": "Is the colour of a car quantitative or qualitative?",
			"answer": 1,
			"question_type": "two_choice",
			"choices":["Quantitative","Qualitative"]
		})
	return result
#------------------------------------------Spatial Questions---------------------------------------------
func generate_Spatial_questions() -> Array:
	var result = []
	
	var shapes = [
		{
			"image":"res://assets/shapes/rectangle.png",
			"properties":{
				"vertices": 4,
				"sides": 4,
				"parallel_lines": 2,
				"perpendicular_lines": 4,
				"lines_of_symmetry": 2,
				"right_angles": 4,
				"acute_angles": 0,
				"obtuse_angles": 0,
			}
		},
		{
			"image":"res://assets/shapes/square.png",
			"properties":{
				"vertices": 4,
				"sides": 4,
				"parallel_lines": 2,
				"perpendicular_lines": 4,
				"lines_of_symmetry": 2,
				"right_angles": 4,
				"acute_angles": 0,
				"obtuse_angles": 0,
			}
		},
		{
			"image":"res://assets/shapes/scalene_triangle.png",
			"properties":{
				"vertices": 3,
				"sides": 3,
				"parallel_lines": 0,
				"perpendicular_lines": 0,
				"lines_of_symmetry": 0,
				"right_angles": 0,
				"acute_angles": 2,
				"obtuse_angles": 1,
			}
		},
		{
			"image":"res://assets/shapes/right_triangle.png",
			"properties":{
				"vertices": 3,
				"sides": 3,
				"parallel_lines": 0,
				"perpendicular_lines": 1,
				"lines_of_symmetry": 0,
				"right_angles": 1,
				"acute_angles": 2,
				"obtuse_angles": 0,
			}
		},
		{
			"image":"res://assets/shapes/pentagon.png",
			"properties":{
				"vertices": 5,
				"sides": 5,
				"parallel_lines": 0,
				"perpendicular_lines": 0,
				"lines_of_symmetry": 5,
				"right_angles": 0,
				"acute_angles": 3,
				"obtuse_angles": 2,
			}
		},
		{
			"image":"res://assets/shapes/octagon.png",
			"properties":{
				"vertices": 8,
				"sides": 8,
				"parallel_lines": 8,
				"perpendicular_lines":0,
				"lines_of_symmetry": 4,
				"right_angles": 0,
				"acute_angles": 0,
				"obtuse_angles": 8,
			}
		},
		{
			"image":"res://assets/shapes/isosceles_triangle.png",
			"properties":{
				"vertices": 3,
				"sides": 3,
				"parallel_lines": 0,
				"perpendicular_lines": 0,
				"lines_of_symmetry": 1,
				"right_angles": 0,
				"acute_angles": 3,
				"obtuse_angles": 0,
			}
		},
		{
			"image":"res://assets/shapes/hexagon.png",
			"properties":{
				"vertices": 6,
				"sides": 6,
				"parallel_lines": 3,
				"perpendicular_lines": 0,
				"lines_of_symmetry": 3,
				"right_angles": 0,
				"acute_angles": 0,
				"obtuse_angles": 6,
			}
		},
		{
			"image":"res://assets/shapes/heptagon.png",
			"properties":{
				"vertices": 7,
				"sides": 7,
				"parallel_lines": 0,
				"perpendicular_lines": 0,
				"lines_of_symmetry": 7,
				"right_angles": 0,
				"acute_angles": 0,
				"obtuse_angles": 7,
			}
		},
		{
			"image":"res://assets/shapes/equalateral_triangle.png",
			"properties":{
				"vertices": 3,
				"sides": 3,
				"parallel_lines": 0,
				"perpendicular_lines": 0,
				"lines_of_symmetry": 3,
				"right_angles": 0,
				"acute_angles": 3,
				"obtuse_angles": 0,
			}
		},
	]
	var question_templates = {
		"vertices": "How many vertices does this shape have?",
		"sides": "How many sides does this shape have?",
		"parallel_lines": "How many parallel lines does this shape have?",
		"perpendicular_lines": "How many perpendicular lines does this shape have?",
		"lines_of_symmetry": "How many lines of symmetry does this shape have?",
		"right_angles": "How many right angles does this shape have?",
		"acute_angles": "How many acute angles does this shape have?",
		"obtuse_angles": "How many obtuse angles does this shape have?",
	}
	for shape in shapes:
		for property in question_templates:
			result.append({
				"question":question_templates[property],
				"answer": shape["properties"][property],
				"shape": shape["image"]
			})
	return result
#------------------------------------------Financial Questions---------------------------------------------
func generate_Financial_questions() -> Array:
	var result = []
	
	# Saving money per day
	for i in 4:
		var x = randi_range(2,50)
		var y = randi_range(7,21)
		var z = (x*y)
		result.append({
			"question":"Layla is saving money everyday to save up for food she saves $%d every day.\nHow much money for food will she have in %d days?" %[x,y],
			"answer": z })
	
	# Days to reach goal
	for i in 4:
		var x = randi_range(100,500)
		var y = randi_range(10, 30)
		var z = x % y
		
		x -= z
		@warning_ignore("integer_division")
		var v = (x / y)
		
		result.append({
			"question":"Layla is saving $%d for food. She saves $%d everyday.\nHow many days does it take to reach her goal?" %[x,y],
			"answer": v })
			
	# Coin counting
	for i in 4:
		var list = [1,5,10,25,100,200]
		var money = ["pennies","nickles","dimes","quarters","loonies","toonies"]
		var x = randi() % list.size()
		var y = randi_range(50,400)
		var z = list[x]
		var v = y / z
		var w = money[x]
		
		result.append({
			"question":"How many %s are in %d¢?" %[w,y],
			"answer": v })
	
	# Profit or loss balance sheet
	for i in 4:
		var x = randi_range(1000,10000)
		var y = randi_range(1000,5000)
		var z = x - y
		
		result.append({
			"question":"Nathan would like to know if his business made or lost money.\nHis income was $%d and his expenses was $%d.\nWhat is Nathan's total?" %[x,y],
			"answer": z})
			
	# Simple intrest + total
	for i in 4:
		var x = randi_range(1,10)
		var y = randi_range(3,12)
		var z = randi_range(100,600)*5
		
		var v = (x) * (0.01)
		var w = z + y * (z * v)
		result.append({
			"question":"If you invest $%d into a bank at %d%% simple intrest.\nIn %d months what is the total amount you will have earned?" %[z,x,y],
			"answer": w})
	# Simple intrest - interest earned only
	for i in 4:
		var x = randi_range(1,10)
		var y = randi_range(3,12)
		var z = randi_range(100,600)*5
		
		var v = (x) * (0.01)
		var w = (v * z) * y
		result.append({
			"question":"If you invest $%d into a bank at %d%% simple intrest.\nIn %d months how much extra money will you have earned?" %[z,x,y],
			"answer": w })
			
			

	return result
