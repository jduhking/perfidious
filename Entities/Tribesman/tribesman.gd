class_name Tribesman
extends Entity

const TARGET_THRESHOLD : float = 4
var facing_direction : Vector2 = Vector2(randf_range(0,1), randf_range(0,1)).normalized()
static var current_group_interest_point : Node2D
static var brain : Tribesman 
static var seen_count : int = 0
var current_threat : Entity

@onready var arrow = preload("res://Entities/Tribesman/Arrow.tscn")
@onready var hearing_area : Area2D = $HearingArea
var timer : Timer
@export var hangout_time : float = 1
@export var hangout_radius : float = 96
@export var sight_radius : float = 64
@export_range(0, 180) var sight_angle : float = 45
@export var evade_threshold : float = 2
@export var shoot_distance : float = 64
@export var arrow_rate : float = 1
const highly_suspect_player_threshold : float = 0.5
var target : Vector2 
static var tribe_count = 0:
	set(value):
		tribe_count = value
		UIManager.update_tribe_count(value)
@onready var color_rect : ColorRect = $ColorRect
@onready var half_angle : float = sight_angle * 0.5 * PI/180 

@onready var wander_state : TribesmanWanderState = $FiniteStateMachine/TribesmanWanderState
@onready var attack_state : TribesmanAttackState = $FiniteStateMachine/TribesmanAttackState

@onready var detection_area : Area2D = $DetectionArea
@onready var detection_shape : CircleShape2D = $DetectionArea/CollisionShape2D.shape
var current_rotation : float 
signal reached_destination 

func _ready() -> void:
	detection_shape.radius = sight_radius
	tree_exited.connect(cleanup)
	tribe_count += 1
	if !brain:
		claim_brain()
		
func cleanup():
	tribe_count -= 1
	
static func _on_shared_timeout():
	update_shared_interest_point()
	
static func update_shared_interest_point(interest : Node2D = null):
	if interest:
		current_group_interest_point = interest
	else:
		if GameManager.player.suspicion >= highly_suspect_player_threshold:
			current_group_interest_point = GameManager.player
		elif GameManager.current_level:
			var interest_points = GameManager.current_level.interest_points
			current_group_interest_point = interest_points[randi() % interest_points.size()]
		
func claim_brain() -> void:
	brain = self
	
func create_hangout_timer():
	timer = TimerTools.create_adhoc_timer(self, hangout_time, _on_shared_timeout)

func _exit_tree() -> void:
	if brain == self:
		brain = null
		timer = null
		# find any surviving instance and promote it
		var others = GameManager.current_level.get_node("Tribesmen").get_children().filter(func (x : Tribesman): return x != self)
		if others.size() > 0:
			(others[0] as Tribesman).claim_brain()
			
func _process(delta: float) -> void:
	queue_redraw()

func decide_target():
	#target = GameManager.player.global_position
	
	var rand_vec = Vector2.RIGHT.rotated(randf() * TAU) * (sqrt(randf()) * hangout_radius)
	
	var p_x = rand_vec.x + current_group_interest_point.global_position.x
	var p_y = rand_vec.y + current_group_interest_point.global_position.y
	
	target = Vector2(clampf(p_x, GameManager.min_x, GameManager.max_x), clampf(p_y, GameManager.min_y, GameManager.max_y))
	
func _draw() -> void:
	var point_a = Vector2(cos(-half_angle + current_rotation),  sin(-half_angle + current_rotation)) * sight_radius 
	var point_b = Vector2(cos(half_angle + current_rotation),   sin(half_angle + current_rotation)) * sight_radius
	draw_line(Vector2.ZERO, point_a, Color.RED, 1)
	draw_line(Vector2.ZERO, point_b, Color.RED, 1)
	draw_arc(Vector2.ZERO, sight_radius, -half_angle + current_rotation, half_angle + current_rotation, 100, Color.RED)
	
func can_see_player() -> bool:
	var angle_to_player = global_position.angle_to_point(GameManager.player.global_position)
	return angle_to_player >= -half_angle + current_rotation and angle_to_player <= half_angle + current_rotation and GameManager.player.global_position.distance_to(global_position) <= sight_radius 

func look():
	var half_angle = sight_angle * 0.5 * PI/180 
	if can_see_player() and GameManager.player.blowing_horn and seen_count < 1:
		seen_count += 1
		GameManager.player.raise_suspicion()

func shoot_arrow():
	var a : Arrow = arrow.instantiate()
	a.init($ArrowSpawnPoint.global_position, get_direction_to(current_threat))
	
	GameManager.current_level.add_child(a)
	
func check_out_player():
	if brain and !brain.timer:
		TimerTools.kill_timer(brain.timer)
		create_hangout_timer()
	update_shared_interest_point(GameManager.player)
	
	
	
	
