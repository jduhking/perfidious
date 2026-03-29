class_name Demon
extends Entity

@onready var detection_area : Area2D = $DetectionArea
var current_target : Tribesman 
const ATTACK_THRESHOLD : float = 8
@onready var demon_base_state : DemonBaseState = $FiniteStateMachine/DemonBaseState

	
