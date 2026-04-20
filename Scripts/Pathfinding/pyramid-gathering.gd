extends Area3D

var pyramidPoints := []
var pointsAlreadyUsed := []
var deadsInArea := []
var deadsAssignedToPyramid := []
var deadsRequiredForPyramid = 0
var isSorted := false

func _ready() -> void:
	await get_tree().process_frame
	print("criou sla")
	deadsRequiredForPyramid = pyramidPoints.size()
	print(pyramidPoints)
	verifyDeadsAlreadyInArea()

func _process(delta: float) -> void:
	#print("Deads in Area: ", deadsInArea)
	if !isSorted:
		pyramidPoints.sort_custom(func(a, b): return a.y < b.y)
		isSorted = true 
		# print("Sorted Pyramid Points: ", pyramidPoints)
	if deadsInArea.size() > 0 and pyramidPoints.size() > 0:
		getNextAvailablePoint()
	if pyramidPoints.size() == 0:
		for dead in deadsInArea:
			dead.is_dead_foda = true
	# print("pointsAlreadyUsed: ", pointsAlreadyUsed)
	

func _on_body_entered(body: Node3D) -> void:
	print("deads assigned: ", deadsAssignedToPyramid.size())
	if(deadsAssignedToPyramid.size() >= deadsRequiredForPyramid):
		print("dead virou foda")
		body.is_dead_foda = true
		return
	body.is_inside_pyramid_area = true
	print("on body entered: ", body)
	deadsInArea.append(body)
	body.should_form_pyramid = true
	sortDeadsByDistance()

func verifyDeadsAlreadyInArea():
	for body in get_overlapping_bodies():
		if(deadsAssignedToPyramid.size() >= deadsRequiredForPyramid):
			print("dead virou foda")
			body.is_dead_foda = true
			return
		body.is_inside_pyramid_area = true
		print("already in area: ", body)
		deadsInArea.append(body)
		body.should_form_pyramid = true
	sortDeadsByDistance()

func _on_body_exited(body: Node3D) -> void:
	body.is_inside_pyramid_area = false

func sortDeadsByDistance() -> void:
	var origin := global_transform.origin
	deadsInArea.sort_custom(func(a, b):
		var distA := origin.distance_to(a.global_transform.origin)
		var distB := origin.distance_to(b.global_transform.origin)
		return distA < distB
	)

func getNextAvailablePoint():
	deadsInArea[0].pyramid_point_assigned = pyramidPoints[0]
	pointsAlreadyUsed.append(pyramidPoints[0])
	pyramidPoints.remove_at(0)
	deadsAssignedToPyramid.append(deadsInArea[0])
	deadsInArea.remove_at(0)
