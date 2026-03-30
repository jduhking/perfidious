extends Node

@onready var suspicion_bar : TextureProgressBar = $CanvasLayer/GUI/SusContainer/VBoxContainer/SusBar
@onready var sus_message : TextureRect = $CanvasLayer/GUI/SusContainer/VBoxContainer/SusMessage
@onready var tribe_icon : TextureRect = $CanvasLayer/GUI/EntityIconContainer/Tribe/TribeIcon
@onready var tribe_count : Label = $CanvasLayer/GUI/EntityIconContainer/Tribe/TribeCount
@onready var demon_icon : TextureRect = $CanvasLayer/GUI/EntityIconContainer/Demon/DemonIcon
@onready var demon_count : Label = $CanvasLayer/GUI/EntityIconContainer/Demon/DemonCount
@onready var gui : Control = $CanvasLayer/GUI
@onready var disregarded = preload("res://disreg.png")
@onready var offputting = preload("res://offput.png")
@onready var suspicious = preload("res://sus.png")
@onready var perfidious = preload("res://perf.png")
@onready var pause : Control = $CanvasLayer/PauseMenu

@onready var transition : ColorRect = $CanvasLayer/Transition
var tween : Tween 
const TRANSITION_TIME : float = 0.8

func update_tribe_count(count : int):
	tribe_count.text = str(count)
	
func update_demon_count(count : int):
	demon_count.text = str(count)
	
func show_gui():
	gui.show()
	
func hide_gui():
	gui.hide()
	
func show_pause():
	pause.show()
	
func hide_pause():
	pause.hide()
	
func update_sus_bar(value : float):
	if value < 0.1:
		sus_message.texture = disregarded
	elif value < 0.4:
		sus_message.texture = offputting
	elif value < 1:
		sus_message.texture = suspicious
	else:
		sus_message.texture = perfidious
		
	suspicion_bar.value = value

func fade(callback : Callable = func (): pass, to_black : bool = true):
	if tween:
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(transition, "color:a", 1.0 if to_black else 0, TRANSITION_TIME)
	tween.tween_callback(callback)
	
