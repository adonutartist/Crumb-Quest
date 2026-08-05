extends Node2D
@export var speed := 12.0
func _ready():
	speed = randf_range(8.0, 18.0)
	scale *= randf_range(3.6, 6.3)
	rotation_degrees = randf_range(-2.0, 2.0)
	$OuterShadow.modulate.a = randf_range(0.12, 0.18)
	$InnerShadow.modulate.a = randf_range(0.26, 0.34)
func _process(delta):
	position.x += speed * delta
	if position.x > 1200:
		position.x = -1200
