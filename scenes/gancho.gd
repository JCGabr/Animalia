'''extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var state: State = body.get_node("ActionStateMachine").current_state
		if state.name  == "Spider":
			state.can_swing = true
			state.swing_point = global_position
			

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		var state: State = body.get_node("ActionStateMachine").current_state
		if state.name == "Spider":
			state.can_swing = false

'''
extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		# Buscamos el nodo Spider dentro de la StateMachine
		var spider_state = body.get_node_or_null("ActionStateMachine/Spider")
		if spider_state:
			spider_state.can_swing = true
			spider_state.swing_point = global_position

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		var spider_state = body.get_node_or_null("ActionStateMachine/Spider")
		if spider_state:
			spider_state.can_swing = false
