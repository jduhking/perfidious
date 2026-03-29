extends Node

@onready var suspicion_bar : ProgressBar = $CanvasLayer/GUI/MarginContainer/SusBar


func update_sus_bar(value : float):
	suspicion_bar.value = value
