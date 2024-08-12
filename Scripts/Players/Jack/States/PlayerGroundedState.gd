extends PlayerState
class_name PlayerGrounded

@export var player: CharacterBody3D
@export var animControl : AnimationPlayer
var speed: float = 4

var velocityTest : float
var cameraRotation: Vector3

@onready var interaction_area = get_tree().get_first_node_in_group("playerInteractableArea")
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func Enter():
	pass
	
func Update(delta: float):
	velocityTest = abs(player.velocity.x) + abs(player.velocity.z)
	if velocityTest == 0:
		Transitioned.emit(self, 'PlayerIdle')
	else:
		Transitioned.emit(self, 'PlayerWalking')
		
func Physics_Update(delta: float):
	pass

func buttonsCheck():
	if Input.is_action_just_pressed("buildingMode_" + player.getPlayerNumber()):
		Transitioned.emit(self, 'PlayerBuilding')

	if Input.is_action_just_pressed("jump_" + player.getPlayerNumber()):
		Transitioned.emit(self, 'PlayerJump')
	
	if Input.is_action_just_pressed("specialAttack_" + player.getPlayerNumber()):
		if player.playerNumber == 'p1':
			Transitioned.emit(self, 'JackSpecialAttack')
		else:	
			Transitioned.emit(self, 'JohnSpecialAttack')

	if Input.is_action_just_pressed("normalAttack_" + player.getPlayerNumber()):
		Transitioned.emit(self, 'NormalAttack')

var _onInteractP1 = func():
	if player.interactableName == 'carro':
		Transitioned.emit(self, 'PlayerMovingObstacle')
	else:
		SignalManager.emitInteractRequestP1()
		Transitioned.emit(self, 'PlayerPickingUp')

var _onInteractP2 = func():
	if player.interactableName == 'carro':
		Transitioned.emit(self, 'PlayerMovingObstacle')
	else:
		SignalManager.emitInteractRequestP2()
		Transitioned.emit(self, 'PlayerPickingUp')

func checkIfPlayerIsDead():
	if player.isPlayerDead:
		Transitioned.emit(self, 'PlayerDying')

func gravityPhysics(delta: float, jumping: bool):
	var jumpVelocity = 6
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
	
	if jumping and player.is_on_floor():
		player.velocity.y = jumpVelocity

	player.move_and_slide()

func playerMovement(speedModifier: float = 0.0):
	checkIfPlayerIsDead()
	var move_direction := Vector3.ZERO
	var velocity := Vector3.ZERO

	if player.playerNumber == 'p1':
		interaction_area.interact(_onInteractP1, player.playerNumber)
	else:
		interaction_area.interact(_onInteractP2, player.playerNumber)
	
	var camera3Dnode = get_tree().get_first_node_in_group("camera")
	
	if player:
		move_direction.x = Input.get_action_strength("right_" + player.getPlayerNumber()) - Input.get_action_strength("left_" + player.getPlayerNumber())
		move_direction.z = Input.get_action_strength("down_"  + player.getPlayerNumber()) - Input.get_action_strength("up_" + player.getPlayerNumber())

		if camera3Dnode:
			move_direction = move_direction.rotated(Vector3.UP, camera3Dnode.global_rotation.y)

		velocity.x = move_direction.x * (speed + speedModifier)
		velocity.z = move_direction.z * (speed + speedModifier)
		
		if velocity.length() > 0.2 && !player.axis_lock_angular_y:
			var look_direction = Vector2(velocity.z, velocity.x)
			player.rotation.y = look_direction.angle()

		player.velocity.x = velocity.x
		player.velocity.z = velocity.z
		
		player.move_and_slide()
