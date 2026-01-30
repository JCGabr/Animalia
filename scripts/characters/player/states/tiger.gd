extends State

var local_speed: float = 300.0
var local_jump_velocity: float = -200.0

var dash_force: float = 1000

func enter() -> void:
	owner_node.speed = local_speed
	owner_node.jump_velocity = local_jump_velocity
	owner_node.animation_player.play("Tiger_Idle")
	print("Transformation tiger")

func exit() -> void:
	print("No more tiger")

func process(_delta: float) -> void:
	if Input.is_action_just_pressed("one"):
		request_transition.emit("Human")
		
	if Input.is_action_just_pressed("two"):
		request_transition.emit("Monkey")
		
	if Input.is_action_just_pressed("four"):
		request_transition.emit("Spider")

func physics_process(_delta: float) -> void:
	pass
