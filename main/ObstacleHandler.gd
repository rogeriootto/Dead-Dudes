extends Node3D

signal obstacle_should_spawn
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("left_click"):
		emit_signal("obstacle_should_spawn")
