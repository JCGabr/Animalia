extends State

var local_speed: float = 100.0
var local_jump_velocity: float = -300.0
var slide_velocity: float = 40.0
var grab_on_cooldown: bool = false

func enter() -> void:
	owner_node.speed = local_speed
	owner_node.jump_velocity = local_jump_velocity
	owner_node.animation_player.play("Monkey_Idle")
	print("Transformation monkey")

func exit() -> void:
	print("No more monkey")
	owner_node.is_grabbing = false  # 👈 Limpiar al salir

func process(_delta: float) -> void:
	if Input.is_action_just_pressed("one"):
		request_transition.emit("Human")
	if Input.is_action_just_pressed("three"):
		request_transition.emit("Tiger")
	if Input.is_action_just_pressed("four"):
		request_transition.emit("Spider")

func physics_process(_delta: float) -> void:
	grab()
	update_animation()

func grab() -> void:
	var was_grabbing = owner_node.is_grabbing
	owner_node.is_grabbing = false
	
	for i in range(owner_node.get_slide_collision_count()):
		var c : KinematicCollision2D = owner_node.get_slide_collision(i)
		if abs(c.get_normal().x) > 0.7:
			owner_node.is_grabbing = true
			owner_node.velocity.y = min(owner_node.velocity.y, slide_velocity)
			owner_node.velocity.x = 0
			
			if not was_grabbing or owner_node.get_node("Sprite2D").flip_h != (c.get_normal().x < 0):
				owner_node.get_node("Sprite2D").flip_h = c.get_normal().x < 0
			
			if Input.is_action_just_pressed("jump") and not grab_on_cooldown and not owner_node.is_on_floor():
				var jump_dir := Vector2(c.get_normal().x, -1.0).normalized()
				owner_node.velocity = jump_dir * -owner_node.jump_velocity
				grab_on_cooldown = true
				owner_node.is_grabbing = false
				start_cooldown()
			break

func update_animation() -> void:
	if owner_node.is_grabbing:
		if owner_node.animation_player.current_animation != "Monkey_Climb":
			owner_node.animation_player.play("Monkey_Climb")
	elif owner_node.is_on_floor():
		if abs(owner_node.velocity.x) > 10:
			if owner_node.animation_player.current_animation != "Monkey_Walk":
				owner_node.animation_player.play("Monkey_Walk")
		else:
			if owner_node.animation_player.current_animation != "Monkey_Idle":
				owner_node.animation_player.play("Monkey_Idle")
	else:
		if owner_node.velocity.y < 0: 
			if owner_node.animation_player.current_animation != "Monkey_Jump":
				owner_node.animation_player.play("Monkey_Jump")
		else:
			if owner_node.animation_player.current_animation != "Monkey_Fall":
				owner_node.animation_player.play("Monkey_Fall")

func start_cooldown() -> void:
	await get_tree().create_timer(0.35).timeout
	grab_on_cooldown = false
