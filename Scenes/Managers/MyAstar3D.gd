class_name MyAStar3D
extends AStar3D

func _compute_cost(u, v):
	var u_pos = get_point_position(u)
	var v_pos = get_point_position(v)
	return abs(u_pos.x - v_pos.x) + abs(u_pos.y - v_pos.y) + abs(u_pos.z - v_pos.z)

func _estimate_cost(u, v):
	var a = get_point_position(u)
	var b = get_point_position(v)

	var dx = abs(a.x - b.x)
	var dy = abs(a.y - b.y)
	var dz = abs(a.z - b.z)

	return max(dx, dy, dz)
