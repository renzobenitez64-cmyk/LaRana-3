extends Node3D
# Player/LeanProne - fixed Siege lean
@export var lean_angle = 12.0
@export var lean_shift = 0.35
@export var prone_height = 0.3
@export var lean_time = 0.22

@onready var player = get_parent()
@onready var cam: Camera3D = player.get_node_or_null("Camera3D")
@onready var col = player.get_node_or_null("CollisionShape3D")

var is_prone = false
var normal_y = 1.2
var lean_tween: Tween
var prone_tween: Tween

func _ready():
	if cam:
		normal_y = cam.position.y

func _unhandled_input(e):
	if e.is_action_pressed("lean_left"):
		_lean(1)
	elif e.is_action_pressed("lean_right"):
		_lean(-1)
	
	# only reset if BOTH released - fixes snap when holding one
	if e.is_action_released("lean_left") or e.is_action_released("lean_right"):
		if not Input.is_action_pressed("lean_left") and not Input.is_action_pressed("lean_right"):
			_lean(0)

	if e.is_action_pressed("prone"):
		_toggle_prone()

func _lean(dir: int):
	if not cam: return
	if lean_tween: lean_tween.kill()
	# dir: -1 = left (Q), 1 = right (E) - if still inverted, swap to 1 and -1
	lean_tween = create_tween()
	lean_tween.set_parallel(true)
	lean_tween.set_trans(Tween.TRANS_SINE)
	lean_tween.set_ease(Tween.EASE_OUT)
	lean_tween.tween_property(cam, "h_offset", lean_shift * dir, lean_time)
	lean_tween.tween_property(cam, "rotation:z", deg_to_rad(lean_angle * dir), lean_time)

func _toggle_prone():
	if not cam: return
	is_prone = !is_prone
	if prone_tween: prone_tween.kill()
	prone_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	var ty = prone_height if is_prone else normal_y
	prone_tween.tween_property(cam, "position:y", ty, 0.22)
