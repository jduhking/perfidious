class_name Player
extends Entity

var blowing_horn : bool = false
var is_caught : bool = false
var demon_count : int = 0
var suspicion : float = 0:
	set(value):
		suspicion = clampf(value, 0,1)
		if suspicion == 1:
			is_caught = true
		UIManager.update_sus_bar(suspicion)
		
@onready var demon = preload("res://Entities/Demon/demon.tscn")

var spawn_time : float = 1
var spawn_elapsed_time : float = 0:
	get():
		return spawn_elapsed_time
	set(value):
		spawn_elapsed_time = value
		$ProgressBar.value = lerpf(0,1,spawn_elapsed_time/spawn_time)

@export var heightened_suspicion_rate : float = 0.1
@export var suspicion_rate : float = 0.025
 
func _ready() -> void:
	GameManager.player = self
	GameManager.cam.follow_node = self
	
func _physics_process(delta: float) -> void:
	blowing_horn = Input.is_action_pressed("horn")
	spawn_elapsed_time = spawn_elapsed_time + delta if blowing_horn else 0
	if spawn_elapsed_time >= spawn_time:
		spawn_elapsed_time = 0
		spawn_demon()
		
	var input_dir = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized() if not blowing_horn else Vector2.ZERO
	
	if input_dir != Vector2.ZERO:
		var largest_dot = -INF
		var largest_dir : Vector2 = Vector2(1,0)
		for dir in [Vector2(1,0), Vector2(0,1), Vector2(-1, 0), Vector2(0, -1)]:
			var dot = dir.dot(input_dir)
			if dot >= largest_dot:
				largest_dot = dot
				largest_dir = dir
			
		current_dir_name = dir_to_name_map[largest_dir]
	animator.play(current_dir_name)
		
	
	var accel = max_speed / accel_time
	var decel = max_speed / decel_time

	if input_dir != Vector2.ZERO:
		velocity = velocity.move_toward(input_dir * max_speed, accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, decel * delta)

	move_and_slide()
	
func spawn_demon():
	demon_count += 1
	var spawn_point : Vector2 = Vector2(0 if randi() % 2 < 1 else 320, randf_range(GameManager.min_y, GameManager.max_y))
	var d := demon.instantiate() as Demon
	d.global_position = spawn_point
	d.tree_exited.connect(func (): demon_count -= 1)
	GameManager.current_level.add_child(d)
	
func seen():
	suspicion += (heightened_suspicion_rate if demon_count > 0 else suspicion_rate) * get_physics_process_delta_time()

func update_health_callback(value : float):
	if current_health <= 0:
		GameManager.change_state(GameManager.GAMESTATE.GAMEOVER)
		
		
	
