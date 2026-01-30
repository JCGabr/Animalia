extends State

func enter() -> void:
	if not owner_node.is_grabbing:
		owner_node.animation_player.play(owner_node.action_state_machine.current_state.name + "_Walk")
	
func exit() -> void:
	pass

func body_move(_delta: float) -> bool:
	var direction : float = Input.get_axis("left", "right")
	
	if direction:
		owner_node.velocity.x = direction * owner_node.speed
		
		if not owner_node.is_grabbing:
			owner_node.get_node("Sprite2D").flip_h = direction < 0
	else:
		owner_node.velocity.x = move_toward(owner_node.velocity.x, 0, owner_node.speed)
	
	return direction != 0
			
func physics_process(delta: float) -> void:
	if not body_move(delta):
		request_transition.emit("Idle")
	owner_node.move_and_slide()
