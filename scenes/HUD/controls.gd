extends CanvasLayer

@onready var hint_label = $Control/Label2
@onready var controls_label = $Control/Label
@onready var hint_rect =$Control/ColorRect2
@onready var controls_rect =$Control/ColorRect

func _ready() -> void:
	controls_label.visible = true
	hint_label.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("show_controls"):
		controls_label.visible = !controls_label.visible
		hint_label.visible = !controls_label.visible
		controls_rect.visible = !controls_rect.visible
		hint_rect.visible = !controls_rect.visible
