class_name Arrow
extends Area2D

var direction : Vector2
@export var attack_damage : float = 1
@export var speed : float = 120

func _ready() -> void:
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)

func init(spawn_point : Vector2, dir : Vector2):
	direction = dir
	global_position = spawn_point
	rotation = atan2(dir.y, dir.x)
	
func _physics_process(delta: float) -> void:
	global_position += speed * direction * delta
	rotation = atan2(direction.y, direction.x)
	var collisions = get_overlapping_bodies().filter(func (x : Entity): return x != null)
	if collisions.size() > 0:
		var entity := collisions[0] as Entity
		if entity is not Tribesman:
			entity.damage(attack_damage, direction)
	
