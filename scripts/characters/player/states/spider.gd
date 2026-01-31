extends State

var local_speed: float = 100.0
var local_jump_velocity: float = -200.0
var can_swing: bool = false
var used_swing: bool = false
var swing_point: Vector2
var swing_force: float = 300.0
var is_swinging: bool = false
var web_line: Line2D

var is_transforming: bool = false

func enter() -> void:
	is_transforming = true
	
	owner_node.speed = local_speed
	owner_node.jump_velocity = local_jump_velocity
	
	owner_node.animation_player.stop()
	await get_tree().process_frame
	
	owner_node.animation_player.play("Transformation", -1, 2.5)
	await owner_node.animation_player.animation_finished
	
	is_transforming = false
	owner_node.animation_player.play("Spider_Idle")
	print("Transformation spider")
	
	if not web_line:
		web_line = Line2D.new()
		web_line.width = 2.0
		web_line.default_color = Color(0.9, 0.9, 0.9, 0.8)
		web_line.z_index = -1
		web_line.top_level = true
		owner_node.add_child(web_line)

func exit() -> void:
	if web_line and is_instance_valid(web_line):
		web_line.queue_free()
		web_line = null
	
	is_swinging = false
	used_swing = false
	can_swing = false
	
	owner_node.rotation = 0

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
		
		if Input.is_action_just_pressed("three"):
			owner_node.mask_cooldown = owner_node.cooldown_duration
			request_transition.emit("Tiger")
	
	update_web_visual()

func swing() -> void:
	# Solo permitimos el impulso si can_swing es true y presionas saltar
	if can_swing && Input.is_action_just_pressed("jump"):
		var direction = (swing_point - owner_node.global_position).normalized()
		
		# Aplicamos el impulso (aumenté un poco el swing_force para que se note)
		owner_node.velocity = direction * (swing_force * 1.5)
		
		used_swing = true
		is_swinging = true # Esto mantendrá la telaraña dibujada

func update_web_visual() -> void:
	if web_line:
		# IMPORTANTE: Eliminamos 'can_swing' de la condición aquí. 
		# Queremos que la telaraña se vea mientras dure el impulso (is_swinging),
		# aunque ya hayamos salido del área del gancho.
		if is_swinging:
			web_line.clear_points()
			web_line.add_point(owner_node.global_position)
			web_line.add_point(swing_point)
			
			# Si estamos muy cerca del punto, cortamos el hilo visual
			if owner_node.global_position.distance_to(swing_point) < 20:
				is_swinging = false
		else:
			web_line.clear_points()

func physics_process(delta: float) -> void:
	if not owner_node.is_on_floor():
		swing()
		# Solo rotamos si estamos impulsándonos
		if is_swinging:
			update_swing_rotation()
	else:
		# Al tocar el suelo, reseteamos todo
		is_swinging = false
		used_swing = false
		owner_node.rotation = lerp(owner_node.rotation, 0.0, 10.0 * delta)
	
	if not is_transforming:
		update_animation()

func update_swing_rotation() -> void:
	if is_swinging && can_swing:
		var direction = swing_point - owner_node.global_position
		var angle = direction.angle() + PI / 2 
		
		owner_node.rotation = lerp_angle(owner_node.rotation, angle, 0.3)
		
'''
func physics_process(delta: float) -> void:
	if not owner_node.is_on_floor():
		swing()
		update_swing_rotation()
	else:
		is_swinging = false
		owner_node.rotation = lerp(owner_node.rotation, 0.0, 10.0 * delta)
	
	if owner_node.is_on_floor() && used_swing == true:
		owner_node.velocity.x = 0
		used_swing = false
	
	if not is_transforming:
		update_animation()
		
func swing() -> void:
	if can_swing && Input.is_action_just_pressed("jump"):
		var direction = (swing_point - owner_node.global_position).normalized()
		owner_node.velocity = direction * swing_force
		used_swing = true
		is_swinging = true

func update_web_visual() -> void:
	if web_line:
		if is_swinging && can_swing:
			web_line.clear_points()
			web_line.add_point(owner_node.global_position)
			web_line.add_point(swing_point)
		else:
			web_line.clear_points()
'''

func update_animation() -> void:
	if owner_node.is_on_floor():
		if abs(owner_node.velocity.x) > 10:
			if owner_node.animation_player.current_animation != "Spider_Walk":
				owner_node.animation_player.play("Spider_Walk")
		else:
			if owner_node.animation_player.current_animation != "Spider_Idle":
				owner_node.animation_player.play("Spider_Idle")
	else:
		if owner_node.velocity.y < 0: 
			if owner_node.animation_player.current_animation != "Spider_Jump":
				owner_node.animation_player.play("Spider_Jump")
		else:
			if owner_node.animation_player.current_animation != "Spider_Fall":
				owner_node.animation_player.play("Spider_Fall")

func roof_climbing(delta: float) -> void:
	for i in range(owner_node.get_slide_collision_count()):
		var c : KinematicCollision2D = owner_node.get_slide_collision(i)
		if c.get_normal().y < -0.7:
			if Input.is_action_pressed("jump"):
				owner_node.velocity -= owner_node.get_gravity() * delta
