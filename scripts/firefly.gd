extends Node2D
@onready var sprite = $Sprite2D
@export var speed := 2.0
@export var drift_strength := 200.0
const AREA_LEFT := -300
const AREA_RIGHT := 500
const AREA_TOP := -250
const AREA_BOTTOM := 250
var target := Vector2.ZERO
var blink := randf() * TAU
var drift := Vector2.ZERO
func _ready():
	pick_target()
func pick_target():
	target = Vector2(
		randf_range(AREA_LEFT, AREA_RIGHT),
		randf_range(AREA_TOP, AREA_BOTTOM)
	)
	drift = Vector2(
		randf_range(-1,1),
		randf_range(-1,1)
	).normalized()
func _process(delta):
	blink += delta * 5.0
	sprite.modulate.a = 0.5 + sin(blink) * 0.5
	if global_position.distance_to(target) < 10:
		pick_target()
	var direction = (target - global_position).normalized()
	global_position += direction * speed * delta
	global_position += drift * drift_strength * sin(Time.get_ticks_msec() / 1000.0) * delta
