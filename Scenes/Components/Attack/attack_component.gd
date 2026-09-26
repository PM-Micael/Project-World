extends Component
class_name AttackComponent

signal pre_attack_target(target: Entity)
signal post_attack_target(target: Entity, damage: int)

var attack_damage: int

func attack_target(target: Entity):
	pre_attack_target.emit(target)
	
	var damage = calculate_damage()
	target.component.health.take_damage(damage)
	
	post_attack_target.emit(target, damage)

func calculate_damage() -> int:
	return attack_damage
