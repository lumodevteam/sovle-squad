extends Node2D

var sprites: Dictionary = {}

func reparent_sprites(scene: Node2D) -> void:
	for sprite in sprites:
		sprites[sprite].reparent(scene)
		
func hide_sprites(exclude: Array) -> void:
	for sprite in sprites:
		if sprite not in exclude:
			sprites[sprite].visible = false
			
func show_sprites(sprite_names: Array) -> void:
	for sprite in sprites:
		if sprite in sprite_names:
			sprites[sprite].visible = true
