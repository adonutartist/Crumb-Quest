extends CanvasLayer
@onready var crumb_label = $TopRight/HBoxContainer/CrumbLabel
func _process(_delta):
	crumb_label.text = str(GameManager.crumbs)
