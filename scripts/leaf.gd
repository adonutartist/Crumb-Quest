extends Node2D
var speed := 30.0
var acceleration := 0.0
var rotation_speed := 0.0
var wave := 0.0
var wave_speed := 0.0
var direction := Vector2.RIGHT
func _ready():
	speed = randf_range(20.0, 50.0)
	acceleration = randf_range(5.0, 20.0)
	rotation_speed = randf_range(-3.0, 3.0)
	wave = randf_range(0, TAU)
	wave_speed = randf_range(1.0, 3.0)
	scale *= randf_range(0.7, 1.2)
func _process(delta):
	speed += acceleration * delta
	wave += wave_speed * delta
	position += direction * speed * delta
	position.y += sin(wave) * 20.0 * delta
	rotation += rotation_speed * delta
	if position.x > 1200 or position.x < -200:
		queue_free()
