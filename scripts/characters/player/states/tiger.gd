extends State

var local_speed: float = 300.0
var local_jump_velocity: float = -200.0

var dash_force: float = 1000

func enter() -> void:
	owner_node.animation_player.play("Transformation", -1, 2.5)
	await owner_node.animation_player.animation_finished
	owner_node.speed = local_speed
	owner_node.jump_velocity = local_jump_velocity
	owner_node.animation_player.play("Tiger_Idle")
	print("Transformation tiger")

func exit() -> void:
	print("No more tiger")
	owner_node.animation_player.play("Transformation")
	await get_tree().create_timer(2).timeout

func process(delta: float) -> void:
	if owner_node.mask_cooldown > 0:
		owner_node.mask_cooldown -= delta
	
	if owner_node.mask_cooldown <= 0:
		if Input.is_action_just_pressed("one"):
			owner_node.mask_cooldown = owner_node.cooldown_duration
			request_transition.emit("Human")
			
		if Input.is_action_just_pressed("two"):
			owner_node.mask_cooldown = owner_node.cooldown_duration
			request_transition.emit("Monkey")
			
		if Input.is_action_just_pressed("four"):
			owner_node.mask_cooldown = owner_node.cooldown_duration
			request_transition.emit("Spider")

func physics_process(_delta: float) -> void:
	pass
