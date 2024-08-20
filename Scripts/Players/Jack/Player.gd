extends CharacterBody3D
var playerNumber
var interactableName

var isPlayerNumberSet = false
var playerHP = 3
var playerInventory = 4
var playerMaxInventorySpace = 6
var isPlayerDead = false

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
	interactableName = name

func addPlayerInventory():
	playerInventory += 1
	if playerNumber == 'p1':
		HUDmanager.Player1InventorySize = playerInventory
	else:
		HUDmanager.Player2InventorySize = playerInventory 
	print("Player " + playerNumber + " has " + str(playerInventory) + " items.")

func removePlayerInventory():
	playerInventory -= 1
	if playerNumber == 'p1':
		HUDmanager.Player1InventorySize = playerInventory
	else:
		HUDmanager.Player2InventorySize = playerInventory 
	print("Player " + playerNumber + " has " + str(playerInventory) + " items left.")

func dealDamage(damage: int):
	playerHP -= damage
	if playerNumber == 'p1':
		HUDmanager.Player1Health = playerHP
	else:
		HUDmanager.Player2Health = playerHP
	print("Player " + playerNumber + " took " + str(damage) + " damage. HP: " + str(playerHP))
	if playerHP <= 0:
		isPlayerDead = true
