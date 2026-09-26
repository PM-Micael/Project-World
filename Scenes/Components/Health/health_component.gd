extends Node3D
class_name HealthComponent

signal pre_damage_taken(amount: int)
signal post_damage_taken(amount: int)

var base_health: int
var max_health: int
var current_health: int

func take_damage(amount: int):
	pre_damage_taken.emit(amount)
	current_health -= amount
	post_damage_taken.emit(amount)
