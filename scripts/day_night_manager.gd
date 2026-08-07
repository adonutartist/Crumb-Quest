extends Node
signal day_started
signal night_started
@onready var overlay: ColorRect = $"../CanvasLayer/NightOverlay"
@onready var fireflies = $"../FireflySpawner"
@export var day_length := 20.0
@export var night_length := 60.0
var is_day := true
var timer := 0.0
var day_count := 1
func _ready():
	print("DAYNIGHTMANAGER starting")
func _process(delta):
	timer += delta
	if is_day:
		if timer >= day_length:
			start_night()
	else:
		if timer >= night_length:
			start_day()
func start_day():
	is_day = true
	timer = 0
	day_count += 1
	var new_color = overlay.color
	new_color.a = 0.0
	var tween = create_tween()
	tween.tween_property(overlay, "color", new_color, 3.0)
	print("DAY", day_count)
	fireflies.clear_fireflies()
	day_started.emit()
func  start_night():
	is_day = false
	timer = 0
	var new_color = overlay.color
	new_color.a = 0.8
	var tween = create_tween()
	tween.tween_property(overlay, "color", new_color, 3.0)
	print("NIGHT")
	fireflies.spawn_fireflies()
	night_started.emit()
