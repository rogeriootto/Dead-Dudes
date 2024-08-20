extends CanvasLayer

signal onTransitionToDeathFinished

@onready var colorRect = $ColorRect
@onready var animationPlayer = $AnimationPlayer

func _ready() -> void:
	colorRect.visible = false

func transition():
	colorRect.visible = true
	animationPlayer.play("fade_in")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		onTransitionToDeathFinished.emit()
		animationPlayer.play("fade_out")
	elif anim_name == "fade_out":
		colorRect.visible = false
	pass 
