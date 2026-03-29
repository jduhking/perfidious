class_name DemonBaseState
extends State

@export var actor : Demon

func _physics_process(delta: float) -> void:
	var collisions = actor.detection_area.get_overlapping_bodies().filter(func (x : Node2D): return x is Tribesman)
	if collisions.size() > 0 and !actor.current_target:
		actor.current_target = collisions[0] as Tribesman
	
	if actor.current_target:
		var input_dir = actor.global_position.direction_to(actor.current_target.global_position).normalized() 

		var accel = actor.max_speed / actor.accel_time
		var decel = actor.max_speed / actor.decel_time

		if input_dir != Vector2.ZERO:
			actor.velocity = actor.velocity.move_toward(input_dir * actor.max_speed, accel * delta)
		else:
			actor.velocity = actor.velocity.move_toward(Vector2.ZERO, decel * delta)

		actor.move_and_slide()
		
		if actor.global_position.distance_to(actor.current_target.global_position) <= actor.ATTACK_THRESHOLD:
			actor.current_target.damage(actor.attack_damage, actor.get_direction_to(actor.current_target))
			
