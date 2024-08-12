extends StaticBody3D

@export var comprimento: int
@export var largura: int
@export var altura: int
@export var type: String
var already_snapped : bool = false

func interact(playerNumber: String):
	SignalManager.emitObstacleRemoveRequest(self, get_tree().get_first_node_in_group(playerNumber))

func _ready():
	#if not AstarManager.grid_is_built && not already_snapped:
		#self.position.x = snapped(position.x, AstarManager.grid_step)
		#self.position.z = snapped(position.z, AstarManager.grid_step)
	pass
