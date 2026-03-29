class_name TribesmanAttackState
extends State

@export var actor : Tribesman
	
enum ATTACKSTATE { ATTACK, EVADE } 
var current_state : ATTACKSTATE = ATTACKSTATE.ATTACK
var arrow_timer : Timer
func enter_state(new_state : ATTACKSTATE): 
	current_state = new_state 
	match new_state: 
		ATTACKSTATE.ATTACK: 
			pass 
		ATTACKSTATE.EVADE: 
			pass

func update_state(delta): 
	match current_state: 
		ATTACKSTATE.ATTACK: 
			if actor.get_distance_to(actor.current_threat) <= actor.evade_threshold:
				enter_state(ATTACKSTATE.EVADE)
				return
				
			if !arrow_timer:
				actor.shoot_arrow()
				arrow_timer = TimerTools.create_adhoc_timer(self, actor.arrow_rate)
			

		ATTACKSTATE.EVADE: 
			actor.facing_direction = -actor.get_direction_to(actor.current_threat).normalized()
			actor.rotation = atan2(actor.facing_direction.y, actor.facing_direction.x)
			var accel = actor.max_speed / actor.accel_time
			var decel = actor.max_speed / actor.decel_time
			actor.velocity = actor.velocity.move_toward(actor.facing_direction * actor.max_speed, accel * delta)
			actor.move_and_slide()
			if actor.get_distance_to(actor.current_threat) >= actor.shoot_distance:
				enter_state(ATTACKSTATE.ATTACK)

func _physics_process(delta: float) -> void:
	if actor.current_threat:
		update_state(delta)
	else:
		actor.fsm.change_state(actor.wander_state)
	
