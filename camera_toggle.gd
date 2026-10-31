extends Node

@onready var cam: Camera3D = $"../Camera3D"
@onready var orbit_pivot: Node3D = $"../OrbitPivot"
@onready var testcam: Camera3D = $"../OrbitPivot/SpringArm3D/TestCamera"
@onready var model = $"../Ch15_nonPBR"

func _ready():
	set_process_input(true)
	cam.current = true
	testcam.current = false
	model.visible = false
	orbit_pivot.top_level = false

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_T and not event.echo:
		if cam.current:
			# go third - activate new FIRST
			testcam.current = true
			orbit_pivot.top_level = true
			model.visible = true
			cam.current = false
		else:
			# go first - activate new FIRST
			cam.current = true
			orbit_pivot.top_level = false
			model.visible = false
			testcam.current = false
		print("TOGGLE -> first:", cam.current, " third:", testcam.current)
