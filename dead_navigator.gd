extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D  # Reference to the NavigationAgent3D

var player: Node3D = null
var max_speed = 6
var start_time: float = 0.0
var end_time: float = 0.0
var previous_position: Vector3
var total_distance_walked: float = 0.0

func _ready():
	# Connect the "path_calculated" signal using a Callable
	if nav_agent.connect("path_calculated", Callable(self, "_on_path_calculated")):
		print("Signal connected successfully")
	else:
		print("Failed to connect signal")
	nav_agent.connect("path_calculated", Callable(self, "_debug_on_path_calculated"))
	# Initialize the previous position as the agent's starting position
	previous_position = global_transform.origin

	nav_agent.velocity = Vector3.ZERO
	nav_agent.max_speed = max_speed
	nav_agent.set_navigation_layers(1)

	# Try to find the player when the scene starts
	find_player()

func request_path(target_position: Vector3):
	# Capture the time when the pathfinding starts.
	start_time = Time.get_ticks_msec()
	nav_agent.set_target_position(target_position)

func _on_path_calculated():
	# Capture the time when the pathfinding completes.
	end_time = Time.get_ticks_msec()
	var elapsed_time = end_time - start_time
	print("Pathfinding took ", elapsed_time, " ms")
	

func find_player():
	# Check if there's any player in the "player" group
	var players = get_tree().get_nodes_in_group("players")
	if players.size() > 0:
		player = players[0]  # We assume there's only one player
		print("Player found!")
	else:
		print("Player not found, will try again...")

func _physics_process(delta):
	if player:
		move_to_player(delta)
	else:
		find_player()  # Try to find the player every frame if it's not set
			
	# Calculate the distance walked between frames
	var current_position = global_transform.origin
	var distance_this_frame = previous_position.distance_to(current_position)
	# Accumulate the total distance walked
	total_distance_walked += distance_this_frame
	# Update the previous position for the next frame
	previous_position = current_position
	#print("Total distance walked: ", total_distance_walked)
	
	if nav_agent.get_current_navigation_path().size() > 0:
		# Capture the time after the path has been calculated
		end_time = Time.get_ticks_msec()
		var execution_time = end_time - start_time
		#print("Tempo de Execução: ", execution_time, " ms")
		var fps = Engine.get_frames_per_second()
		# Adicionar o tempo ao gerenciador (PathfindingData.gd)
		DataManager.add_pathfinding_data(execution_time, fps)
		# Now stop checking to avoid printing this every frame
		set_process(false)
		
func move_to_player(delta):
	# Capture o tempo antes de iniciar o cálculo do caminho
	var player_position = player.global_transform.origin
	start_time = Time.get_ticks_msec()
	nav_agent.set_target_position(player_position)
	
	if not nav_agent.is_navigation_finished():
		follow_path(delta)
	else:
		print("agent got to player")
		velocity = Vector3.ZERO
		DataManager.add_pathfinding_distance(total_distance_walked)
		await DataManager.export_to_csv()
		get_tree().quit()

func follow_path(delta):
	var next_position = nav_agent.get_next_path_position()
	var direction = (next_position - global_transform.origin).normalized()
	var movement = direction * max_speed

	velocity = movement
	move_and_slide()
