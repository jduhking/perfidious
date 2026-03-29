extends Node

@export var cam : MainCamera
@export var player : Player
var current_level : Level

var max_x : float
var min_x : float
var max_y : float 
var min_y : float

const LEVELS = [
	"res://Levels/level_1.tscn",
	"res://Levels/level_2.tscn",
	"res://Levels/level_3.tscn",
]

enum GAMESTATE { NONE, GAME, GAMEOVER}
var game_state : GAMESTATE = GAMESTATE.NONE

var current_level_index: int = 0

func change_state(new_state : GAMESTATE):
	game_state = new_state
	match game_state:
		GAMESTATE.NONE:
			pass
		GAMESTATE.GAME:
			pass
		GAMESTATE.GAMEOVER:
			get_tree().paused = true
			await get_tree().create_timer(0.5).timeout
			restart_level()
			get_tree().paused = false

func _process(delta: float) -> void:
	update_state(delta)
	
func _on_level_complete():
	next_level()
			
func update_state(delta):
	match game_state:
		GAMESTATE.GAME:
			pass

func load_level(index: int) -> void:
	current_level_index = clampi(index, 0, LEVELS.size() - 1)
	get_tree().change_scene_to_file(LEVELS[current_level_index])


func next_level() -> void:
	if current_level_index + 1 < LEVELS.size():
		load_level(current_level_index + 1)


func restart_level() -> void:
	get_tree().change_scene_to_file(LEVELS[current_level_index])


func load_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)


func load_main_menu() -> void:
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
