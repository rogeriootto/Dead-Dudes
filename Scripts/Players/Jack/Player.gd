extends CharacterBody3D
var playerNumber
var interactableName

func _ready():
	SignalManager.registerListner("interactableNameRequest", self, "setInteractableName")

func _process(delta):
	if playerNumber == 'p1':
		AstarManager.player1Position = global_position
	else:
		AstarManager.player2Position = global_position

func getPlayerNumber():
	return playerNumber

func setInteractableName(name: String):
	interactableName = name
