extends Control

var questions = {
	"Numbers" : [
	{"question" : 1, "answer" : 2},
	{"question" : 3, "answer" : 2}
	],
	"Algebra" : [
	# Solving for variables
	
	#Just addition & subtraction to solve for "x"
	{"question" : "Solve for x.\nx + 3 = 7", "answer" :4},
	{"question" : "Solve for x.\nx + 6 = 14", "answer" :8},
	{"question" : "Solve for x.\nx - 5 = 9", "answer" :14},
	{"question" : "Solve for x.\nx - 8 = 12", "answer" :20},
	#Solving for "x" using only division
	{"question" : "Solve for x.\n2x = 10", "answer" :5},
	{"question" : "Solve for x.\n3x = 18", "answer" :6},
	{"question" : "Solve for x.\n4x = 32", "answer" :8},
	{"question" : "Solve for x.\n5x = 45", "answer" :9},
	#Solving for the variable using multiplicaiton only
	{"question" : "Solve for b.\nb ÷ 2 = 7", "answer" :14},
	{"question" : "Solve for s.\ns ÷ 4 = 6", "answer" :24},
	{"question" : "Solve for a.\na ÷ 5 = 9", "answer" :45},
	#Using all the 4 main operations to solve for a variable.
	{"question" : "Solve for n.\n2n + 4 = 14", "answer" :5},
	{"question" : "Solve for u.\n3u - 6 = 15", "answer" :7},
	{"question" : "Solve for e.\n4e + 8 = 40", "answer" :8},
	{"question" : "Solve for f.\n5f - 10 = 30", "answer" :8},
	
	# Variable formula questions
	
	#One step questions
	{"question" : "Using this formula x + y = z\nGiven x = 5 and y = 3. What is z?", "answer" :8},
	{"question" : "Using this formula m - n = p\nGiven m = 12 and n = 7. What is p?", "answer" :5},
	{"question" : "Using this formula a x b = c\nGiven a = 6 and b = 4. What is c?", "answer" :24},
	{"question" : "Using this formula q/r = 2\nGiven q = 24 and r = 6. What is s?", "answer" :4},
	#One or two-step questions
	{"question" : "Using this formula x + y = z \nGiven y = 8 and z = 15. What is x?", "answer" :7},
	{"question" : "Using this formula m − n = p \nGiven n = 9 and p = 16. What is m?", "answer" :25},
	{"question" : "Using this formula a × b = c\nGiven c = 56 and a = 7. What is b?", "answer" :8},
	{"question" : "Using this formula q ÷ r = s\nGiven s = 5 and r = 10. What is q?", "answer" :50},
	{"question" : "Using this formula x + y + z = w\nGiven x = 4, y = 7 and z = 3. What is w?", "answer" :14},
	{"question" : "Using this formula m − n + p = q\nGiven m = 20, n = 8, p = 5. What is q?", "answer" :17},
	#Two operations combined(BEDMAS)
	{"question" : "Using this formula a × b ÷ c = d\nGiven a = 24, b = 3 and c = 6. What is d?", "answer" :12},
	{"question" : "Using this formula x + y − z = w\nGiven x = 12, y = 8 and z = 5. What is w?", "answer" :15},
	{"question" : "Using this formula p × q + r = s\nGiven p = 4, q = 5 and r = 6. What is s?", "answer" :26},
	{"question" : "Using this formula m ÷ n + o = p\nGiven m = 36, n = 6 and o = 7. What is p?", "answer" :13},
	{"question" : "Using this formula x × y − z ÷ w = v\nGiven x = 6, y = 8, z = 12 and w = 4. What is v?", "answer" :45},
	
	],

}
