extends Node2D
@export var max_hp := 100
var hp := 100.0
@onready var hp_bar = $HPBar
@onready var hp_fill = $HPBar/Fill
func _ready():
	hp = max_hp
	hp_bar.visible = false
func damage(amount):
	hp_bar.visible = true
	hp -= amount
	hp = clamp(hp, 0.0, max_hp)
	var ratio = hp / max_hp
	if ratio > 0.75:
		hp_fill.modulate = Color("#63e05b")
	elif ratio > 0.50:
		hp_fill.modulate = Color("#a8e64c")
	elif ratio > 0.25:
		hp_fill.modulate = Color("#ffd93d")
	else:
		hp_fill.modulate = Color("#ff5c5c")
	hp_fill.region_rect.size.x = 30 * ratio
	if hp <= 0:
		print("Game Over")
