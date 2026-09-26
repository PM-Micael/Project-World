extends Node3D
class_name Component

var entity: Entity:
	get:
		return get_parent().get_parent() as Entity
