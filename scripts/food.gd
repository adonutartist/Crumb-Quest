extends Area2D
@export var  value := 1
enum FoodType{
	APPLE,
	NACHOS
}
@export var food_type: FoodType
@export var max_hp := 100.0
var hp := 100.0
@onready var hp_bar = $HPBar
@onready var hp_fill = $HPBar/Fill
const EAT_PARTICLES = preload("res://scenes/eat_particles.tscn")
const FALL_DURATION := 1.0
var fall_speed := 250.0
var shadow: Node2D = null
var collected := false
var landed := false
var target_y := 0.0
var assigned_creatures := []
func _ready():
	add_to_group("food")
	hp = max_hp
	hp_bar.visible = false
	AudioManager.play_sfx("fall")
func  damage(amount):
	if !landed:
		return
	hp_bar.visible = true
	hp -= amount
	var particles = EAT_PARTICLES.instantiate()
	get_tree().current_scene.get_node("Effects").add_child(particles)
	particles.global_position = global_position
	particles.restart()
	particles.emitting = true
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
		GameManager.add_crumbs(value)
		queue_free()
func set_target_y(y: float):
	target_y = y
	var distance = abs(target_y - position.y)
	fall_speed = distance / FALL_DURATION
func  _process(delta):
	if collected:
		return
	if position.y < target_y:
		position.y += fall_speed * delta
		var progress = inverse_lerp(-500.0, target_y, position.y)
		if shadow:
			shadow.update_fall_progress(progress)
	else:
		position.y = target_y
		if !landed:
			landed = true
			AudioManager.play_sfx("land")
			if shadow:
				shadow.queue_free()
func can_be_eaten_by_more():
	return assigned_creatures.size() < 2
