extends Node3D

signal obstacle_should_spawn
signal obstacle_should_explode

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("left_click"):	
		emit_signal("obstacle_should_spawn")
	if Input.is_action_just_pressed("right_click"):
		emit_signal("obstacle_should_explode")
