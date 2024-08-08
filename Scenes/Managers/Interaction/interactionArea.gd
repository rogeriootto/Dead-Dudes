extends Area3D
class_name InteractionArea

var can_interact = true

func interact(callableFunction: Callable, playerNumber: String):
	if playerNumber == 'p1' && can_interact:
		InteractionManager.interactableFunctionP1 = callableFunction
	elif playerNumber == 'p2' && can_interact:
		InteractionManager.interactableFunctionP2 = callableFunction

func _on_body_entered(body:Node3D):
	if can_interact:
		InteractionManager.register_area(self, body.playerNumber)

func _on_body_exited(body:Node3D):
	InteractionManager.unregister_area(self, body.playerNumber)
	
