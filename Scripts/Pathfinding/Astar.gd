extends Node3D

@export var should_draw_cubes := false
var grid_is_built := false
const grid_step := 1.5 #size of the grid's cells

var astar = AStar3D.new()

var points := {}

var cube_mesh = BoxMesh.new()
var red_material = StandardMaterial3D.new()
var green_material = StandardMaterial3D.new()
var purple_material = StandardMaterial3D.new()
var golden_material = StandardMaterial3D.new()
var transparent_material = StandardMaterial3D.new()
var old_points = []
var player1Position = Vector3.ZERO
var player2Position = Vector3.ZERO

var obstacleDictionary = {"box1x1": preload("res://Assets/Models/Obstacles/box_small.tscn"), "policeCar": preload("res://Scenes/Objects/Obstacles/policeCar.tscn")}
var buildingShowObjectP1
var buildingShowObjectP2

func _ready():
	GlobalVariables.astarNode = self
	red_material.albedo_color = Color.RED
	green_material.albedo_color = Color.GREEN
	purple_material.albedo_color = Color.INDIGO
	golden_material.albedo_color = Color.GOLD
	transparent_material.albedo_color = Color(1,1,1,0.3)
	cube_mesh.size = Vector3(0.25, 0.25, 0.25)
	var pathables = get_tree().get_nodes_in_group("pathable")
	_make_grid(pathables)
	_connect_points()
	var obstacle_group = get_tree().get_nodes_in_group('obstacle')
	obstacle_group = sort_by_y(obstacle_group)
	_connect_obstacles(obstacle_group)
	grid_is_built = true
	SignalManager.registerListner('obstacleSpawnRequest', self, "_on_main_obstacle_should_spawn")
	SignalManager.registerListner('showObstacleToP1Request', self, "_on_main_obstacle_should_show_P1")
	SignalManager.registerListner('showObstacleToP2Request', self, "_on_main_obstacle_should_show_P2")
	SignalManager.registerListner('obstacleRemoveRequest', self, "_on_main_obstacle_should_remove")
	SignalManager.registerListner('moveObstacleRequest', self, "move_by_distance")

func _make_grid(pathables: Array):
	for pathable in pathables:
		var mesh = pathable.get_node("MeshInstance3D")
		var aabb: AABB = mesh.global_transform * mesh.get_aabb() 

		var start_point = aabb.position

		#talvez precise discretizar isso ja que eh usado pra iterar o proximo loop
		# o X e o Z steps dividem o chao para o grid
		#o y do nextpoint ta atrelado ao grid step, então o tamanho dos obstaculos tb tem q ser

		var x_steps = aabb.size.x / grid_step
		var z_steps = aabb.size.z / grid_step
		var y_height = aabb.size.y
		var offset_point = Vector3(grid_step/2, grid_step/2, grid_step/2)
		
		for x in x_steps:
#			for y in y_steps:
			for y in 5:
				for z in z_steps:
					var next_point = start_point + Vector3(x * grid_step, y_height + (y * grid_step), z * grid_step) + offset_point
					_add_point(next_point)
				
func _add_point(point: Vector3):
	var id = astar.get_available_point_id()
	#TODO peso do astar
	var astar_weight = 1 + ((point.y -0.5) * 2)

	astar.add_point(id, point, astar_weight)
	points[world_to_astar(point)] = id
	_create_nav_cube(scene_to_grid(point))

func _connect_points():
	for point in points:
		var pos_str = point.split(",")
		var world_pos := Vector3(float(pos_str[0]), float(pos_str[1]), float(pos_str[2]))
		var adjacent_points = _get_adjacent_points(world_pos)
		var current_id = points[point]
		if(world_pos[1] >= 3):
			astar.set_point_disabled(current_id,1)

		for neighbor_id in adjacent_points:
			if not astar.are_points_connected(current_id, neighbor_id):
				astar.connect_points(current_id, neighbor_id)
				if should_draw_cubes && not astar.is_point_disabled(current_id):
					get_child(current_id).material_override = green_material
#					get_child(neighbor_id).material_override = green_material

		# connects high points to low points allowing planned falls
		if world_pos[1] > 3.5:
			var adjacent_lower_points = _get_adjacent_lower_points(world_pos)
			for neighbor_id in adjacent_lower_points:
				if not astar.are_points_connected(current_id, neighbor_id):
					astar.connect_points(current_id, neighbor_id, false)

func _connect_obstacles(obstacle_group: Array):
	var obstacle_key = null
	var obstacle_id = null
	
	for obstacle in obstacle_group:
		obstacle.position = scene_to_grid(obstacle.position)
		obstacle_key = world_to_astar(obstacle.position)
		if points.has(obstacle_key):
			#conecta os tipos caixa. devem ser 1x1x1
			if obstacle.type == 'caixa':
				obstacle_id = points[obstacle_key]
				astar.set_point_disabled(obstacle_id,true)
				# obstacle.global_position = get_child(obstacle_id).global_position
				var pos_str = obstacle_key.split(",")
				var world_pos := Vector3(float(pos_str[0]), float(pos_str[1]), float(pos_str[2]))
				obstacle.global_position = world_pos
				
				if should_draw_cubes:
					get_child(obstacle_id).material_override = red_material
				var above_obstacle_key = world_to_astar(Vector3(obstacle.position.x, obstacle.position.y + grid_step, obstacle.position.z))
				var above_obstacle_id
				if points.has(above_obstacle_key):
					above_obstacle_id = points[above_obstacle_key]
					astar.set_point_disabled(above_obstacle_id,false)
					if should_draw_cubes:
						get_child(above_obstacle_id).material_override = green_material
		
			#conecta obstaculos maiores que 1x1x1
			else:
				var pos_str = obstacle_key.split(",")
				var world_pos := Vector3(float(pos_str[0]), float(pos_str[1]), float(pos_str[2]))
				obstacle.global_position = world_pos
				for eixo_x in obstacle.comprimento:
					for eixo_y in obstacle.altura:
						for eixo_z in obstacle.largura:
							var obstacle_node_key = world_to_astar(Vector3(obstacle.position.x + (grid_step * eixo_x), obstacle.position.y + (grid_step * eixo_y), obstacle.position.z + (grid_step * eixo_z)))
							if points.has(obstacle_node_key):
								obstacle_id = points[obstacle_node_key]
								astar.set_point_disabled(obstacle_id,true)
								if should_draw_cubes:
									get_child(obstacle_id).material_override = purple_material
							if eixo_y == obstacle.altura-1:
								var above_obstacle_key = world_to_astar(Vector3(obstacle.position.x + (grid_step * eixo_x), obstacle.position.y + (grid_step * (eixo_y+1)), obstacle.position.z + (grid_step * eixo_z)))
								var above_obstacle_id
								if points.has(above_obstacle_key):
									above_obstacle_id = points[above_obstacle_key]
									astar.set_point_disabled(above_obstacle_id,false)
									if should_draw_cubes:
										get_child(above_obstacle_id).material_override = golden_material

func _get_adjacent_points(world_point: Vector3) -> Array:
	var adjacent_points = []
	var search_coords = [-grid_step, 0, grid_step]
	for x in search_coords:
		for y in search_coords:
			for z in search_coords:
				var search_offset = Vector3(x, y, z)
				if search_offset == Vector3.ZERO:
					continue
				var potential_neighbor = world_to_astar(world_point + search_offset)
				if points.has(potential_neighbor):
					adjacent_points.append(points[potential_neighbor])
	return adjacent_points

func _get_adjacent_lower_points(world_point: Vector3) -> Array:
	
	var adjacent_lower_points = []
	var search_coords = [-grid_step, 0, grid_step]
	var height_coords = []
	var height = world_point[1]/grid_step
	while (height > 1):
		height = height - 1
		height_coords.append(height * (-grid_step))
	
	for y in height_coords:
		for x in search_coords:
			for z in search_coords:
				if x == 0 and z == 0:
					continue
				var search_offset = Vector3(x, y, z)
				var potential_neighbor = world_to_astar(world_point + search_offset)
				if points.has(potential_neighbor):
					adjacent_lower_points.append(points[potential_neighbor])
	return adjacent_lower_points

func find_path(from: Vector3, to: Vector3) -> Array:
	var start_id = astar.get_closest_point(from)
	var end_id = astar.get_closest_point(to)
	return astar.get_point_path(start_id, end_id)

func world_to_astar(world: Vector3) -> String:
	var x = snapped(world.x, grid_step)
	var y = snapped(world.y, grid_step)
	var z = snapped(world.z, grid_step)
	return "%.2f,%.2f,%.2f" % [x, y, z]

func scene_to_grid(obstaclePosition: Vector3):
	obstaclePosition.x = snapped(obstaclePosition.x, grid_step)
	obstaclePosition.y = snapped(obstaclePosition.y, grid_step)
	obstaclePosition.z = snapped(obstaclePosition.z, grid_step)
	if obstaclePosition.y < 1.5:
		obstaclePosition.y = 1.5
	return obstaclePosition

func _create_nav_cube(point_position: Vector3):
	if should_draw_cubes:
		var cube = MeshInstance3D.new()
		#TODO IF DO CARALHO
		if point_position.y < grid_step * 2:
			cube.mesh = cube_mesh
			cube.material_override = red_material
		#cube.mesh = cube_mesh
		#cube.material_override = red_material
		add_child(cube)
		#position.y = grid_y
		cube.global_transform.origin = point_position

func _on_main_obstacle_should_spawn(obstacleName: String, obstaclePosition: Vector3, player: Object):
	if obstacleDictionary[obstacleName] and obstaclePosition.y > 0:
		
		obstaclePosition = scene_to_grid(obstaclePosition)

		var point_key = world_to_astar(obstaclePosition)
		var obstacle_id
		var above_obstacle_key = world_to_astar(Vector3(obstaclePosition.x, obstaclePosition.y + grid_step, obstaclePosition.z))
		var above_obstacle_id
		
		if points.has(point_key):
			obstacle_id = points[point_key]
		else:
			return
		if points.has(above_obstacle_key):
			above_obstacle_id = points[above_obstacle_key]

		if not astar.is_point_disabled(obstacle_id) && player.playerInventory > 0:
			if(above_obstacle_id):
				if should_draw_cubes:
					get_child(above_obstacle_id).material_override = green_material
				astar.set_point_disabled(above_obstacle_id, false)
				
			var obstacle = obstacleDictionary[obstacleName].instantiate()
			var pos_str = point_key.split(",")
			var world_pos := Vector3(float(pos_str[0]), float(pos_str[1]), float(pos_str[2]))
			obstacle.global_position = world_pos
			add_child(obstacle)
			obstacle.add_to_group("obstacle")	
			astar.set_point_disabled(obstacle_id, true)
			player.removePlayerInventory()
			
			if should_draw_cubes:
				get_child(obstacle_id).material_override = red_material

func _on_main_obstacle_should_show_P1(showObjectFlag: bool, obstacleName: String, obstaclePosition: Vector3):
	if !buildingShowObjectP1:
		buildingShowObjectP1 = obstacleDictionary[obstacleName].instantiate()
		buildingShowObjectP1.get_node("InteractionArea").can_interact = false
		add_child(buildingShowObjectP1)
		buildingShowObjectP1.get_node("CollisionShape3D").disabled = true

		transparent_material.albedo_texture = buildingShowObjectP1.get_node("MeshInstance3D").material_override.albedo_texture
		transparent_material.albedo_color = Color(0,0,0,0.1)
		buildingShowObjectP1.get_node("MeshInstance3D").material_override = transparent_material

	if showObjectFlag:
		obstaclePosition.x = snapped(obstaclePosition.x, grid_step)
		obstaclePosition.y = snapped(obstaclePosition.y, grid_step)
		obstaclePosition.z = snapped(obstaclePosition.z, grid_step)
		if obstaclePosition.y < 1:
			obstaclePosition.y = 1.5
		buildingShowObjectP1.position = obstaclePosition
	else:
		buildingShowObjectP1.queue_free()

func _on_main_obstacle_should_show_P2(showObjectFlag: bool, obstacleName: String, obstaclePosition: Vector3):
	if !buildingShowObjectP2:
		buildingShowObjectP2 = obstacleDictionary[obstacleName].instantiate()
		buildingShowObjectP2.get_node("InteractionArea").can_interact = false
		add_child(buildingShowObjectP2)
		buildingShowObjectP2.get_node("CollisionShape3D").disabled = true

		transparent_material.albedo_texture = buildingShowObjectP2.get_node("MeshInstance3D").material_override.albedo_texture
		transparent_material.albedo_color = Color(0,0,0,0.1)
		buildingShowObjectP2.get_node("MeshInstance3D").material_override = transparent_material

	if showObjectFlag:
		obstaclePosition.x = snapped(obstaclePosition.x, grid_step)
		obstaclePosition.y = snapped(obstaclePosition.y, grid_step)
		obstaclePosition.z = snapped(obstaclePosition.z, grid_step)
		if obstaclePosition.y < 1:
			obstaclePosition.y = 1.5
		buildingShowObjectP2.position = obstaclePosition
	else:
		buildingShowObjectP2.queue_free()

func _on_main_obstacle_should_remove(obstacle: StaticBody3D, player: Object):

	var obstaclePosition = obstacle.global_position
	var point_key = world_to_astar(obstaclePosition)
	var obstacle_id

	if points.has(point_key):
		obstacle_id = points[point_key]
	else:
		return

	var above_obstacle_key = world_to_astar(Vector3(obstaclePosition.x, obstaclePosition.y + grid_step, obstaclePosition.z))
	var above_obstacle_id

	if points.has(above_obstacle_key):
		above_obstacle_id = points[above_obstacle_key]
		if astar.is_point_disabled(above_obstacle_id):
			return

	if !player:
		return
	if astar.is_point_disabled(obstacle_id) && player.playerInventory < player.playerMaxInventorySpace:
		if(above_obstacle_id):
			if should_draw_cubes:
				get_child(above_obstacle_id).material_override = red_material
			astar.set_point_disabled(above_obstacle_id, true)
		astar.set_point_disabled(obstacle_id, false)
		if should_draw_cubes:
			get_child(obstacle_id).material_override = purple_material
		obstacle.queue_free()
		player.addPlayerInventory()

func _get_obstacle_adjacent_points(world_point: Vector3) -> Array:
	
	var adjacent_points = []
	var search_coords = [-grid_step, 0, grid_step]
	for x in search_coords:
		for y in search_coords:
			for z in search_coords:
				var search_offset = Vector3(x, y, z)
				if search_offset == Vector3.ZERO:
					continue
				var potential_neighbor = world_to_astar(world_point + search_offset)
				if points.has(potential_neighbor):
					if not astar.is_point_disabled(points[potential_neighbor]):
						adjacent_points.append(points[potential_neighbor])
	return adjacent_points

func sort_by_y(arrayToSort: Array):
	var _compare_y_position = func(a, b):
		return a.position.y < b.position.y
	arrayToSort.sort_custom(_compare_y_position)
	return arrayToSort

func move_by_distance(obstacle: Object, should_reconect_points: bool, playerNumber: String):
	var obstaclePosition = obstacle.global_position
	var point_key = world_to_astar(Vector3(obstaclePosition.x + obstacle.comprimento * grid_step, obstaclePosition.y, obstaclePosition.z + obstacle.largura))
	var obstacle_id
	
	if points.has(point_key):
		obstacle_id = points[point_key]
	else:
		return

	if self.old_points.size() != 0:
		var speed = 2.0
		var velocity = Vector3.ZERO
		var move_direction = Vector3.ZERO

		move_direction.x = Input.get_action_strength("right_" + playerNumber) - Input.get_action_strength("left_" + playerNumber)
		move_direction.z = Input.get_action_strength("down_"  + playerNumber) - Input.get_action_strength("up_" + playerNumber)

		velocity.x = move_direction.x * speed
		velocity.z = move_direction.z * speed

		obstacle.velocity = velocity
		obstacle.move_and_slide()
		
	
	if should_reconect_points:
		if self.old_points.size() != 0:
			for old_point_key in self.old_points:
				if points.has(old_point_key):
					var pos_str = old_point_key.split(",")
					var world_pos := Vector3(float(pos_str[0]), float(pos_str[1]), float(pos_str[2]))
					#TODO vai dar ruim em algum ponto acho	
					if world_pos[1] <= grid_step:
						astar.set_point_disabled(points[old_point_key], false)
						if should_draw_cubes:
							get_child(points[old_point_key]).material_override = green_material
					elif not astar.is_point_disabled(points[old_point_key]):
						astar.set_point_disabled(points[old_point_key], true)
						if should_draw_cubes:
							get_child(points[old_point_key]).material_override = red_material
					
			self.old_points = []

		for eixo_x in obstacle.comprimento:
			for eixo_y in obstacle.altura + 1:
				for eixo_z in obstacle.largura:
					#salva os velhos
					self.old_points.append(world_to_astar(Vector3(obstacle.position.x + (grid_step * eixo_x), obstacle.position.y + (grid_step * eixo_y), obstacle.position.z + (grid_step * eixo_z))))
					
					#reconecta os pontos
					if eixo_y < obstacle.altura:
						var obstacle_node_key = world_to_astar(Vector3(obstacle.position.x + (grid_step * eixo_x), obstacle.position.y + (grid_step * eixo_y), obstacle.position.z + (grid_step * eixo_z)))
						if points.has(obstacle_node_key):
							obstacle_id = points[obstacle_node_key]
							astar.set_point_disabled(obstacle_id,true)
							if should_draw_cubes:
								get_child(obstacle_id).material_override = purple_material
						if eixo_y == obstacle.altura-1:
							var above_obstacle_key = world_to_astar(Vector3(obstacle.position.x + (grid_step * eixo_x), obstacle.position.y + (2 * grid_step * eixo_y), obstacle.position.z + (grid_step * eixo_z)))
							var above_obstacle_id
							if points.has(above_obstacle_key):
								above_obstacle_id = points[above_obstacle_key]
								astar.set_point_disabled(above_obstacle_id,false)
								if should_draw_cubes:
									get_child(above_obstacle_id).material_override = golden_material

func dead_should_fall(dead_position: Vector3):
	dead_position = scene_to_grid(dead_position)
	var point_key = world_to_astar(dead_position)
	var point_id
	var above_dead_key = world_to_astar(Vector3(dead_position.x, dead_position.y + grid_step, dead_position.z))
	var above_dead_id
	
	if points.has(point_key):
		point_id = points[point_key]
	else:
		return
	if points.has(above_dead_key):
		above_dead_id = points[above_dead_key]

	if not astar.is_point_disabled(point_id):
		if(above_dead_id):
			if should_draw_cubes:
				get_child(above_dead_id).material_override = green_material
			astar.set_point_disabled(above_dead_id, false)
	astar.set_point_disabled(point_id, true)
	if should_draw_cubes:
		get_child(point_id).material_override = red_material
	return dead_position
