extends Node3D

signal onTransitionToNextSceneFinished

var sceneName

@onready var animationPlayer = $AnimationPlayer

func _ready() -> void:
	self.visible = true
	sceneName = GlobalVariables.sceneToLoad
	GlobalVariables.sceneToLoad = ""
	animationPlayer.play("fade_in")
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		print('endend animation')
		TransitionToBlack.transitionFadeIn()
		await TransitionToBlack.onTransitionToDeathFinished
		get_tree().change_scene_to_file(sceneName)
		TransitionToBlack.transitionFadeOut()
