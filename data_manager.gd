extends Node

var pathfinding_data = []
var pathfinding_distance = []

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("export"):
		await export_to_csv()
		get_tree().quit()

# Função para adicionar o tempo de pathfinding de um zumbi à list
func add_pathfinding_data(cpu_time, fps, memory_usage):
	pathfinding_data.append([cpu_time, fps, memory_usage])

func add_pathfinding_distance(total_distance_traveled):
	pathfinding_distance.append([total_distance_traveled])



# Função para exportar os dados para CSV (Godot 4.x)
func export_to_csv():
	var file_path = "user://pathfinding_data.csv"
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_line("Pathfinding Time (ms), FPS, Memory Usage (MB)")  # CSV header
		for data in pathfinding_data:
			if data.size() >= 3:  # Ensure there are at least 3 elements (cpu_time, fps, memory)
				file.store_line("%s, %s, %s" % [str(data[0]), str(data[1]), str(data[2])])  # Write cpu_time, fps, memory
			else:
				print("Invalid data format: ", data)
		file.close()
		print("Data exported to:", file_path)
		print("Full path:", ProjectSettings.globalize_path(file_path))
	else:
		print("Erro ao abrir o arquivo para escrita.")
		
	file_path = "user://pathfinding_distance.csv"
	file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_line("Pathfinding distance (units)")  # Write CSV header
		for distance in pathfinding_distance:
			file.store_line("%s" % str(distance))  # write distance traveled by agents"
		file.close()
		print("Data exported to:", file_path)
		print("Full path:", ProjectSettings.globalize_path(file_path))
	else:
		print("Erro ao abrir o arquivo para escrita.")

# Função para calcular a média dos tempos
func calculate_average_time():
	if pathfinding_data.size() == 0:
		return 0
	var total_time = 0
	for time in pathfinding_data:
		total_time += time
	return total_time / pathfinding_data.size()
