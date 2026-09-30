extends Component
class_name MovmentComponent

@export var speed: float = 5.0
@export var arrival_threshold: float = 0.1

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var move_target: Vector3
var is_moving: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if not entity.is_player_entity:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_set_move_target_from_screen(event.position)

func _set_move_target_from_screen(screen_pos: Vector2) -> void:
	var camera := get_viewport().get_camera_3d()
	if camera == null:
		return

	var from := camera.project_ray_origin(screen_pos)
	var to := from + camera.project_ray_normal(screen_pos) * 1000.0

	var query := PhysicsRayQueryParameters3D.create(from, to)
	var result := get_world_3d().direct_space_state.intersect_ray(query)

	if result and not result.collider.is_in_group(CollisionComponent.ENTITY_GROUP):
		move_target = result.position
		is_moving = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var velocity := entity.velocity
	velocity.y -= gravity * delta if not entity.is_on_floor() else 0.0
	velocity.x = 0.0
	velocity.z = 0.0

	if is_moving and entity.is_player_entity:
		var offset := move_target - entity.global_position
		offset.y = 0.0
		if offset.length() <= arrival_threshold:
			is_moving = false
		else:
			var step := offset.normalized() * speed
			velocity.x = step.x
			velocity.z = step.z

	entity.velocity = velocity
	entity.move_and_slide()
