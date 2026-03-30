class_name Player
extends Entity

var blowing_horn : bool = false
var is_caught : bool = false
var demon_count : int = 0:
	set(value):
		demon_count = value
		UIManager.update_demon_count(value)
		
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
@export var too_far_distance : float = 150
var body_light : PointLight2D
var sight_light : PointLight2D
static var _radial_tex : ImageTexture

func _ready() -> void:
	GameManager.player = self
	#GameManager.cam.follow_node = sel
	_setup_lights()

func _setup_lights() -> void:
	
	body_light = PointLight2D.new()
	body_light.name = "BodyLight"
	if !_radial_tex:
		_radial_tex = _make_radial_texture(128)
	body_light.texture = _radial_tex
	body_light.texture_scale = 0.4
	body_light.energy = 0.6
	body_light.color = Color.WHITE
	add_child(body_light)

func _make_radial_texture(size: int) -> ImageTexture:
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	var center := Vector2(size / 2.0, size / 2.0)

	for y in size:
		for x in size:
			var dist := Vector2(x, y).distance_to(center) / (size / 2.0)
			var alpha := 1.0 - smoothstep(0.0, 1.0, dist)
			img.set_pixel(x, y, Color(1, 1, 1, alpha))

	return ImageTexture.create_from_image(img)

	
func _physics_process(delta: float) -> void:
	blowing_horn = Input.is_action_pressed("horn")
	if blowing_horn and Tribesman.current_group_interest_point and global_position.distance_to(Tribesman.current_group_interest_point.global_position) >= too_far_distance:
		raise_suspicion()
	spawn_elapsed_time = spawn_elapsed_time + delta if blowing_horn else 0
	if spawn_elapsed_time >= spawn_time:
		spawn_elapsed_time = 0
		spawn_demon()
		
	var input_dir = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	).normalized() if not blowing_horn else Vector2.ZERO
	
	determine_sprite_dir(input_dir)
		
	
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
	
func raise_suspicion():
	suspicion += (heightened_suspicion_rate if demon_count > 0 else suspicion_rate) * get_physics_process_delta_time()

func update_health_callback(value : float):
	if current_health <= 0:
		GameManager.change_state(GameManager.GAMESTATE.GAMEOVER)
		
		
	
