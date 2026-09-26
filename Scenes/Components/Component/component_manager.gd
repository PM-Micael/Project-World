extends Node3D
class_name ComponentManager

@export var components: Dictionary[String, bool] = {
	"Modeling" : false,
	"Attack" : false,
	"Movment" : false,
	"Collision" : false
}

var modeling: ModelingComponent:
	get:
		return get_node_or_null("Modeling")
	
var atttack: AttackComponent:
		get:
			return get_node_or_null("Attack")

var movment: MovmentComponent:
	get:
		return get_node_or_null("Movment")

var collision: CollisionComponent:
	get:
		return get_node_or_null("Collision")

var targeting: TargetingComponent:
	get:
		return get_node_or_null("Targeting")

var targetable: TargetableComponent:
	get:
		return get_node_or_null("Targetable")

var health: HealthComponent:
	get:
		return get_node_or_null("Health")

func _ready() -> void:
	var nodes = get_children()
	for node in nodes:
		if node is Component:
			if not components[node.name]:
				node.queue_free()
