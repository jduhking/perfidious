class_name FiniteStateMachine
extends Node

@export var initial_state : State 
@export var auto_start : bool = true
@onready var state : State = initial_state
var previous_state : State = state

var started : bool = false

var locked : bool = false

signal state_changed(new_state : State)

func _ready():
	if auto_start:
		await get_tree().process_frame
		change_state(state)
		
func start():
	started = true
	change_state(initial_state)
		
func change_state(new_state : State, lock : bool = false):
	if !locked:
		previous_state = state
		#"entering a new state: ", new_state, " previous state: ", previous_state)
		if state is State:
			state._exit_state()
		state = new_state
		state_changed.emit(state)
		new_state._enter_state()
		if lock:
			locked = true
		
