extends Node3D

@onready var particles: GPUTrail3D = $GPUTrail3D

func startVFX():
	self.visible = true

func stopVFX():
	self.visible = false
