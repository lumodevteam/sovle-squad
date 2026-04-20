extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer

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
	


func _on_button_pressed() -> void:
	resume()
