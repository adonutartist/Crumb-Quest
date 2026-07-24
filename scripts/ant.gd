extends Node2D
@onready var  sprite: Sprite2D = $Sprite2D
func _ready():
	idle_loop()
func idle_loop():
	while true: 
		var tween = create_tween() 
		tween.set_parallel() 
		tween.tween_property(sprite, "scale", Vector2(1.08, 0.92), 0.18).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(sprite, "rotation_degrees", 3, 0.18)
		await tween.finished
		tween = create_tween()
		tween.set_parallel()
		tween.tween_property(sprite, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(sprite, "rotation_degrees", 0, 0.25)
		await  tween.finished
		await get_tree().create_timer(randf_range(0.8, 2.0)).timeout
