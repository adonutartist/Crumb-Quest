extends Node2D
enum State{
	IDLE,
	MOVE
}
var state = State.IDLE
var current_tween: Tween
@onready var sprite: Sprite2D = $Sprite2D
func _ready():
	play_idle()
func play_idle():
	state = State.IDLE
	if current_tween:
		current_tween.kill()
	current_tween = create_tween()
	current_tween.set_loops()
	current_tween.tween_property(sprite, "scale", Vector2(1.1, 0.9), 0.35).set_trans(Tween.TRANS_SINE)
	current_tween.tween_property(sprite, "scale", Vector2(0.9, 1.1), 0.35).set_trans(Tween.TRANS_SINE)
