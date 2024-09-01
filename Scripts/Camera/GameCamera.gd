extends Camera3D

@export var player1 : CharacterBody3D
@export var player2 : CharacterBody3D
@export var offset : Vector3
var changeSceneState : bool

func _ready():
	changeSceneState = false

func _process(delta):
	if !changeSceneState:
		calcCameraPos(player1.position if player1 else Vector3.ZERO, player2.position if player2 else Vector3.ZERO, player1 && player2)

func calcCameraPos(p1Pos: Vector3, p2Pos: Vector3, multiFlag: bool):
	if multiFlag:	
		position.x = (p1Pos.x + p2Pos.x)/2 + offset.x
		position.y = (p1Pos.y + p2Pos.y)/2 + offset.y
		position.z = (p1Pos.z + p2Pos.z)/2 + offset.z
	else:
		position.x = p1Pos.x + p2Pos.x + offset.x
		position.y = p1Pos.y + p2Pos.y + offset.y
		position.z = p1Pos.z + p2Pos.z + offset.z
