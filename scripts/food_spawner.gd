extends  Node2D
@export var beans_scene: PackedScene
@export var apple_scene: PackedScene
@export var nachos_scene: PackedScene
@export var  spawn_interval := 1.5
@export var max_food := 20
const MIN_DISTANCE := 80.0
const  AREA_LEFT := -300
const  AREA_RIGHT := 500
const AREA_TOP := -250
const  AREA_BOTTOM := 250
func _ready():
	randomize()
	var timer := Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(spawn_food)
	add_child(timer)
func get_random_food() -> PackedScene:
	var roll = randi_range(1, 100)
	if roll <= 70:
		return beans_scene
	elif roll <= 95:
		return apple_scene
	else:
		return nachos_scene
func spawn_food():
	var current_food = get_tree().get_nodes_in_group("food")
	if current_food.size() >= max_food:
		return
	var spawn_positon = get_valid_position()
	if spawn_positon == null:
		print("No valid position")
		return
	var food = get_random_food().instantiate()
	food.position = Vector2(spawn_positon.x, -500)
	food.target_y = spawn_positon.y
	get_parent().get_node("Foods").add_child(food)

func get_valid_position():
	print("checking", get_tree().get_nodes_in_group("food").size(), "food")
	for i in range(50):
		var pos = Vector2(randf_range(AREA_LEFT, AREA_RIGHT), randf_range(AREA_TOP, AREA_BOTTOM))
		var valid = true
		var existing_food = get_tree().get_nodes_in_group("food")
		for food in existing_food:
			if not food.landed:
				continue
			if pos.distance_to(food.position) < MIN_DISTANCE:
				valid = false
				break
		if valid:
			return pos
	return null
