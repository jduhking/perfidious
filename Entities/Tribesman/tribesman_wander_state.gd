class_name TribesmanWanderState
extends State

@export var actor : Tribesman

	
func _physics_process(delta: float) -> void:
	
	var interests = actor.hearing_area.get_overlapping_bodies()
	var threats = actor.detection_area.get_overlapping_bodies()
	
	var players = interests.filter(func (x : Node2D): return x is Player)
	if players.size() > 0 and GameManager.player.blowing_horn and actor.current_group_interest_point != GameManager.player:
		actor.check_out_player()
		
	threats = threats.filter(func (x : Entity): 
		var angle = actor.global_position.angle_to_point(x.global_position)
		return angle >= -actor.half_angle + actor.current_rotation and angle <= actor.half_angle + actor.current_rotation and actor.get_distance_to(x) <= actor.sight_radius and ((x is Demon) or ((x as Player) and (x as Player).is_caught))
	)
	
	if threats.size() > 0:
		actor.current_threat = threats[0]
		actor.fsm.change_state(actor.attack_state)
		return 

	if actor.global_position.distance_to(actor.target) <= actor.TARGET_THRESHOLD:
		if actor.brain == actor and !actor.timer:
			actor.create_hangout_timer()
		actor.decide_target()
		
	actor.facing_direction = actor.global_position.direction_to(actor.target).normalized()
	actor.current_rotation = atan2(actor.facing_direction.y, actor.facing_direction.x)
		
	actor.determine_sprite_dir(actor.facing_direction)
		
	if actor.facing_direction != Vector2.ZERO:
		var largest_dot = -INF
		var largest_dir : Vector2 = Vector2(1,0)
		for dir in [Vector2(1,0), Vector2(0,1), Vector2(-1, 0), Vector2(0, -1)]:
			var dot = dir.dot(actor.facing_direction)
			if dot >= largest_dot:
				largest_dot = dot
				largest_dir = dir
			
		actor.current_dir_name = actor.dir_to_name_map[largest_dir]

	var accel = actor.max_speed / actor.accel_time
	var decel = actor.max_speed / actor.decel_time
	var half_angle = actor.sight_angle * 0.5 * PI/180 

	actor.velocity = actor.velocity.move_toward(actor.facing_direction * actor.max_speed, accel * delta)

	#else:
		#velocity = velocity.move_toward(Vector2.ZERO, decel * delta)
	actor.move_and_slide()
	
	if actor.can_see_player() and GameManager.player.blowing_horn:
		actor.seen_count += 1
		GameManager.player.raise_suspicion()
		await get_tree().process_frame
		actor.seen_count -= 1
	
	
