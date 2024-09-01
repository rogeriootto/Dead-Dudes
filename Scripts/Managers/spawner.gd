extends Node3D

@onready var SpawnPoint: Node3D = $Node3D
@export var timeBetweenSpawns: float = 3.0
@export var mainSceneNode: Node3D
var turnOn = false
var timer := 0.0
var deads = [preload("res://Scenes/Objects/dead_1.tscn"), preload("res://Scenes/Objects/dead_2.tscn"), preload("res://Scenes/Objects/dead_3.tscn")]

func _ready() -> void:
	turnOn = false

func _process(delta: float) -> void:
	if turnOn && timer >= timeBetweenSpawns:
		var deadInstance = deads[randi() % deads.size()].instantiate()
		mainSceneNode.add_child(deadInstance)
		deadInstance.global_transform.origin = SpawnPoint.global_transform.origin
		timer = 0.0
	timer += delta

func _on_body_entered(body: Node3D) -> void:
	turnOn = true

func _on_body_exited(body: Node3D) -> void:
	turnOn = false
