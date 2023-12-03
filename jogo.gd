extends Node2D

var p1Score = 0
var p2Score = 0
var pointp1SFX
var pointp2SFX

func _ready():
	pointp1SFX = $point1sfx
	pointp2SFX = $point2sfx

func _process(_delta):
	$Label.text = str(p1Score)
	$Label2.text = str(p2Score)

func _on_top_body_entered(body):
	body.direction.y *= -1

func _on_bottom_body_entered(body):
	body.direction.y *= -1

func _on_left_body_entered(body):
	body.queue_free()
	var e = preload("res://ball.tscn").instantiate()
	e.global_position = Vector2.ZERO
	add_child(e)
	p2Score += 1
	pointp2SFX.play()

func _on_right_body_entered(body):
	body.queue_free()
	var e = preload("res://ball.tscn").instantiate()
	e.global_position = Vector2.ZERO
	add_child(e)
	p1Score += 1
	pointp1SFX.play()
	
