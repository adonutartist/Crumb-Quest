extends Node2D
@onready var sprite: AnimatedSprite2D = $Sprite2D
var move_tween: Tween
var moving := false
func _ready():
	stop_move()
func start_move():
	if moving:
		return
	moving = true
	sprite.stop()
	if move_tween:
		move_tween.kill()
	sprite.scale = Vector2.ONE
	sprite.position = Vector2.ZERO
	play_walk_cycle()
func play_walk_cycle():
	if not moving:
		return
	move_tween = create_tween()
	move_tween.tween_property(sprite, "position", Vector2(0, -12), 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	move_tween.parallel().tween_property(sprite, "scale", Vector2(1.12, 0.88), 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	move_tween.tween_property(sprite, "position", Vector2.ZERO, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	move_tween.parallel().tween_property(sprite, "scale", Vector2(0.9, 1.1), 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	move_tween.tween_property(sprite, "scale", Vector2.ONE, 0.05)
	
	move_tween.tween_callback(_on_landing)
func _on_landing():
	if not moving:
		return
	AudioManager.play_sfx("scuttle")
	play_walk_cycle()
func stop_move():
	moving = false
	if move_tween:
		move_tween.kill()
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(sprite, "scale", Vector2.ONE, 0.15)
	tween.tween_property(sprite, "position", Vector2.ZERO, 0.15)
	if sprite.sprite_frames != null:
		if sprite.sprite_frames.has_animation("idle"):
			sprite.play("idle")
