extends CharacterBody2D

var speed = 100.0
var jump_velocity = -200.0

@export var animation_player: AnimationPlayer
@export var movement_state_machine: StateMachine
@export var action_state_machine: StateMachine

var coyote_timer: float = 0.0
@export var coyote_duration: float = 0.15 # Tiempo de gracia en segundos

var mask_cooldown: float = 0.0
var cooldown_duration: float = 0.0
var is_grabbing : bool = false


func _physics_process(delta: float) -> void:
	if is_on_floor():
		coyote_timer = coyote_duration
	else:
		velocity += get_gravity() * delta
		coyote_timer -= delta

	
	if Input.is_action_just_pressed("jump") and coyote_timer > 0.0:
		velocity.y = jump_velocity
		
		coyote_timer = 0.0
		
		if action_state_machine and action_state_machine.current_state:
			animation_player.play(action_state_machine.current_state.name + "_Jump")

	move_and_slide()
