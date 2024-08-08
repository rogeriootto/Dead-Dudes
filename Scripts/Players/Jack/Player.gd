extends CharacterBody3D
var playerNumber
var interactableName

var isPlayerNumberSet = false

func _process(delta):
	if playerNumber == 'p1' and not isPlayerNumberSet:
		SignalManager.registerListner("interactableNameRequestP1", self, "setInteractableName")
	else:
		SignalManager.registerListner("interactableNameRequestP2", self, "setInteractableName")
		
	if playerNumber == 'p1':
		AstarManager.player1Position = global_position
	else:
		AstarManager.player2Position = global_position

func getPlayerNumber():
	return playerNumber

func setInteractableName(name: String):
	print('name: ', name)
	interactableName = name
