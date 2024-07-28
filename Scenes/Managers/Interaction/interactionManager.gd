extends Node3D

@onready var p1 = get_tree().get_first_node_in_group("p1")
@onready var p2 = get_tree().get_first_node_in_group("p2")
@onready var label = $Label3D

const base_text = "Interaction Button"
var p1_active_areas = []
var p2_active_areas = []
var p1_can_interact = true
var p2_can_interact = true

var interactableFunctionP1: Callable = func():
	pass

var interactableFunctionP2: Callable = func():
	pass

func register_area(area: InteractionArea, playerNumber: String):
#	print('registered area: ', area)
	if playerNumber == 'p1':
		p1_active_areas.push_back(area)
		print('push area p1: ', area)
	else:
		print('push area p2: ', area)
		p2_active_areas.push_back(area)

func unregister_area(area: InteractionArea, playerNumber: String):
	if playerNumber == 'p1':
		var index = p1_active_areas.find(area)
		if index != -1:
			SignalManager.unregisterListner("interactRequestP1", p1_active_areas[index].get_parent_node_3d(), "interact")
			SignalManager.emitInteractableName('')
			p1_active_areas.remove_at(index)
			print('p1_active_areas size: ', p1_active_areas.size())
			print('p1_active_areas: ', p1_active_areas)
	else:
		var index = p2_active_areas.find(area)
		if index != -1:
			SignalManager.unregisterListner("interactRequestP2", p2_active_areas[index].get_parent_node_3d(), "interact")
			SignalManager.emitInteractableName('')
			p2_active_areas.remove_at(index)
			print('p2_active_areas size: ', p2_active_areas.size())

func _process(delta):
	# print('p1_can_interact ', p1_can_interact)
	# print('p2_can_interact ', p2_can_interact)
	# print('p1_active_areas : ', p1_active_areas)
	# print('p2_active_areas : ', p2_active_areas)
	if (p1 == null and p2 == null) :
		p1 = get_tree().get_first_node_in_group("p1")
		p2 = get_tree().get_first_node_in_group("p2")
		return

	if p1_active_areas.size() > 0 && p1_can_interact:
		p1_active_areas.sort_custom(_sortByDistanceToPlayer)
		label.text = base_text + p1_active_areas[0].action_name
		label.global_position = p1_active_areas[0].global_position + Vector3(0, 5, 0)
		SignalManager.registerListner("interactRequestP1", p1_active_areas[0].get_parent_node_3d(), "interact")
		SignalManager.emitInteractableName(p1_active_areas[0].get_parent_node_3d().type)
		label.show()
	else:
		label.hide()
	
	if p2_active_areas.size() > 0 && p2_can_interact:
		p2_active_areas.sort_custom(_sortByDistanceToPlayer)
		label.text = base_text + p2_active_areas[0].action_name
		label.global_position = p2_active_areas[0].global_position + Vector3(0, 5, 0)
		SignalManager.registerListner("interactRequestP2", p2_active_areas[0].get_parent_node_3d(), "interact")
		SignalManager.emitInteractableName(p2_active_areas[0].get_parent_node_3d().type)
		label.show()
	else:
		label.hide()

func _sortByDistanceToPlayer(area1, area2):
	if area1 == null or area2 == null or area1.global_position == null or area2.global_position == null or p1 == null or p1.global_position == null:
		return
	var distance1 = p1.global_position.distance_to(area1.global_position)
	var distance2 = p1.global_position.distance_to(area2.global_position)
	return distance1 < distance2

func _input(event):
	if event.is_action_pressed("interact_p1") && p1_can_interact:
		if p1_active_areas.size() > 0:
			p1_can_interact = false
			label.hide()
			interactableFunctionP1.call()
			p1_can_interact = true
	
	if event.is_action_pressed("interact_p2") && p2_can_interact:
		if p2_active_areas.size() > 0:	
			p2_can_interact = false
			label.hide()
			interactableFunctionP2.call()
			p2_can_interact = true
