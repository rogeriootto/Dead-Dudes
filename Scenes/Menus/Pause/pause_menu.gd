extends CanvasLayer
func _process(delta: float) -> void:
	if (Input.is_action_just_pressed('pause_p1') or Input.is_action_just_pressed('pause_p2')):
		if get_tree().paused:
			get_tree().paused = false
			PauseMenu.visible = false
		else:
			get_tree().paused = true
			PauseMenu.visible = true
