extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		var spider_state = body.get_node_or_null("ActionStateMachine/Spider")
		if spider_state:
			spider_state.can_swing = true
			spider_state.swing_point = global_position

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		var spider_state = body.get_node_or_null("ActionStateMachine/Spider")
		if spider_state:
			spider_state.can_swing = false
