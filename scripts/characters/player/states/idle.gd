extends State


func enter() -> void:
	if not owner_node.is_grabbing:
		owner_node.animation_player.play(owner_node.action_state_machine.current_state.name + "_Idle")

func exit() -> void:
	pass
	
func process(_delta: float) -> void:
	if Input.get_axis("left", "right") != 0:
		request_transition.emit("Walk")
