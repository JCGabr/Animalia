extends State
var local_speed: float = 100.0
var local_jump_velocity: float = -200.0

func enter() -> void:
	owner_node.speed = local_speed
	owner_node.jump_velocity = local_jump_velocity
	
	owner_node.animation_player.play("Transformation", -1, 2.5)
	await owner_node.animation_player.animation_finished
	
	owner_node.animation_player.play("Human_Idle")
	print("Transformation human")

func exit() -> void:
	print("No more human")

func process(delta: float) -> void:
	if owner_node.mask_cooldown > 0:
		owner_node.mask_cooldown -= delta
	
	if owner_node.mask_cooldown <= 0:
		if Input.is_action_just_pressed("two"):
			owner_node.mask_cooldown = owner_node.cooldown_duration
			request_transition.emit("Monkey")
			owner_node.animation_player.play("Human_Mask",-1,3.5)
			await owner_node.animation_player.animation_finished
			owner_node.animation_player.play("Human_Mask_Monkey",-1,2)
			#await owner_node.animation_player.animation_finished
			
		if Input.is_action_just_pressed("three"):
			owner_node.mask_cooldown = owner_node.cooldown_duration
			request_transition.emit("Tiger")
			owner_node.animation_player.play("Human_Mask",-1,3.5)
			await owner_node.animation_player.animation_finished
			owner_node.animation_player.play("Human_Mask_Tiger",-1,2)
			#await owner_node.animation_player.animation_finished
			
		if Input.is_action_just_pressed("four"):
			owner_node.mask_cooldown = owner_node.cooldown_duration
			request_transition.emit("Spider")
			owner_node.animation_player.play("Human_Mask",-1,3.5)
			await owner_node.animation_player.animation_finished
			owner_node.animation_player.play("Human_Mask_Spider",-1,2)
			#await owner_node.animation_player.animation_finished

func physics_process(_delta: float) -> void:
	pass
