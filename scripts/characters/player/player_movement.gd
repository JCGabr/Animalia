extends CharacterBody3D

const mouse_sens = 0.001
@export var head: Node3D

func camera_move(relative: Vector2) -> void:
	relative *= mouse_sens
	head.rotate_x(-relative.y)
	head.rotation.x = clamp(head.rotation.x, -PI/2, PI/2)
	self.rotate_y(-relative.x)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_move(event.get_relative())
		
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
