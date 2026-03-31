extends Control

signal player_acknowledged

@onready var dialogue_panel: Panel = $CanvasLayer/DialoguePanel
@onready var options_container: VBoxContainer = $CanvasLayer/DialoguePanel/OptionsContainer
@onready var dialogue: RichTextLabel = $CanvasLayer/DialoguePanel/DialogueText
@onready var continue_message: RichTextLabel =  $CanvasLayer/DialoguePanel/DialogueText/ContinueMessage

var continue_message_text: String = "Press any key to continue."
var current_label: RichTextLabel
var dialogue_tree: Dictionary

var is_typing: bool = false
var showing_options: bool = false
var selected_option: int = -1

func _ready() -> void:
	Gui.dialogue_started.connect(_on_dialogue_started)
	Gui.conversation_over.connect(_on_conversation_over)
	Gui.info.connect(_on_info)
	print("info connected: ", Gui.info.is_connected(_on_info))

func add_log(text: String, continue_text: bool) -> void:
	await type_text(text, dialogue)
	if continue_text:
		display_continue_message()
		await player_acknowledged
		clear_log(dialogue)
		clear_log(continue_message)
	
func clear_log(label: RichTextLabel) -> void:
	label.clear()
	
func type_text(text: String, label: RichTextLabel) -> void:
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

func _unhandled_input(event: InputEvent) -> void:
	if not showing_options:
		if is_typing:
			current_label.visible_characters = current_label.get_total_character_count()
		elif event.is_pressed():
			player_acknowledged.emit()
		
func _on_dialogue_started(dialogue_tree) -> void:
	dialogue_panel.visible = true
	self.dialogue_tree = dialogue_tree
	await run_dialogue("start")
	
func _on_conversation_over() -> void:
	dialogue_panel.visible = false
	dialogue_tree = {}
	
func _on_info(text) -> void:
	print("info signal received: ", text)
	dialogue_panel.visible = true
	await add_log(text, true)
	dialogue_panel.visible = false

func run_dialogue(node_key: String) -> void:
	var node = dialogue_tree[node_key]
	await show_text(node["text"])
	
	if node["options"].is_empty():
		Gui.conversation_over.emit()
	else:
		var option_texts = []
		for option in node["options"]:
			option_texts.append(option["text"])
		var choice = await show_options(option_texts)
		var next_key = node["options"][choice]["next"]
		await run_dialogue(next_key)
	
func show_text(text: Array) -> void:
	for line in text:
		await add_log(line, true)
		
func show_options(options: Array) -> int:
	for child in options_container.get_children():
		child.queue_free()
	showing_options = true
	selected_option = -1
	
	for i in range(options.size()):
		var button = Button.new()
		button.text = options[i]
		options_container.add_child(button)
		var captured_i = i
		button.pressed.connect(func():
			selected_option = captured_i
			player_acknowledged.emit()
		)

	await player_acknowledged
	showing_options = false
	for child in options_container.get_children():
		child.queue_free()
	return selected_option
