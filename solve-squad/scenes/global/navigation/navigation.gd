extends Node

const battle_scene = preload("res://scenes/global/battle/battle.tscn")
const tutorial_scene = preload("res://scenes/global/tutorial/tutorial.tscn")

var visited_before: Array = []

func _ready() -> void:
	Battle.start_battle.connect(_on_start_battle)
	Battle.end_battle.connect(_on_end_battle)
	
func change_scene(scene: PackedScene) -> void:
	if scene != null:
		Transition.transition()
		await Transition.on_transition_finished
		GlobalSprites.reparent_sprites(GlobalSprites)
		print(GlobalSprites.sprites)
		get_tree().change_scene_to_packed(scene)
		await get_tree().process_frame
		
func _on_start_battle(_player, _enemy):
	if battle_scene not in visited_before:
		visited_before.append(battle_scene)
	await change_scene(battle_scene)
	Battle.setup_battle.emit()
	Battle.instantiate_battle_gui.emit()
	var battle_camera = get_tree().get_root().get_node("BattleScene/Camera2D")
	battle_camera.make_current()
	await Transition.on_transition_completed

func _on_end_battle(player_won) -> void:
	if player_won:
		await change_scene(tutorial_scene)
		var world = get_tree().get_root().get_node("Tutorial")
		Battle.battle_player.reparent(world)
		Battle.battle_enemy.reparent(world)
		GlobalSprites.show_sprites(GlobalSprites.sprites.keys())
