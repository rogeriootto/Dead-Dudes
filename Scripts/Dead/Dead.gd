extends CharacterBody3D

var deadHp = 2
var tookHit:bool = false
var isDead:bool = false
var should_update_path:bool = false
var count_fallen:float = 0

func dealDamage(damage: int):

	deadHp -= damage

	if deadHp <= 0:
		isDead = true
	tookHit = true

func deadQueueFree():
	pass
