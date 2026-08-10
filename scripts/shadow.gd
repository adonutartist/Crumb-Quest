extends Node2D
@onready var sprite := $AnimatedSprite2D
func _ready():
	modulate.a = 0.4
	sprite.stop()
func update_fall_progress(progress: float):
	var frame_count = sprite.sprite_frames.get_frame_count("default")
	var frame = int(progress * frame_count)
	frame = clamp(frame, 0, frame_count - 1)
	sprite.frame = frame
