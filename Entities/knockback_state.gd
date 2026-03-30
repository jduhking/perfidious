class_name KnockbackState
extends State
@export var actor : Entity
var knockback_direction : Vector2
var knockback_force : float = 10:
	get():
		return knockback_force
	set(value):
		var min_dmg = actor.min_attack_damage if actor else 0.0
		var max_dmg = actor.max_attack_damage if actor else 1.0
		if max_dmg == min_dmg:
			knockback_force = actor.min_knockback_force if actor else value
			return
		knockback_force = lerpf(actor.min_knockback_force, actor.max_knockback_force, inverse_lerp(min_dmg, max_dmg, value))
var knockback_time : float = 0.6

func init():
	actor.can_hurt = false
	await get_tree().create_timer(knockback_time).timeout
	actor.fsm.change_state(actor.fsm.previous_state)
	
func cleanup():
	actor.create_cooldown_timer()
	
func _physics_process(delta: float) -> void:
	actor.global_position += knockback_direction * knockback_force * delta
