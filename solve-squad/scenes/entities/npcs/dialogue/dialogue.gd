extends Control

signal player_acknowledged

@onready var dialogue: RichTextLabel = $DialogueText
@onready var continue_message: RichTextLabel = $DialogueText/ContinueMessage

var continue_message_text: String = "Press any key to continue."
var current_label: RichTextLabel

var is_typing: bool = false

func add_log(text: String) -> void:
	await type_text(text, dialogue)
	display_continue_message()
	await player_acknowledged
	clear_log(dialogue)
	clear_log(continue_message)
	
func clear_log(label: RichTextLabel) -> void:
	label.clear()
	
func type_text(text: String, label: RichTextLabel) -> void:
	print(label)
	current_label = label
	is_typing = true
	label.append_text(text)
	var full_length = label.get_total_character_count()
	label.visible_characters = full_length - text.length()
	
	var tween = create_tween()
	tween.tween_property(
		label,
		"visible_characters",
		full_length,
		text.length() * 0.01
	)
	await tween.finished
	is_typing = false
	
func display_continue_message() -> void:
	type_text(continue_message_text, continue_message)

func _unhandled_input(_event: InputEvent) -> void:
	if is_typing:
		current_label.visible_characters = current_label.get_total_character_count()
	else:
		player_acknowledged.emit()
