extends Node2D
@export var leaf_scene: Array[PackedScene]
func _ready():
	var timer = Timer.new()
	timer.wait_time = randf_range(3.0, 7.0)
	timer.timeout.connect(spawn_leaf)
	add_child(timer)
	timer.start()
func spawn_leaf():
	var leaf = leaf_scene.pick_random().instantiate()
	add_child(leaf)
	leaf.position = Vector2(-200, randf_range(-200, 300))
	leaf.direction = Vector2(randf_range(0.8, 1.2), randf_range(-0.2, 0.2)).normalized()
