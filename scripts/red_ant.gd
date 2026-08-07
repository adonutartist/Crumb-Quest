extends Node2D
@export var speed := 70.0
@export var bite_damage := 4
@export var max_hp := 20
@onready var animator = $Visual
@onready var sprite = $Visual/Sprite2D
var hp := max_hp
var target: Node2D = null
var moving := false
var bite_timer := 0.0
const BITE_INTERVAL := 0.4
const ANT_SEPARATION_DISTANCE := 18.0
const SEPARATION_FORCE := 50.0
func _ready():
	add_to_group("enemies")
	target = get_tree().current_scene.get_node("SpawnPoint/AntHill")
func  _process(delta):
	if target == null:
		return
	var distance = global_position.distance_to(target.global_position)
	if distance > 40:
		if !moving:
			animator.start_move()
			moving = true
		var direction = global_position.direction_to(target.global_position)
		var separation = get_separation()
		var final_direction = (direction + separation).normalized()
		global_position += final_direction * speed * delta
		sprite.flip_h = direction.x < 0
	else:
		if moving:
			animator.stop_move()
			moving = false
		bite_timer -= delta
		if bite_timer <= 0:
			bite_timer = BITE_INTERVAL
			target.damage(bite_damage)
func get_separation() -> Vector2:
	var push := Vector2.ZERO
	var ants = get_tree().get_nodes_in_group("enemies")
	for ant in ants:
		if ant == self:
			continue
		var distance = global_position.distance_to(ant.global_position)
		if distance < ANT_SEPARATION_DISTANCE:
			var away = ant.global_position.direction_to(global_position)
			push += away * (ANT_SEPARATION_DISTANCE - distance)
	return push * SEPARATION_FORCE / 100.0
func damage(amount):
	hp -= amount
	if hp <= 0:
		queue_free()
