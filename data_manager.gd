extends Node

var pathfinding_times = []


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("export"):
		await export_to_csv()
		get_tree().quit()

# Função para adicionar o tempo de pathfinding de um zumbi à lista
func add_pathfinding_time(time):
	pathfinding_times.append(time)

# Função para exportar os dados para CSV (Godot 4.x)
func export_to_csv():
	var file = FileAccess.open("user://pathfinding_times.csv", FileAccess.WRITE)
	if file:
		file.store_line("Pathfinding Time (ms)")  # Cabeçalho CSV
		for time in pathfinding_times:
			file.store_line(str(time))  # Escreve cada tempo no arquivo
		file.close()
		print("Dados exportados para pathfinding_times.csv")
	else:
		print("Erro ao abrir o arquivo para escrita.")

# Função para calcular a média dos tempos
func calculate_average_time():
	if pathfinding_times.size() == 0:
		return 0
	var total_time = 0
	for time in pathfinding_times:
		total_time += time
	return total_time / pathfinding_times.size()
