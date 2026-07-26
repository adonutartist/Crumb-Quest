extends Node2D
@export var speed := 100.0
var target_food: Node2D = null
@onready var animator = $Visual
@onready var sprite = $Visual/Sprite2D
var moving := false
func  _process(delta):
	find_food()
	if target_food:
		var distance = global_position.distance_to(target_food.global_position)
		if distance > 20:
			if not moving:
				animator.start_move()
				moving = true
			var direction = global_position.direction_to(target_food.global_position)
			global_position += direction * speed * delta
			sprite.flip_h = direction.x < 0
			animator.start_move()
		else:
			if moving:
				animator.stop_move()
				moving = false
			animator.stop_move()
	else:
		animator.stop_move()
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
