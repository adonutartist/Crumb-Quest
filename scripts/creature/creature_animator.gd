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
	sprite.rotation_degrees = 0
	move_tween = create_tween()
	move_tween.set_loops()
	move_tween.set_parallel()
	move_tween.tween_property(sprite, "scale", Vector2(1.15, 0.85), 0.18)\
		.set_trans(Tween.TRANS_ELASTIC)\
		.set_ease(Tween.EASE_OUT)
	move_tween.tween_property(sprite, "rotation_degrees", 3, 0.18)\
		.set_trans(Tween.TRANS_ELASTIC)\
		.set_ease(Tween.EASE_OUT)
	move_tween.chain()
	move_tween.tween_property(sprite, "scale", Vector2(0.85, 1.15), 0.18)\
		.set_trans(Tween.TRANS_ELASTIC)\
		.set_ease(Tween.EASE_OUT)
	move_tween.tween_property(sprite, "rotation_degrees", -3, 0.18)\
		.set_trans(Tween.TRANS_ELASTIC)\
		.set_ease(Tween.EASE_OUT)
func stop_move():
	print("STOP MOVE")

	if move_tween:
		move_tween.kill()

	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(sprite, "scale", Vector2.ONE, 0.15)
	tween.tween_property(sprite, "rotation_degrees", 0, 0.15)

	sprite.play("idle")
