extends Camera3D

@export var offset : Vector3
var changeSceneState : bool
@export var speed : float = 6.0
@export var mouse_sensitivity := 0.2

var rotation_x := 0.0
var rotation_y := 0.0

@export var player1 : CharacterBody3D
@export var player2 : CharacterBody3D

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
    if event is InputEventMouseMotion:
        rotation_y -= event.relative.x * mouse_sensitivity
        rotation_x -= event.relative.y * mouse_sensitivity
        rotation_x = clamp(rotation_x, -90, 90)
        rotation_degrees = Vector3(rotation_x, rotation_y, 0)

func _process(delta):
    var direction = Vector3.ZERO
    if Input.is_action_pressed("cameraForward"):
        direction -= transform.basis.z
    if Input.is_action_pressed("cameraBackward"):
        direction += transform.basis.z
        
    if direction != Vector3.ZERO:
        global_position += direction.normalized() * speed * delta

    if Input.is_key_pressed(KEY_ESCAPE):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


