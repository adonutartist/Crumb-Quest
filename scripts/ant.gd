extends Node2D
@export var speed := 100.0
var target_food: Node2D = null
@onready var animator = $Visual
@onready var sprite = $Visual/Sprite2D
var sprite_material: ShaderMaterial
var moving := false
var bite_timer := 0.0
const BITE_INTERVAL := 0.4
func _ready():
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
			global_position += direction * speed * delta
			sprite.flip_h = direction.x < 0
			
		else:
			if moving:
				animator.stop_move()
				moving = false
			if is_instance_valid(target_food):
				bite_timer -= delta
				if bite_timer <= 0:
					bite_timer = BITE_INTERVAL
					target_food.damage(4)
	else:
		animator.stop_move()
	if target_food and !is_instance_valid(target_food):
		target_food = null
func  find_food():
	var foods = get_tree().get_nodes_in_group("food")
	if foods.is_empty():
		target_food = null
		return
	var closest_food = null
	var closest_distance = INF
	for food in foods:
		if not food.landed:
			continue
		var distance = global_position.distance_to(food.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_food = food
	target_food = closest_food
func set_selected(selected: bool):
	if sprite_material:
		sprite_material.set_shader_parameter("selected", selected)
func _on_detection_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		print("ant clicked")
		GameManager.select_creature(self)
