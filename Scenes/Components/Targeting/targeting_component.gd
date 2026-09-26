extends Node3D
class_name TargetingComponent

signal post_set_target(target: Entity)
signal post_set_targets(targets: Array[Entity])

var attack_target: Entity:
	set(target):
		if target.component.targetable:
			attack_target = target
			post_set_target.emit(target)

var attack_targets: Array[Entity]:
	set(targets):
		var new_targets: Array[Entity]
		for target in targets:
			if target.component.targetable:
				new_targets.append(target)
		attack_targets = new_targets
		post_set_targets.emit(attack_targets)
