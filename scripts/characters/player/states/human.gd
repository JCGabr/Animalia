extends State

var local_speed: float = 100.0
var local_jump_velocity: float = -200.0

func enter() -> void:
	owner_node.speed = local_speed
	owner_node.jump_velocity = local_jump_velocity
	owner_node.animation_player.play("Human_Idle")
	print("Transformation human")

func exit() -> void:
	print("No more human")

func process(_delta: float) -> void:
	if Input.is_action_just_pressed("two"):
		request_transition.emit("Monkey")
		
	if Input.is_action_just_pressed("three"):
		request_transition.emit("Tiger")
		
	if Input.is_action_just_pressed("four"):
		request_transition.emit("Spider")

func physics_process(_delta: float) -> void:
	pass
