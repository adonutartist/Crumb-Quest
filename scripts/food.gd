extends Area2D
@export var  value := 1
const FALL_SPEED := 250.0
var collected := false
var landed := false
var target_y := 0.0
func _ready():
	add_to_group("food")
func  _process(delta):
	if collected:
		return
	if position.y < target_y:
		position.y += FALL_SPEED * delta
	else:
		landed = true
