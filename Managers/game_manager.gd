extends Node

@export var cam : MainCamera
@export var player : Player
var current_level : Level

var max_x : float
var min_x : float
var max_y : float 
var min_y : float
var can_press_continue := false
const LEVELS = [
	"res://Levels/level_1.tscn",
	"res://Levels/level_2.tscn",
	"res://Levels/level_3.tscn",
]

enum GAMESTATE { NONE, GAME, GAMEOVER, PAUSED}
var game_state : GAMESTATE = GAMESTATE.NONE

var current_level_index: int = 0

func change_state(new_state : GAMESTATE):
	game_state = new_state
	match game_state:
		GAMESTATE.PAUSED:
			pause()
		GAMESTATE.GAME:
			unpause()
		GAMESTATE.GAMEOVER:
			get_tree().paused = true
			
			UIManager.fade(func ():
				UIManager.show_game_over()
				UIManager.fade(func (): can_press_continue = true,false))


func _process(delta: float) -> void:
	update_state(delta)
	
func _on_level_complete():
	next_level()
	
func pause():
	GameManager.get_tree().paused = true
	UIManager.show_pause()

func unpause():
	GameManager.get_tree().paused = false
	UIManager.hide_pause()
			
func update_state(delta):
	match game_state:
		GAMESTATE.GAME:
			if Input.is_action_just_pressed("pause"):
				change_state(GAMESTATE.PAUSED)
				return
		GAMESTATE.PAUSED:
			if Input.is_action_just_pressed("enter") or Input.is_action_just_pressed("pause"):
				change_state(GAMESTATE.GAME)
		GAMESTATE.GAMEOVER:
			if Input.is_anything_pressed() and can_press_continue:
				UIManager.fade(func (): 
					change_state(GAMESTATE.NONE)
					UIManager.hide_game_over()
					UIManager.hide_gui()
					can_press_continue = false
					restart_level())
				
				

func load_level(index: int) -> void:
	current_level_index = clampi(index, 0, LEVELS.size() - 1)
	get_tree().change_scene_to_file(LEVELS[current_level_index])


func next_level() -> void:
	if current_level_index + 1 < LEVELS.size():
		load_level(current_level_index + 1)

func restart_level() -> void:
	UIManager.update_demon_count(0)
	UIManager.update_tribe_count(0)
	get_tree().change_scene_to_file(LEVELS[current_level_index])


func load_scene(path: String) -> void:
	get_tree().change_scene_to_file(path)

func load_main_menu() -> void:
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
