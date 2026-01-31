extends Node
class_name State

@warning_ignore("unused_signal")
signal request_transition(state_name: String)

var owner_node: Node

func enter() -> void:
	pass

func exit() -> void:
	pass

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass
