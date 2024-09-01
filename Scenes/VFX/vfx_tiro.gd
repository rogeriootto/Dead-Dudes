extends Node3D

@onready var particula = $GPUParticles3D

func _ready() -> void:
	self.visible = false

func startTiro():
	self.visible = true
	particula.emitting = true
	
func endTiro():
	particula.emitting = false
	
func turnOffTiro():
	self.visible = false
