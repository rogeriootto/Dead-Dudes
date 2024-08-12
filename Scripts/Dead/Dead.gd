extends CharacterBody3D

var deadHp = 2
var tookHit = false
var isDead = false

func dealDamage(damage: int):
	deadHp -= damage
	print("Dead took " + str(damage) + " damage. HP: " + str(deadHp))
	if deadHp <= 0:
		isDead = true
	tookHit = true
	


func deadQueueFree():
	pass
