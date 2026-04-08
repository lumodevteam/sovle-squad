extends Node2D

@onready var static_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D

var player_in_range: Node2D = null
var identifier: String
var need_interact: bool
var solid: bool # can the player walk through?
