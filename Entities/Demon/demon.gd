class_name Demon
extends Entity
@onready var detection_area : Area2D = $DetectionArea
var current_target : Tribesman 
const ATTACK_THRESHOLD : float = 8
@onready var demon_base_state : DemonBaseState = $FiniteStateMachine/DemonBaseState

static var _radial_tex : ImageTexture
var body_light : PointLight2D

func _ready() -> void:
	_setup_light()

func _setup_light() -> void:
	body_light = PointLight2D.new()
	body_light.name = "BodyLight"
	if !_radial_tex:
		_radial_tex = _make_radial_texture(128)
	body_light.texture = _radial_tex
	body_light.texture_scale = 0.2
	body_light.energy = 0.8
	body_light.color = Color.WHITE
	add_child(body_light)

func _make_radial_texture(size: int) -> ImageTexture:
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	var center := Vector2(size / 2.0, size / 4.0)

	for y in size:
		for x in size:
			var dist := Vector2(x, y).distance_to(center) / (size / 2.0)
			var alpha := 1.0 - smoothstep(0.0, 1.0, dist)
			img.set_pixel(x, y, Color(1, 1, 1, alpha))

	return ImageTexture.create_from_image(img)
