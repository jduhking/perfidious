class_name Entity
extends CharacterBody2D

@onready var fsm : FiniteStateMachine = $FiniteStateMachine
@onready var knockback_state : KnockbackState = $FiniteStateMachine/KnockbackState
@export var max_health : float = 10
@onready var animator = $AnimationPlayer
@onready var current_health : float = max_health:
	get():
		return current_health
	set(value):
		current_health = value
		update_health_callback(value)

@export var max_speed := 300.0
@export var accel_time := 0.2
@export var decel_time := 0.15
@export var max_attack_damage = 6
@export var min_attack_damage = 1
@export var attack_damage : float = 1

@export var max_knockback_force = 500
@export var min_knockback_force = 100
var can_hurt : bool = true
var hurt_cooldown_time : float = 0.25
var flash_timer : Timer
const flash_amount : int = 2

var cooldown_timer : Timer

var current_dir_name : String = "down"

var dir_to_name_map = { Vector2(1,0) : "right", Vector2(-1,0) : "left", Vector2(0,1) : "down", Vector2(0,-1) : "up"}


func _ready() -> void:
	attack_damage = clampf(attack_damage,min_attack_damage, max_attack_damage)

func create_cooldown_timer():
	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	cooldown_timer.autostart = true
	cooldown_timer.wait_time = hurt_cooldown_time
	cooldown_timer.timeout.connect(on_cooldown_complete)
	add_child(cooldown_timer)

func on_cooldown_complete():
	can_hurt = true
	if cooldown_timer:
		cooldown_timer.queue_free()
	
func damage(value : float, dir : Vector2):
	if can_hurt:
		start_stun()
		current_health = max(current_health - value, 0)
		if current_health <= 0:
			death()
		else:
			knockback(value, dir)
		
func death():
	queue_free()
	
func knockback(force : float, dir : Vector2):
	knockback_state.knockback_direction = dir
	knockback_state.knockback_force = force
	fsm.change_state(knockback_state)

func get_direction_to(target : Entity) -> Vector2:
	return global_position.direction_to(target.global_position)

func get_distance_to(target : Entity) -> float:
	return global_position.distance_to(target.global_position)


func start_stun():
	TimerTools.create_adhoc_timer(self, hurt_cooldown_time, stop_stun)
	start_hit_flash()
	
func stop_stun():
	stop_hit_flash()
	
func start_hit_flash():
	kill_flash_timer()
	flash_timer = TimerTools.create_adhoc_timer(self, hurt_cooldown_time / flash_amount, flash, false)
	
func stop_hit_flash():
	kill_flash_timer()
	material.set_deferred("shader_parameter/Enabled", false)
	

func flash():
	material.set_deferred("shader_parameter/Enabled", !material.get_shader_parameter("Enabled"))


func kill_flash_timer():
	TimerTools.kill_timer(flash_timer)
	
func update_health_callback(value : float):
		$HealthBar.value = lerpf(0,1,current_health/max_health)
