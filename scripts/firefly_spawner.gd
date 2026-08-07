extends Node2D
@export var firefly_scene: PackedScene
var active := false
func spawn_fireflies():
	if active:
		return
	active = true
	for i in randi_range(8,15):
		var f = firefly_scene.instantiate()
		f.position = Vector2(randf_range(-300,500),randf_range(-220,200))
		get_parent().get_node("CanvasLayer2/Fireflies").add_child(f)
func clear_fireflies():
	for c in get_parent().get_node("CanvasLayer2/Fireflies").get_children():
		c.queue_free()
	active = false
