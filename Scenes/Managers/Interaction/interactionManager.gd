extends Node3D

@onready var p1 = get_tree().get_first_node_in_group("p1")
@onready var p2 = get_tree().get_first_node_in_group("p2")

var p1_active_areas = []
var p2_active_areas = []
var p1_can_interact = true
var p2_can_interact = true

var interactableFunctionP1: Callable = func():
	pass

var interactableFunctionP2: Callable = func():
	pass

func register_area(area: InteractionArea, playerNumber: String):
	if playerNumber == 'p1':
		p1_active_areas.push_back(area)
	else:
		p2_active_areas.push_back(area)

func unregister_area(area: InteractionArea, playerNumber: String):
	#TODO isso ainda ta bugando quando eu tendo sair de perto de um interactable num mapa sem Astar
	if GlobalVariables.astarNode:
		GlobalVariables.astarNode.old_points = []
	if playerNumber == 'p1':
		var index = p1_active_areas.find(area)
		if index != -1:
			SignalManager.unregisterListner("interactRequestP1", p1_active_areas[index].get_parent_node_3d(), "interact")
			SignalManager.emitInteractableNameP1('')
			p1_active_areas.remove_at(index)
	else:
		var index = p2_active_areas.find(area)
		if index != -1:
			SignalManager.unregisterListner("interactRequestP2", p2_active_areas[index].get_parent_node_3d(), "interact")
			SignalManager.emitInteractableNameP2('')
			p2_active_areas.remove_at(index)

func _process(delta):
	
	if (p1 == null and p2 == null) :
		p1 = get_tree().get_first_node_in_group("p1")
		p2 = get_tree().get_first_node_in_group("p2")
		return

	if p1_active_areas.size() > 0 && p1_can_interact:
		p1.interactableMarker.visible = true
		p1_active_areas.sort_custom(_sortByDistanceToPlayer1)
		SignalManager.registerListner("interactRequestP1", p1_active_areas[0].get_parent_node_3d(), "interact")
		SignalManager.emitInteractableNameP1(p1_active_areas[0].get_parent_node_3d().type)
	else:
		if p1 != null:
			p1.interactableMarker.visible = false
		
	if p2_active_areas.size() > 0 && p2_can_interact:
		p2.interactableMarker.visible = true
		p2_active_areas.sort_custom(_sortByDistanceToPlayer2)
		SignalManager.registerListner("interactRequestP2", p2_active_areas[0].get_parent_node_3d(), "interact")
		SignalManager.emitInteractableNameP2(p2_active_areas[0].get_parent_node_3d().type)
	else:
		if p2 != null:
			p2.interactableMarker.visible = false

func _sortByDistanceToPlayer1(area1, area2):
	if area1 == null or area2 == null or area1.global_position == null or area2.global_position == null or p1 == null or p1.global_position == null:
		return
	var distance1 = p1.global_position.distance_to(area1.global_position)
	var distance2 = p1.global_position.distance_to(area2.global_position)
	return distance1 < distance2

func _sortByDistanceToPlayer2(area1, area2):
	if area1 == null or area2 == null or area1.global_position == null or area2.global_position == null or p2 == null or p2.global_position == null:
		return
	var distance1 = p2.global_position.distance_to(area1.global_position)
	var distance2 = p2.global_position.distance_to(area2.global_position)
	return distance1 < distance2

func _input(event):
	if event.is_action_pressed("interact_p1") && p1_can_interact && p1.is_on_floor():
		if p1_active_areas.size() > 0:
			p1_can_interact = false
			interactableFunctionP1.call()
			p1_can_interact = true
	
	if event.is_action_pressed("interact_p2") && p2_can_interact && p2.is_on_floor():
		if p2_active_areas.size() > 0:	
			p2_can_interact = false
			interactableFunctionP2.call()
			p2_can_interact = true
