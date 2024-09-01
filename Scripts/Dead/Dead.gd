extends CharacterBody3D

var deadHp = 2
var tookHit:bool = false
var isDead:bool = false
var should_update_path:bool = false
var count_fallen:float = 0
var should_activate_zombie:bool = false
var path := []

func _ready() -> void:
	should_activate_zombie = false
	
func dealDamage(damage: int):

	deadHp -= damage

	if deadHp <= 0:
		isDead = true
	tookHit = true

func deadQueueFree():
	pass
