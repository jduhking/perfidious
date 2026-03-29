class_name State
extends Node



func _ready():
	set_physics_process(false)
	
func _enter_state() -> void:
	set_physics_process(true)
	init()
	
func _exit_state() -> void:
	set_physics_process(false)
	cleanup()
	
	
func init():
	pass
	
func cleanup():
	pass
	
