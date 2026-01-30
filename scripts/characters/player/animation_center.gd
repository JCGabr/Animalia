extends Node

@export var animation_tree: AnimationTree
@export var movement_state_machine: Node
@export var action_state_machine: Node

var playback_movement_state_machine: AnimationNodeStateMachinePlayback
var playback_action_state_machine: AnimationNodeStateMachinePlayback

var current_movement_state: String
var current_action_state: String

func _ready() -> void:
	playback_movement_state_machine = animation_tree.get("parameters/MovementSM/playback")
	playback_action_state_machine = animation_tree.get("parameters/ActionSM/playback")

func _on_movement_state_machine_transition(state_name: String) -> void:
	current_movement_state = state_name
	playback_movement_state_machine.travel(state_name)

func _on_action_state_machine_transition(state_name: String) -> void:
	current_action_state = state_name
	playback_action_state_machine.travel(state_name)
