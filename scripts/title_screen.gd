extends Control
@onready var game_name1: AnimatedSprite2D = $GameName1
@onready var game_name2: AnimatedSprite2D = $GameName2
@onready var play_animation: AnimatedSprite2D = $PlayButton
@onready var tutorial_animation: AnimatedSprite2D = $TutorialButton
@onready var play_button: Button = $PlayHitBox
func _ready():
	game_name1.play("default")
	game_name2.play("default")
	play_animation.play("default")
	tutorial_animation.play("default")
	play_button.pressed.connect(_on_play_pressed)
func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/World.tscn")
