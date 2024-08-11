extends Node

@export var initial_state : PlayerState

var current_state : PlayerState
var states : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is PlayerState:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			for children in child.get_children():
				if children is PlayerState:
					states[children.name.to_lower()] = children
					children.Transitioned.connect(on_child_transition)
	
	if initial_state:
		initial_state.Enter()
		current_state = initial_state
	
func _process(delta):
	if current_state:
		current_state.Update(delta)
	
	
func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):

	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	print(states)
	if current_state:
		if current_state.Exit():
			current_state.Exit()

	new_state.Enter()
	current_state = new_state
