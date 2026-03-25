extends Control

@onready var dialogue: Control = $Dialogue

func _ready() -> void:
	Tutorial.npc_dialogue_added.connect(_on_npc_dialogue_added)
	
func _on_npc_dialogue_added(text) -> void:
	for line in range(text.size()):
		await dialogue.add_log(text[line])
	Tutorial.conversation_over.emit()
