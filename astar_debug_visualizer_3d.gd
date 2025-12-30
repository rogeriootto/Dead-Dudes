extends Node3D

@export var step_delay := 0.02

var expansion: Array = []
var get_pos: Callable

var mesh := ImmediateMesh.new()
var mesh_instance: MeshInstance3D
var playing := false

func _ready():
	mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	add_child(mesh_instance)

func setup(expansion_data: Array, position_resolver: Callable) -> void:
	expansion = expansion_data
	get_pos = position_resolver

func animate() -> void:
	if expansion.is_empty() or not get_pos.is_valid():
		playing = false
		return

	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)

	var h_min := INF
	var h_max := -INF
	for e in expansion:
		if not e.has("h"):
			continue
		h_min = min(h_min, e["h"])
		h_max = max(h_max, e["h"])

	for e in expansion:
		var parent_id = e.get("parent", -1)
		if parent_id == -1:
			continue

		var from_pos: Vector3 = get_pos.call(parent_id)
		var to_pos: Vector3 = get_pos.call(e["id"])

		var t := 0.0
		if h_max > h_min:
			t = (e["h"] - h_min) / (h_max - h_min)

		var color := Color(1.0 - t, t, 0.0)

		mesh.surface_set_color(color)
		mesh.surface_add_vertex(from_pos)
		mesh.surface_add_vertex(to_pos)

		await get_tree().create_timer(step_delay).timeout

	mesh.surface_end()
	playing = false

func play():
	if playing:
		return
	playing = true
	animate()
