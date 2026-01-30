extends CharacterBody2D

var speed = 100.0
var jump_velocity = -200.0

@export var animation_player: AnimationPlayer

@export var movement_state_machine: StateMachine
@export var action_state_machine: StateMachine

var mask_cooldown: float = 0.0
var cooldown_duration: float = 1.0

var is_grabbing : bool = false

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		animation_player.play(action_state_machine.current_state.name + "_Jump")
		velocity.y = jump_velocity

	move_and_slide()
