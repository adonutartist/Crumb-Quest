extends Node2D
@onready var sprite: AnimatedSprite2D = $Sprite2D
var move_tween: Tween
func _ready():
	stop_move()
func start_move():
	sprite.stop()
	if move_tween:
		move_tween.kill()
	sprite.scale = Vector2.ONE
	sprite.position = Vector2.ZERO
	move_tween = create_tween()
	move_tween.set_loops()
	var up = move_tween.parallel()
	up.tween_property(sprite, "position", Vector2(0, -12), 0.12)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	up.tween_property(sprite, "scale", Vector2(1.12, 0.88), 0.12)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	var down = move_tween.parallel()
	down.tween_property(sprite, "position", Vector2.ZERO, 0.12)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	down.tween_property(sprite, "scale", Vector2(0.9, 1.1), 0.12)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)
	move_tween.tween_property(sprite, "scale", Vector2.ONE, 0.05)
func stop_move():
	if move_tween:
		move_tween.kill()
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(sprite, "scale", Vector2.ONE, 0.15)
	tween.tween_property(sprite, "position", Vector2(0,0), 0.15)
	sprite.play("idle")
