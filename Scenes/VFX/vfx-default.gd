extends Node3D

@onready var particles: GPUParticles3D = $GPUParticles3D

func _ready() -> void:
	particles.emitting = false

func startVFX():
	particles.emitting = true

func stopVFX():
	particles.emitting = false
