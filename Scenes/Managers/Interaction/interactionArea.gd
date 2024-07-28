extends Area3D
class_name InteractionArea

var interaction

@export var action_name: String = "interact"

func interact(callableFunction: Callable, playerNumber: String):
	if playerNumber == 'p1':
		InteractionManager.interactableFunctionP1 = callableFunction
	else:
		InteractionManager.interactableFunctionP2 = callableFunction

func _on_body_entered(body:Node3D):
	InteractionManager.register_area(self, body.playerNumber)

func _on_body_exited(body:Node3D):
	InteractionManager.unregister_area(self, body.playerNumber)
	
