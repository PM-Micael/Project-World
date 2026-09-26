extends Node3D
class_name Entity

var id: String
var display_name: String
var camera_target: bool = true
@export var is_player_entity: bool = false

var component: ComponentManager:
	get:
		return $Components
