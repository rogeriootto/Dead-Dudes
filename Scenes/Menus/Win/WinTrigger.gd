extends Area3D

func _on_body_entered(body:Node3D):
	SignalManager.emitChangeScenes()
	get_tree().get_first_node_in_group("camera").changeSceneState = true
	TransitionBetweenLevels.position = get_tree().get_first_node_in_group("camera").position
	TransitionBetweenLevels.transition()
	await TransitionBetweenLevels.onTransitionToNextSceneFinished
