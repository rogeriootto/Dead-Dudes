extends CharacterBody3D
var playerNumber
var interactableName

func _ready():
	SignalManager.registerListner("interactableNameRequest", self, "setInteractableName")

func getPlayerNumber():
	return playerNumber

func setInteractableName(name: String):
	interactableName = name