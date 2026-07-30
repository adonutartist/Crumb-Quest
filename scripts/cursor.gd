extends Node2D
@export var normal_texture: Texture2D
@export var click_texture: Texture2D
@onready var sprite = $CursorSprite
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	sprite.texture = normal_texture
func _process(_delta):
	global_position = get_global_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		sprite.texture = click_texture
	else:
		sprite.texture = normal_texture
