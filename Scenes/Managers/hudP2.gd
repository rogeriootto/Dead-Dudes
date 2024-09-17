extends HBoxContainer

func _ready() -> void:
	if !GlobalVariables.p2ShouldSpawn:
		visible = false
