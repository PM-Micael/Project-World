extends Camera3D
class_name GameCamera

@export var follow_speed: float = 5.0
@export var rotation_speed: float = 1.5
@export var pitch_degrees: float = 45.0
@export var distance: float = 14.0
@export var min_distance: float = 6.0
@export var max_distance: float = 30.0
@export var zoom_speed: float = 2.0

var target: Entity
var orbit_angle: float = 0.0
var focus_position: Vector3
var has_focus: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			distance = clamp(distance - zoom_speed, min_distance, max_distance)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			distance = clamp(distance + zoom_speed, min_distance, max_distance)

func _process(delta: float) -> void:
	if target == null or not is_instance_valid(target) or not target.camera_target:
		target = _find_camera_target(get_tree().current_scene)
		has_focus = false

	if target == null:
		return

	if not has_focus:
		focus_position = target.global_position
		has_focus = true

	if Input.is_key_pressed(KEY_A):
		orbit_angle += rotation_speed * delta
	if Input.is_key_pressed(KEY_D):
		orbit_angle -= rotation_speed * delta

	# Smooth the point the camera orbits around, not the camera's own
	# position, so position and rotation are always derived together and
	# never disagree with each other (which caused the jerk).
	focus_position = focus_position.lerp(target.global_position, clamp(follow_speed * delta, 0.0, 1.0))

	var pitch_rad := deg_to_rad(pitch_degrees)
	var horizontal_distance := distance * cos(pitch_rad)
	var vertical_distance := distance * sin(pitch_rad)
	var offset := Vector3(
		sin(orbit_angle) * horizontal_distance,
		vertical_distance,
		cos(orbit_angle) * horizontal_distance
	)

	global_position = focus_position + offset
	global_transform.basis = Basis.looking_at(-offset, Vector3.UP)

func _find_camera_target(node: Node) -> Entity:
	if node is Entity and node.camera_target:
		return node
	for child in node.get_children():
		var found := _find_camera_target(child)
		if found:
			return found
	return null
