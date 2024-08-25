extends Area3D

var flag = false
var alreadyWon = false
@export var nextLevel: String

func _physics_process(delta: float) -> void:
	if flag:
		flag = false
		GlobalVariables.sceneToLoad = nextLevel
		get_tree().get_first_node_in_group("camera").changeSceneState = false
		get_tree().change_scene_to_file("res://Scenes/Menus/Transition/TransitionBetweenLevels.tscn")

		#
func _on_body_entered(body:Node3D):
	if !alreadyWon:
		alreadyWon = true
		SignalManager.emitChangeScenes()
		get_tree().get_first_node_in_group("camera").changeSceneState = true
		TransitionToBlack.transitionFadeIn()
		await TransitionToBlack.onTransitionToDeathFinished
		TransitionToBlack.transitionFadeOut()
		flag = true
	
