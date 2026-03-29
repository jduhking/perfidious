class_name KnockbackState
extends State

@export var actor : Entity

var knockback_direction : Vector2
var knockback_force : float = 10:
	get():
		return knockback_force
	set(value):
		knockback_force = lerpf(actor.min_knockback_force, actor.max_knockback_force, inverse_lerp(actor.min_attack_damage, actor.max_attack_damage, value))
var knockback_time : float = 0.6

func init():
	actor.can_hurt = false
	await get_tree().create_timer(knockback_time).timeout
	actor.fsm.change_state(actor.fsm.previous_state)
	
func cleanup():
	actor.create_cooldown_timer()
	
func _physics_process(delta: float) -> void:
	actor.global_position += knockback_direction * knockback_force * delta
	
