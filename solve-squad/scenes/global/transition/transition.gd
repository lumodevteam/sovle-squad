extends CanvasLayer

signal on_transition_finished
signal on_transition_completed   # fully faded back to normal

@onready var color_rect = $ColorRect # color rectangle reference
@onready var animation_player = $AnimationPlayer # animation player reference

func _ready() -> void: # when the game starts
	color_rect.visible = false # not visible
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(anim_name) -> void:
	if anim_name == "fade_to_black":
		on_transition_finished.emit()
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color_rect.visible = false
		on_transition_completed.emit()

func transition() -> void: # transition scene
	color_rect.visible = true # visible
	animation_player.play("fade_to_black")
	
