extends Node3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var label = $Label3D

const base_text = "Interaction Button"
var active_areas = []
var can_interact = true

var interactableFunction: Callable = func():
	pass

func register_area(area: InteractionArea):
#	print('registered area: ', area)
	active_areas.push_back(area)

func unregister_area(area: InteractionArea):
#	print('unregister area: ', area)
	var index = active_areas.find(area)
	if index != -1:
		SignalManager.unregisterListner("interactRequest", active_areas[index].get_parent_node_3d(), "interact")
		SignalManager.emitInteractableName('')
		active_areas.remove_at(index)

func _process(delta):
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sortByDistanceToPlayer)
		label.text = base_text + active_areas[0].action_name
		label.global_position = active_areas[0].global_position + Vector3(0, 5, 0)
		SignalManager.registerListner("interactRequest", active_areas[0].get_parent_node_3d(), "interact")
		SignalManager.emitInteractableName(active_areas[0].get_parent_node_3d().type)
		label.show()
	else:
		label.hide()



func _sortByDistanceToPlayer(area1, area2):
	if area1 == null or area2 == null or area1.global_position == null or area2.global_position == null or player == null or player.global_position == null:
		return
	var distance1 = player.global_position.distance_to(area1.global_position)
	var distance2 = player.global_position.distance_to(area2.global_position)
	return distance1 < distance2

func _input(event):
	if event.is_action_pressed("interact") && can_interact:
#		print("active_areas size: ", active_areas.size())
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			interactableFunction.call()
			can_interact = true
