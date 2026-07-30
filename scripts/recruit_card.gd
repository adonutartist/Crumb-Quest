extends TextureButton
@export var insect_scene: PackedScene
@export var cost := 10
@onready var sprite = $Sprite2D
@onready var cost_label = $CostLabel
func _ready():
	print("card ready:", name, cost)
	cost_label.text = str(cost)
func _pressed():
	if GameManager.crumbs >= cost:
		GameManager.crumbs -= cost
		spawn_insect()
	else:
		print("Not enough crumbs")
func spawn_insect():
	var insect = insect_scene.instantiate()
	var world = get_tree().current_scene
	world.get_node("Ants").add_child(insect)
	insect.global_position = Vector2(0,0)
