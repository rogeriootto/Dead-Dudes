extends Node3D

signal obstacle_should_spawn

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("left_click"):
		
		
		emit_signal("obstacle_should_spawn")
