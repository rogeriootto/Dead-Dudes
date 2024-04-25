extends Node3D

@onready var nav = get_parent().get_node("Astar")
@onready var jack = get_parent().get_node("Jack")
@onready var zombo = get_parent().get_node("Zombo")

var count = 0

func _physics_process(_delta):
	if(count >= 30):
		zombo.update_path(nav.find_path(zombo.global_transform.origin, jack.global_transform.origin))
#		jack.global_transform.origin = zombo.global_transform.origin
		count = 0	
	count += 1
