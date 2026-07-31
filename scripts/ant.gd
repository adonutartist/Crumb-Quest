extends Node2D
@export var speed := 100.0
@export var upgrade_cost := 20
@export var upgrade_scene: PackedScene
@export var bite_damage := 4
var level := 1
var target_food: Node2D = null
@onready var animator = $Visual
@onready var sprite = $Visual/Sprite2D
var sprite_material: ShaderMaterial
var moving := false
var bite_timer := 0.0
const BITE_INTERVAL := 0.4
const ANT_SEPARATION_DISTANCE := 18.0
const SEPARATION_FORCE := 50.0
func _ready():
	add_to_group("ants")
	$Detection.input_event.connect(_on_detection_input_event)
	sprite.material = sprite.material.duplicate()
	sprite_material = sprite.material as ShaderMaterial
func  _process(delta):
	find_food()
	if target_food:
		var distance = global_position.distance_to(target_food.global_position)
		if distance > 50:
			if not moving:
				animator.start_move()
				moving = true
			var direction = global_position.direction_to(target_food.global_position)
			var separation = get_separation()
			var final_direction = (direction + separation).normalized()
			global_position += final_direction * speed * delta
			sprite.flip_h = direction.x < 0
		else:
			if moving:
				animator.stop_move()
				moving = false
			if is_instance_valid(target_food):
				bite_timer -= delta
				if bite_timer <= 0:
					bite_timer = BITE_INTERVAL
					target_food.damage(bite_damage)
	else:
		animator.stop_move()
	if target_food and !is_instance_valid(target_food):
		target_food = null
func  find_food():
	if target_food and self in target_food.assigned_creatures:
		target_food.assigned_creatures.erase(self)
	var foods = get_tree().get_nodes_in_group("food")
	if foods.is_empty():
		target_food = null
		return
	var closest_food = null
	var closest_distance = INF
	for food in foods:
		if not food.landed:
			continue
		if not food.can_be_eaten_by_more():
			continue
		var distance = global_position.distance_to(food.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_food = food
	if closest_food:
		target_food = closest_food
		target_food.assigned_creatures.append(self)
	else:
		target_food = null
func set_selected(selected: bool):
	if sprite_material:
		sprite_material.set_shader_parameter("selected", selected)
func _on_detection_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		GameManager.select_creature(self)
func get_separation() -> Vector2:
	var push := Vector2.ZERO
	var ants = get_tree().get_nodes_in_group("ants")
	for ant in ants:
		if ant == self:
			continue
		var distance = global_position.distance_to(ant.global_position)
		if distance < ANT_SEPARATION_DISTANCE:
			var away = ant.global_position.direction_to(global_position)
			push += away * (ANT_SEPARATION_DISTANCE - distance)
	return push * SEPARATION_FORCE / 100.0
func upgrade():
	if upgrade_scene == null:
		return
	var upgraded_ant = upgrade_scene.instantiate()
	get_parent().add_child(upgraded_ant)
	upgraded_ant.global_position = global_position
	queue_free()
