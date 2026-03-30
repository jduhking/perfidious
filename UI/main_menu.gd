extends Control


@onready var start_texture : TextureRect = $MiddleCenter/Start
var started : bool = false
@onready var title_screen_music : AudioStreamPlayer2D = $TitleScreenMusic
@onready var proceed : AudioStreamPlayer2D	= $Proceed

var tween : Tween 
func _ready():
	pass
	#title_screen_music.play()
	#$ColorRect/VBoxContainer/startText/Timer.start()
	
	


func _on_timer_timeout():
	if start_texture.modulate.a == 1.0:
		start_texture.modulate.a = 0.0
	else:
		start_texture.modulate.a = 1.0
		
func _process(delta: float) -> void:
	if Input.is_anything_pressed() and !started:
		started = true
		#title_screen_music.stop()
		_on_start_pressed()
		#proceed.play()

func _on_start_pressed():

	UIManager.fade(GameManager.load_level.bind(0))
