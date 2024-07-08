extends Area3D
class_name InteractionArea

var interaction

@export var action_name: String = "interact"

func interact(callableFunction: Callable):
	InteractionManager.interactableFunction = callableFunction

func _on_body_entered(body:Node3D):
	InteractionManager.register_area(self)

func _on_body_exited(body:Node3D):
	InteractionManager.unregister_area(self)
	
