extends State

var local_speed: float = 100.0
var local_jump_velocity: float = -300.0
var slide_velocity: float = 30.0
var grab_on_cooldown: bool = false

var is_transforming: bool = false

# NUEVO
var wall_jump_buffer: float = 0.0
var wall_jump_buffer_time: float = 0.20

var coyote_wall_timer: float = 0.0
var coyote_wall_duration: float = 0.15

func enter() -> void:
	is_transforming = true
	
	owner_node.speed = local_speed
	owner_node.jump_velocity = local_jump_velocity
	
	owner_node.animation_player.stop()
	await get_tree().process_frame
	
	owner_node.animation_player.play("Transformation", -1, 2.5)
	await owner_node.animation_player.animation_finished
	
	owner_node.animation_player.play("Monkey_Idle")
	is_transforming = false
	print("Transformation monkey")

func exit() -> void:
	print("No more monkey")
	owner_node.is_grabbing = false

func process(delta: float) -> void:
	if owner_node.mask_cooldown > 0:
		owner_node.mask_cooldown -= delta
	
	if owner_node.mask_cooldown <= 0:
		if Input.is_action_just_pressed("one"):
			owner_node.mask_cooldown = owner_node.cooldown_duration
			request_transition.emit("Human")
		if Input.is_action_just_pressed("three"):
			owner_node.mask_cooldown = owner_node.cooldown_duration
			request_transition.emit("Tiger")
		if Input.is_action_just_pressed("four"):
			owner_node.mask_cooldown = owner_node.cooldown_duration
			request_transition.emit("Spider")

func physics_process(_delta: float) -> void:
	# NUEVO
	if wall_jump_buffer > 0:
		wall_jump_buffer -= _delta
		
		if not owner_node.is_on_floor():
			check_buffered_wall_jump()
	
	if coyote_wall_timer > 0:
		coyote_wall_timer -= _delta
	# NUEVO
			
	grab()
	if not is_transforming:
		update_animation()

# NUEVO
func check_buffered_wall_jump():
	if Input.is_action_just_pressed("jump"):
		wall_jump_buffer = wall_jump_buffer_time

func grab_old() -> void:
	var was_grabbing = owner_node.is_grabbing
	owner_node.is_grabbing = false
	
	
	for i in range(owner_node.get_slide_collision_count()):
		var c : KinematicCollision2D = owner_node.get_slide_collision(i)
		if abs(c.get_normal().x) > 0.6:
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
		

func grab() -> void:
	var was_grabbing = owner_node.is_grabbing
	owner_node.is_grabbing = false
	
	var wall_detected = false
	var wall_normal = Vector2.ZERO
	
	# Detectar pared
	for i in range(owner_node.get_slide_collision_count()):
		var c : KinematicCollision2D = owner_node.get_slide_collision(i)
		if abs(c.get_normal().x) > 0.6:
			wall_detected = true
			wall_normal = c.get_normal()
			coyote_wall_timer = coyote_wall_duration  # ✅ Reiniciar coyote time
			break
	
	# Si está en la pared O acaba de soltarse (coyote time)
	if wall_detected:
		owner_node.is_grabbing = true
		
		owner_node.velocity.y = lerp(owner_node.velocity.y, slide_velocity, 0.3)
		owner_node.velocity.x = lerp(owner_node.velocity.x, 0.0, 0.5)
		
		if not was_grabbing or owner_node.get_node("Sprite2D").flip_h != (wall_normal.x < 0):
			owner_node.get_node("Sprite2D").flip_h = wall_normal.x < 0
	
	# ✅ MEJORADO - Puede saltar si está agarrado O si acaba de soltar la pared
	if (wall_detected or coyote_wall_timer > 0) and Input.is_action_just_pressed("jump") and not grab_on_cooldown and not owner_node.is_on_floor():
		var jump_dir := Vector2(wall_normal.x, -1.0).normalized()
		owner_node.velocity = jump_dir * abs(owner_node.jump_velocity) * 1.2
		grab_on_cooldown = true
		owner_node.is_grabbing = false
		coyote_wall_timer = 0  # ✅ Consumir el coyote time
		start_cooldown()
		
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
