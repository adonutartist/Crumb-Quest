extends Control
@onready var close_button = $Panel/CloseHitBox
@onready var close_animation: AnimatedSprite2D = $Panel/CloseButton
func _ready():
	visible = false
	close_animation.play("default")
	close_button.pressed.connect(close_tutorial)
func open_tutorial():
	visible = true
func close_tutorial():
	visible = false
