class_name Level
extends Node2D

@onready var max_x : float = $Bounds/MaxX.global_position.x
@onready var min_x : float = $Bounds/MinX.global_position.x
@onready var max_y : float = $Bounds/MaxY.global_position.y
@onready var min_y : float = $Bounds/MinY.global_position.y

@onready var interest_points : Array = $InterestPoints.get_children()

func _ready() -> void:
	GameManager.current_level = self
	GameManager.min_x = min_x
	GameManager.max_x = max_x
	GameManager.min_y = min_y
	GameManager.max_y = max_y
	Tribesman.current_group_interest_point = interest_points[0]
