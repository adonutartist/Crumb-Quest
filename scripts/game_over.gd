extends Control
@onready var result_label: Label = $ResultLabel
@onready var restart_button: Button = $RestartButton
@onready var fun_button: Button = $FunButtonBox
@onready var restart_animation: AnimatedSprite2D = $FunButton
func _ready():
	visible = false
	restart_button.pressed.connect(_on_restart_pressed)
	fun_button.pressed.connect(_on_fun_pressed)
func show_game_over(won: bool):
	visible = true
	restart_animation.play("default")
	if won:
		result_label.text = "YOU WIN BROSKI!"
	else:
		result_label.text = "YOU LOSE LOL GGs!"
func _on_restart_pressed():
	GameManager.reset_game()
	ProgressionManager.reset_game()
	get_tree().reload_current_scene()
func _on_fun_pressed():
	visible = false
#func _input(event):
	#if event is InputEventKey and event.pressed and not event.echo:
	#	if event.keycode == KEY_F1:
	#		show_game_over(false)
	#	elif event.keycode == KEY_F2:
	#		show_game_over(true)
