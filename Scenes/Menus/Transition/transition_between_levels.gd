extends Node3D

signal onTransitionToNextSceneFinished

@onready var animationPlayer = $AnimationPlayer

func _ready() -> void:
	#self.visible = false
	pass

func transition():
	self.visible = true
	animationPlayer.play("fade_in")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		animationPlayer.play("keep")
	elif anim_name == "keep":
		onTransitionToNextSceneFinished.emit()
		animationPlayer.play("fade_out")
	elif anim_name == "fade_out":
		self.visible = false
	pass 
