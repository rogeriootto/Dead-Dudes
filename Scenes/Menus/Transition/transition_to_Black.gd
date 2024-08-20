extends CanvasLayer

signal onTransitionToDeathFinished

@onready var colorRect = $ColorRect
@onready var animationPlayer = $AnimationPlayer

func _ready() -> void:
	colorRect.visible = false

func transitionFadeIn():
	colorRect.visible = true
	animationPlayer.play("fade_in")

func transitionFadeOut():
	animationPlayer.play("fade_out")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		onTransitionToDeathFinished.emit()
	elif anim_name == "fade_out":
		colorRect.visible = false
	pass 
