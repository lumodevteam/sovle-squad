extends Node

var player_in_range: Node2D = null
var identifier: String

var is_interacting: bool = false
var interactions: int = 0

var quest_completed: bool = false
var quest_exp: int = 300
var quest_item: String = "Key to the Village"

var dialogue_tree: Dictionary = {
	"start" : {
		"text" : ["Hello!"],
		"options" : [
			{
				"text" : "Who are you?",
				"next" : "about"
			}
		]
	},
	"about" : {
		"text" : ["I'm the local cat lady!", "I lost my key somewhere..."],
		"options" : []
	},
	"end" : {
		"text" : ["You found it!", "Thank you so much!", "(You gave her the key)"],
		"options" : []
	}
}

func _ready() -> void:
	TutorialEvents.quest_completed.connect(_on_quest_completed)
	Gui.conversation_over.connect(_on_conversation_over)
	
func _on_quest_completed() -> void:
	dialogue_tree["start"]["options"].append(
		{
			"text" : "I found the key!",
			"next" : "end"
		}
	)
	dialogue_tree["about"]["options"].append(
		{
			"text" : "I found the key!",
			"next" : "end"
		}
	)

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
	if interactions == 1:
		dialogue_tree["start"]["text"] = ["I still haven't found my key..."]
		dialogue_tree["start"]["options"].remove_at(0)
	interactions += 1
	Gui.dialogue_started.emit(dialogue_tree)
	
func _on_conversation_over(node_key) -> void:
	is_interacting = false
	if node_key == "end":
		TutorialEvents.game_won.emit()
