extends Node3D
var pitch = 0.0
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		rotation_degrees.y -= event.relative.x * 0.3
		pitch = clamp(pitch - event.relative.y * 0.3, -80, 80)
		rotation_degrees.x = pitch
