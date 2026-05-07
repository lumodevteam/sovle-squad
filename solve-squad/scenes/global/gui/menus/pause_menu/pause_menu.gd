extends Control # extends control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var settingPanel: Panel = $CanvasLayer/settingPanel
@onready var optionsPanel: Panel = $CanvasLayer/optionsPanel
@onready var creditsPanel: Panel = $CanvasLayer/creditsPanel


func resume() -> void:
	canvas_layer.visible = false
	get_tree().paused = false
	
func pause() -> void:
	canvas_layer.visible = true
	get_tree().paused = true
	
func _process(delta: float) -> void:
	check_for_pause()
	
func check_for_pause() -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()

func openOptions() -> void:
	canvas_layer.visible = true
	optionsPanel.visible = true
	settingPanel.visible = false
	creditsPanel.visible = false
	
func backOptions() -> void:
	canvas_layer.visible = true
	optionsPanel.visible = false
	settingPanel.visible = true
	creditsPanel.visible = false
	
func credits() -> void:
	canvas_layer.visible = true
	optionsPanel.visible = false
	settingPanel.visible = false
	creditsPanel.visible = true

func _on_button_pressed() -> void:
	#resume
	resume()


func _on_button_options_pressed() -> void:
	#options
	openOptions()


func _on_back_button_pressed() -> void:
	#back button
	backOptions()


func _on_credits_button_pressed() -> void:
	#credits
	credits()


func _on_back_credits_button_pressed() -> void:
	#back from credits
	openOptions()
