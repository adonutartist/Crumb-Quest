extends  Node2D
@export var beans_scene: PackedScene
@export var apple_scene: PackedScene
@export var nachos_scene: PackedScene
@export var  spawn_interval := 1.5
@export var max_food := 20
@export var shadow_scene: PackedScene
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
	var beans_weight := 70
	var apple_weight := 25
	var nachos_weight := 5
	for insect in get_tree().get_nodes_in_group("ants"):
		if insect.scene_file_path.ends_with("ladybug2.tscn"):
			apple_weight += 15
		elif insect.scene_file_path.ends_with("ladybug3.tscn"):
			nachos_weight += 20
	var total = beans_weight + apple_weight + nachos_weight
	var roll = randi_range(1, total)
	if roll <= beans_weight:
		return beans_scene
	elif roll <= beans_weight + apple_weight:
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
	var shadow = shadow_scene.instantiate()
	shadow.position = spawn_positon
	get_parent().get_node("Foods").add_child(shadow)
	food.position = Vector2(spawn_positon.x, -500)
	food.set_target_y(spawn_positon.y)
	food.shadow = shadow
	get_parent().get_node("Foods").add_child(food)

func get_valid_position():
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
