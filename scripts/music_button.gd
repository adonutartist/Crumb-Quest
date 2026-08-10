extends TextureButton
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
func _ready():
	pressed.connect(_on_pressed)
	update_icon()
func _process(_delta):
	if not sprite.is_playing():
		sprite.play()
func _on_pressed():
	print("msuic button clicked")
	AudioManager.toggle_audio()
	update_icon()
func update_icon():
	if AudioManager.audio_enabled:
		sprite.play("music_on")
	else:
		sprite.play("music_off")
