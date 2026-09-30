extends Component
class_name CollisionComponent

const DEFAULT_CAPSULE_RADIUS := 0.5
const DEFAULT_CAPSULE_HEIGHT := 2.0

# Lets other systems (e.g. MovmentComponent's click-to-move raycast) tell an
# entity's collider apart from plain terrain/ground colliders, without those
# systems needing to know how entities are put together.
const ENTITY_GROUP := "entities"

@onready var _static_body: StaticBody3D = $StaticBody3D
@onready var _collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D

var _shape_built := false

func _ready() -> void:
	get_viewport().physics_object_picking = true
	_static_body.input_ray_pickable = true
	_static_body.add_to_group(ENTITY_GROUP)
	# Physics layers: 1 = world, 2 = entity bodies, 3 = click-pick bodies.
	# The pick body is a child of the entity, so keep it off layer 1 or the
	# entity's own body (mask 1) would collide with it.
	_static_body.collision_layer = 1 << 2
	_static_body.collision_mask = 0
	entity.collision_layer = 1 << 1
	entity.collision_mask = 1
	entity.add_to_group(ENTITY_GROUP)
	_static_body.input_event.connect(_on_static_body_input_event)

func _on_static_body_input_event(_camera: Node, event: InputEvent, _click_position: Vector3, _click_normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("clicked")

func _process(_delta: float) -> void:
	if _shape_built:
		return
	_shape_built = true
	set_process(false)
	_build_collision_shape()

func _build_collision_shape() -> void:
	var body := _find_modeling_body()
	var shape: Shape3D = null
	var local_transform := Transform3D.IDENTITY

	if body != null and body.mesh != null:
		shape = _shape_from_mesh(body.mesh)
		local_transform = entity.component.modeling.transform * body.transform

	if shape == null:
		shape = CapsuleShape3D.new()
		shape.radius = DEFAULT_CAPSULE_RADIUS
		shape.height = DEFAULT_CAPSULE_HEIGHT
		local_transform = Transform3D.IDENTITY

	_collision_shape.shape = shape
	_collision_shape.transform = Transform3D.IDENTITY
	_static_body.transform = local_transform

	# The entity itself collides with the world using the same shape.
	var body_shape := CollisionShape3D.new()
	body_shape.shape = shape
	body_shape.transform = local_transform
	entity.add_child(body_shape)

func _find_modeling_body() -> MeshInstance3D:
	var modeling := entity.component.modeling
	if modeling == null or not is_instance_valid(modeling):
		return null
	var body := modeling.get_node_or_null("Body")
	if body == null or not (body is MeshInstance3D):
		return null
	return body

func _shape_from_mesh(mesh: Mesh) -> Shape3D:
	if mesh is CapsuleMesh:
		var shape := CapsuleShape3D.new()
		shape.radius = mesh.radius
		shape.height = mesh.height
		return shape
	elif mesh is BoxMesh:
		var shape := BoxShape3D.new()
		shape.size = mesh.size
		return shape
	elif mesh is SphereMesh:
		var shape := SphereShape3D.new()
		shape.radius = mesh.radius
		return shape
	elif mesh is CylinderMesh:
		var shape := CylinderShape3D.new()
		# CylinderShape3D has one radius; CylinderMesh allows distinct
		# top/bottom radii, so approximate with the larger of the two.
		shape.radius = max(mesh.top_radius, mesh.bottom_radius)
		shape.height = mesh.height
		return shape
	else:
		var aabb := mesh.get_aabb()
		var shape := BoxShape3D.new()
		shape.size = aabb.size
		return shape
