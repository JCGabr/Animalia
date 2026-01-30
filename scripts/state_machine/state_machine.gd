extends Node
class_name StateMachine

@export var initial_state: State
@export var owner_node: Node

var current_state: State
var states: Dictionary = {}

signal transition(state_name: String)

func _ready() -> void:
	await get_tree().process_frame
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.owner_node = owner_node

	if initial_state:
		_change_state(initial_state.name)


func _on_state_request_transition(state_name: String) -> void:
	_change_state(state_name)

func _change_state(state_name: String) -> void:
	if not states.has(state_name):
		push_warning("State %s no existe" % state_name)
		return

	if current_state:
		current_state.exit()

	current_state = states[state_name]
	current_state.enter()
	transition.emit(state_name)


func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)
	owner_node.move_and_slide()
