extends Node2D
@onready var sprite: AnimatedSprite2D = $Sprite2D
var move_tween: Tween
func _ready():
	stop_move()
func start_move():
	sprite.stop()
	if move_tween:
		move_tween.kill()
	scale = Vector2.ONE
	move_tween = create_tween()
	move_tween.set_loops()
	move_tween.tween_property(self, "scale", Vector2(1.15, 0.85), 0.15).set_trans(Tween.TRANS_ELASTIC)
	move_tween.tween_property(self, "scale", Vector2(0.85, 1.15), 0.15).set_trans(Tween.TRANS_ELASTIC)
func stop_move():
	if move_tween:
		move_tween.kill()
	scale = Vector2.ONE
	sprite.play("idle")
