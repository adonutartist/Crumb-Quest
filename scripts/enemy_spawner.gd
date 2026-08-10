extends Node2D
@export var red_ant_scene: PackedScene
@export var big_red_ant_scene: PackedScene
@export var fat_red_ant_scene: PackedScene
const SPAWN_LEFT := -300
const SPAWN_RIGHT := 500
const SPAWN_Y := -400
func spawn_enemy(type:String):
	print("Trying to spawn: ", type)
	var enemy
	match type: 
		"red": enemy = red_ant_scene.instantiate()
		"big_red": enemy = big_red_ant_scene.instantiate()
		"fat_red": enemy = fat_red_ant_scene.instantiate()
		_:
			push_error("Unknown enemy type: " + type)
			return
	enemy.position = Vector2(randf_range(SPAWN_LEFT, SPAWN_RIGHT), SPAWN_Y)
	get_parent().get_node("Enemies").add_child(enemy)
	GameManager.enemy_spotted.emit(enemy)
func spawn_wave(enemy_list:Array):
	for enemy_type in enemy_list:
		spawn_enemy(enemy_type)
func _ready():
	ProgressionManager.checkpoint_reached.connect(_on_checkpoint_reached)
func _on_checkpoint_reached(id):
	match id:
		0:
			print("WAVE 1")
			spawn_wave([
				"red",
				"red",
				"red",
				"red",
				"red"
			])
		1:
			print("WAVE 2")
			spawn_wave([
				"fat_red",
				"fat_red",
				"fat_red",
				"red",
				"red"
			])
		2:
			print("BOSS")
			spawn_wave([
				"big_red"
			])
