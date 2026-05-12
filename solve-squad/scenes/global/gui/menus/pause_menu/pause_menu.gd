extends Control # extends control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var pausePanel: Panel = $CanvasLayer/pausePanel
@onready var optionsPanel: Panel = $CanvasLayer/optionsPanel
@onready var creditsPanel: Panel = $CanvasLayer/creditsPanel

func resume() -> void:
	canvas_layer.visible = false
	pausePanel.visible = false
	optionsPanel.visible = false
	creditsPanel.visible = false
	get_tree().paused = false
	
func pause() -> void:
	canvas_layer.visible = true
	pausePanel.visible = true
	optionsPanel.visible = false
	creditsPanel.visible = false
	get_tree().paused = true
	
	
func _process(delta: float) -> void:
	check_for_pause()

func openOptions() -> void:
	canvas_layer.visible = true
	pausePanel.visible = false
	optionsPanel.visible = true
	creditsPanel.visible = false

func openCredits() -> void:
	canvas_layer.visible = true
	pausePanel.visible = false
	optionsPanel.visible = false
	creditsPanel.visible = true

func check_for_pause() -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			resume()
		else:
			pause()	

func _on_button_pressed() -> void:
	resume()


func _on_options_button_pressed() -> void:
	openOptions()


func _on_back_opts_button_pressed() -> void:
	pause()


func _on_credits_button_pressed() -> void:
	openCredits()


func _on_back_creds_button_pressed() -> void:
	openOptions()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
