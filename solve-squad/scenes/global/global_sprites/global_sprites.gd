extends Node2D

signal gain_exp(gained_exp: int)
signal gain_item(item: String)

var sprites: Dictionary = {}

func reparent_sprites(scene: Node2D) -> void:
	for id in sprites:
		sprites[id]["sprite"].reparent(scene)
		
func hide_sprites(exclude: Array) -> void:
	for id in sprites:
		if id not in exclude:
			sprites[id]["sprite"].visible = false
			
func show_sprites(sprite_names: Array) -> void:
	for id in sprites:
		if id in sprite_names:
			sprites[id]["sprite"].visible = true
