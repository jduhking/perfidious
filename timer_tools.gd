class_name TimerTools

static func create_adhoc_timer(calling_object : Node, wait_time : float, callback : Callable = func ():pass, one_shot : bool = true) -> Timer:
	var timer : Timer = Timer.new()
	
	var cleanup = func ():
		callback.call()
		if one_shot:
			timer.queue_free()

	calling_object.add_child(timer)
	timer.one_shot = one_shot
	timer.wait_time = wait_time
	timer.timeout.connect(cleanup)
	timer.start()
	return timer
	
static func kill_timer(timer):
	if is_instance_valid(timer):
		timer.stop()
		timer.queue_free()
	
