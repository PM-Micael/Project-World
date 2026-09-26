extends Component
class_name MovmentComponent

@export var speed: float = 5.0
@export var arrival_threshold: float = 0.1

var move_target: Vector3
var is_moving: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if not entity.is_player_entity:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		_set_move_target_from_screen(event.position)

func _set_move_target_from_screen(screen_pos: Vector2) -> void:
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return

	var from := camera.project_ray_origin(screen_pos)
	var to := from + camera.project_ray_normal(screen_pos) * 1000.0

	var query := PhysicsRayQueryParameters3D.create(from, to)
	var result := get_world_3d().direct_space_state.intersect_ray(query)

	if result:
		move_target = result.position
		is_moving = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_moving or not entity.is_player_entity:
		return

	var current := entity.position
	var target := Vector3(move_target.x, current.y, move_target.z)
	var distance := current.distance_to(target)

	if distance <= arrival_threshold:
		is_moving = false
		return

	entity.position += (target - current).normalized() * min(speed * delta, distance)
