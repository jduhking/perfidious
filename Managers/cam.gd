class_name MainCamera
extends Camera2D

var follow_node : Node2D
var max_x : float = 320
var min_x : float = 0
var max_y : float = 180
var min_y : float = 0
var resolution : Vector2 = get_viewport_rect().size

func _ready() -> void:
	GameManager.cam = self
	
func _physics_process(delta: float) -> void:
	if follow_node:
		var half_width = resolution.x * 0.5
		var half_height = resolution.y * 0.5
		global_position = Vector2(clampf(follow_node.global_position.x, min_x + half_width , max_x - half_width), clampf(follow_node.global_position.y, min_y + half_height, max_y - half_height))
