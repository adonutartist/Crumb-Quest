extends  Node2D
@onready var left = $BladeLeft
@onready var right = $BladeRight
var t := randf() * TAU
var left_amp := randf_range(4.0, 6.0)
var right_amp := randf_range(3.0, 5.0)
var phase := randf_range(0.5, 1.2)
var insect_bend := 0.0
func _process(delta):
	t += delta * 2.0
	left.rotation = sin(t) * deg_to_rad(left_amp * 0.35) + insect_bend
	right.rotation = sin(t + phase) * deg_to_rad(right_amp * 0.35) + insect_bend
	var left_brightness = 1.0 + (left.rotation / deg_to_rad(left_amp)) * 0.08
	var right_brightness = 1.0 + (right.rotation / deg_to_rad(right_amp)) * 0.08
	left.modulate = Color(0.95 * left_brightness, left_brightness, 0.95 * left_brightness)
	right.modulate = Color(0.95 * right_brightness, right_brightness, 0.95 * right_brightness)
	for ant in get_tree().get_nodes_in_group("ants"):
		if global_position.distance_to(ant.global_position) < 20:
			if ant.sprite.flip_h:
				bend_for_insect(-1)
			else:
				bend_for_insect(1)
func bend_for_insect(direction: float):
	insect_bend = deg_to_rad(15) * direction
	var tween = create_tween()
	tween.tween_property(self, "insect_bend", 0.0, 0.4).set_trans(Tween.TRANS_SINE)
