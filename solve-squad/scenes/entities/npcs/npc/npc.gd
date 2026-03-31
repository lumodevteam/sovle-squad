extends Node

var player_in_range: Node2D = null
var identifier: String

var is_interacting: bool = false

var quest_completed = false

var dialogue_tree: Dictionary = {
	"start" : {
		"text" : ["Welcome to Solve Squad traveller!"],
		"options" : [
			{
				"text" : "What is solve squad?",
				"next" : "about_1"
			},
			{
				"text" : "Quest...",
				"next" : "quest"
			},
			{
				"text" : "Goodbye!",
				"next" : "end_2"
			}
		]
	},
	"about_1" : {
		"text" : [
			"Sorry let me start from the beginning...", 
			"Our town was fine until these darn monsters started appearing!",
			"We quickly realized that the only way to defeat them was with the use of math.",
			"Unfortunately, none of us have the capabilities to perform such a complex task.",
			"So now we live under the rule of \"The Infinite One\"."
		],
		"options" : [
			{
				"text" : "Ooh tell me more!",
				"next" : "about_2"
			},
			{
				"text" : "Wow fascinating...Thanks for the info!",
				"next" : "end_1"
			}
		]
	},
	"about_2" : {
		"text" : [
			"Our only hope is the \"Great Prophecy!\"",
			"It is told in the prophecy that the \"Chosen One\" will be one to end all of our suffering.",
			"It is also said that this \"Chosen One\" is good at math.",
			"Unfortunately, no one fits this description at the moment...",
			"I do hope that person comes around sometime soon...",
		],
		"options" : [
			{
				"text" : "(Wait I can do math!)",
				"next" : "end_1"
			}
		], 
	},
	"end_1" : {
		"text" : ["Anyways thats enough information, go out and explore!"],
		"options" : []
	},
	"end_2" : {
		"text" : ["Farewell traveler!"],
		"options" : []
	},
	"quest" : {
		"text" : ["A quest you say?"],
		"options" : []
	}
}

var options = {
	"Learn about Solve Squad" : [
		"Welcome to Solve Squad!",
		"An RPG where you explore, and with the help of your math skills, defeat enemies."
	],
	"I heard you needed help?" : [
		"Ah yes...If you are willing to help I hear"
	]
}

func _ready() -> void:
	Gui.conversation_over.connect(_on_conversation_over)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player_in_range:
		player_in_range = null
		
func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact") and not is_interacting:
		interact()
		
func interact() -> void:
	is_interacting = true
	Gui.dialogue_started.emit(dialogue_tree)
	
func _on_conversation_over() -> void:
	is_interacting = false
