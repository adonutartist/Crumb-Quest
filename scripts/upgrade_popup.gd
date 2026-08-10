extends Control
var selected_ant = null
@onready var button = $UpgradeButton
@onready var cost_label = $UpgradeButton/CostLabel
func _ready():
	visible = false
	GameManager.creature_selected.connect(show_upgrade)
	button.pressed.connect(_on_upgrade_button_pressed)
	button.mouse_entered.connect(_on_hover)
	button.mouse_exited.connect(_on_unhover)
func _process(_delta):
	if selected_ant == null:
		return
	global_position = selected_ant.get_global_transform_with_canvas().origin + Vector2(-30,-60)
func show_upgrade(ant):
	if ant == null:
		selected_ant = null
		visible = false
		return
	if ant.max_evolution:
		selected_ant = null
		visible = false
		return
	selected_ant = ant
	visible = true
	cost_label.text = str(ant.upgrade_cost)
	global_position = ant.get_global_transform_with_canvas().origin + Vector2(-30, -60)
func _on_hover():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(button, "scale", Vector2(1.05, 1.05), 0.08)
	tween.tween_property(button, "modulate", Color(1.12, 1.12, 1.12), 0.08)
func _on_unhover():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(button, "scale", Vector2.ONE, 0.08)
	tween.tween_property(button, "modulate", Color.WHITE, 0.08)
func _on_upgrade_button_pressed():
	if selected_ant == null:
		return
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(0.94, 0.94), 0.04)
	tween.tween_property(button, "scale", Vector2(1.05, 1.05), 0.05)
	tween.tween_property(button, "scale", Vector2.ONE, 0.04)
	if GameManager.crumbs >= selected_ant.upgrade_cost:
		GameManager.crumbs -= selected_ant.upgrade_cost
		AudioManager.play_sfx("splat")
		selected_ant.upgrade()
		await get_tree().create_timer(0.10).timeout
		AudioManager.play_sfx("spawn_evolve")
		ProgressionManager.add_progress(4.0)
		print("PROGRESS AFTER EVOLUTION:", ProgressionManager.progress)
		visible = false
	else:
		var shake = create_tween()
		shake.set_trans(Tween.TRANS_SINE)
		shake.set_ease(Tween.EASE_IN_OUT)
		var start = button.position
		shake.tween_property(button, "position", start + Vector2(-8, 0), 0.04)
		shake.tween_property(button, "position", start + Vector2(8, 0), 0.04)
		shake.tween_property(button, "position", start + Vector2(-6, 0), 0.04)
		shake.tween_property(button, "position", start + Vector2(6, 0), 0.04)
		shake.tween_property(button, "position", start, 0.04)
