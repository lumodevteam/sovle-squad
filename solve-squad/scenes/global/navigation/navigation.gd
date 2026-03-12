extends Node

const battle_scene = preload("res://scenes/global/battle/battle.tscn")
const tutorial_scene = preload("res://scenes/tutorial.tscn")
var current_scene = tutorial_scene

func _ready() -> void:
	Battle.start_battle.connect(_on_start_battle)
	
func change_scene(scene) -> void:
	if scene != null:
		Transition.transition()
		await Transition.on_transition_finished
		get_tree().change_scene_to_packed(scene)
		current_scene = scene
		current_scene.instantiate()
		
func _on_start_battle(_player, _enemy):
	change_scene(battle_scene)
	await Transition.on_transition_finished
	Battle.instantiate_battle_gui.emit()
