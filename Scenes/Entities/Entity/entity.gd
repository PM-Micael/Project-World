extends Node3D
class_name Entity

var id: String
var display_name: String
var is_player_entity: bool

var component: ComponentManager:
	get:
		return $Components
