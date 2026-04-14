extends Node

var player_in_range: Node2D = null
var identifier: String

var is_interacting: bool = false

var quest_completed: bool = false
var quest_exp: int = 300
var quest_item: String = "Key to the Village"

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
		"text" : [
			"A quest you say?", 
			"Well legend tells of this number line (whatever that means),",
			"it is believed that if it is in the right order something majestic happens",
			"come back when you've completed the quest!"
			],
		"options" : []
	},
	"quest_completed" : {
		"text" : [
			"Wow!",
			"You actually completed it!",
			"You must be a mega genius or something!",
			"Thank you so much!"
		],
		"options" : [
			{
				"text" : "Glad to help!",
				"next" : "express_gratitude"
			}
		]
	},
	"express_gratitude" : {
		"text" : [
			"Wow I should ask you for more help!",
			"I have some rewards for you...",
			"Anyways off you go now!"
		],
		"options" : []
	}
}

func _ready() -> void:
	Tutorial.quest_completed.connect(_on_quest_completed)
	Gui.conversation_over.connect(_on_conversation_over)
	
func _on_quest_completed() -> void:
	dialogue_tree["start"]["options"][1]["next"] = "quest_completed"

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
	
func _on_conversation_over(node_key) -> void:
	is_interacting = false
	if node_key == "quest":
		Tutorial.quest_started.emit()
	elif node_key == "express_gratitude":
		give_rewards()
func give_rewards() -> void:
	Tutorial.gain_exp.emit(quest_exp)
	await Gui.info_finished
	Tutorial.gain_item.emit(quest_item)
	await Gui.info_finished
	dialogue_tree["start"]["options"].remove_at(1)
