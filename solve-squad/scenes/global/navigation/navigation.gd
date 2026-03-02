extends Node

const battle_scene = preload("res://scenes/global/battle/battle.tscn")
const tutorial_scene = preload("res://scenes/tutorial.tscn")
var current_scene = tutorial_scene

func _on_ready() -> void:
	change_scene(current_scene)	
	
func change_scene(scene) -> void:
	if scene != null:
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_packed(scene)
		current_scene = scene
