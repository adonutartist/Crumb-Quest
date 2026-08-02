extends Node2D
@onready var sprite := $AnimatedSprite2D
func _ready():
	modulate.a = 0.4
	sprite.play("default")
