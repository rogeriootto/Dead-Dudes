extends Node3D

@onready var animPlayer = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animPlayer.play("Walking", -1)
	pass # Replace with function body.
