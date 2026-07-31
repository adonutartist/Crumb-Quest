extends TextureButton
@export var insect_scene: PackedScene
@export var insect_icon: Texture2D
@export var cost := 10
@onready var sprite = $Sprite2D
@onready var cost_label = $CostLabel
func _ready():
	print("card ready:", name, cost)
	cost_label.text = str(cost)
	sprite.texture = insect_icon
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_unhover)
func _on_hover():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.08)
	tween.tween_property(self, "modulate", Color(1.12, 1.12, 1.12), 0.08)
func _on_unhover():
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "scale", Vector2.ONE, 0.08)
	tween.tween_property(self, "modulate", Color.WHITE, 0.08)
func _pressed():
	if GameManager.crumbs >= cost:
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(0.94, 0.94), 0.04)
		tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.05)
		tween.tween_property(self, "scale", Vector2.ONE, 0.04)
		GameManager.crumbs -= cost
		spawn_insect()
	else:
		var shake_tween = create_tween()
		shake_tween.set_trans(Tween.TRANS_SINE)
		shake_tween.set_ease(Tween.EASE_IN_OUT)
		var start = position
		shake_tween.tween_property(self, "position", start+Vector2(-8,0), 0.04)
		shake_tween.tween_property(self, "position", start+Vector2(8,0), 0.04)
		shake_tween.tween_property(self, "position", start+Vector2(-6,0), 0.04)
		shake_tween.tween_property(self, "position", start+Vector2(6,0), 0.04)
		shake_tween.tween_property(self, "position", start, 0.04)
func spawn_insect():
	var insect = insect_scene.instantiate()
	var world = get_tree().current_scene
	world.get_node("Ants").add_child(insect)
	insect.global_position = Vector2(-500,230)
