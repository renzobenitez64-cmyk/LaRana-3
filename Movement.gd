extends CharacterBody3D
@export var walk = 4.0
@export var sprint_speed = 6.5
@export var jump_force = 4.5
@export var mouse_sens = 0.003

@onready var cam: Camera3D = get_node_or_null("LeanPivot/Camera3D") as Camera3D if has_node("LeanPivot/Camera3D") else get_node_or_null("Camera3D") as Camera3D
@onready var orbit_pivot = get_node_or_null("OrbitPivot")
@onready var testcam = get_node_or_null("OrbitPivot/SpringArm3D/TestCamera")
@onready var model = get_node_or_null("Ch15_nonPBR")

var grav = ProjectSettings.get_setting("physics/3d/default_gravity")
var orbit_pitch = 0.0
var pitch = 0.0

func _ready():
	if cam:
		pitch = cam.rotation.x
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _has_actions(names: Array) -> bool:
	for n in names:
		if not InputMap.has_action(n):
			return false
	return true

func _unhandled_input(e):
	if not cam: return
	if cam.current and e is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-e.relative.x * mouse_sens)
		pitch -= e.relative.y * mouse_sens
		pitch = clamp(pitch, deg_to_rad(-85), deg_to_rad(85))
		cam.rotation.x = pitch
	elif orbit_pivot and not cam.current and e is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		orbit_pivot.rotation_degrees.y -= e.relative.x * 0.3
		orbit_pitch = clamp(orbit_pitch - e.relative.y * 0.3, -80, 80)
		orbit_pivot.rotation_degrees.x = orbit_pitch

func _physics_process(d):
	if orbit_pivot:
		orbit_pivot.global_position = global_position + Vector3(0, 1.2, 0)

	if not is_on_floor():
		velocity.y -= grav * d
	elif _has_actions(["jump"]) and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force

	var input = Vector2.ZERO
	if _has_actions(["move_left","move_right","move_forward","move_back"]):
		input = Input.get_vector("move_left","move_right","move_forward","move_back")

	var speed = sprint_speed if (_has_actions(["sprint"]) and Input.is_action_pressed("sprint")) else walk

	if testcam and testcam.current:
		if input.length() > 0.1 and orbit_pivot:
			var b = orbit_pivot.global_transform.basis
			var fwd = (-b.z)
			fwd.y = 0
			fwd = fwd.normalized()
			var right = b.x
			right.y = 0
			right = right.normalized()
			var dir = (right * input.x + fwd * -input.y).normalized()
			if model:
				model.rotation.y = lerp_angle(model.rotation.y, atan2(dir.x, dir.z) - rotation.y, d * 10.0)
			velocity.x = dir.x * speed
			velocity.z = dir.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
	else:
		var dir = (transform.basis * Vector3(input.x, 0, input.y)).normalized()
		if dir:
			velocity.x = dir.x * speed
			velocity.z = dir.z * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
